include("../RobotHell.jl")

using HorizonSideRobots

@enum Rotation Right = 0 Left = 1

mutable struct BorderRobot <: SampleRobot
    robot :: AbstractCoordRobots
    rotation :: Rotation
    direction :: HorizonSide
    initial_direction :: HorizonSide
    function BorderRobot( robot :: Union{AbstractCoordRobots,Robot} )
        side :: HorizonSide = Nord
        trapped :: Bool = true
        if typeof(robot) <: Robot robot=CoordRobot(robot) end
        for i in 1:4
            trapped = ( trapped && isborder( robot , side ) )
            if !isborder( robot , side ) && isborder( robot , right!( side ) )
                return new(  robot , Right , side , side ) 
            end
            side = right!( side )
        end
        if trapped return new(  robot , Right , Nord , Nord ) end
        throw( BadStartingCondition() )
    end
end

get_coords( robot :: BorderRobot ) = get_coords( get_robot( robot ) )

get_direction( robot :: BorderRobot ; initial = false ) = if initial robot.initial_direction else robot.direction end
get_rotation( robot :: BorderRobot ) = robot.rotation
get_borderwall( robot :: BorderRobot ) = ( get_rotation( robot ) == Right ? right!( robot ) : left!( robot ) )

right!( side :: HorizonSide ) :: HorizonSide = anticlockwise( side )
right!( robot :: BorderRobot ) :: HorizonSide = anticlockwise( get_direction(robot) )

left!( side :: HorizonSide ) :: HorizonSide = clockwise( side )
left!( robot :: BorderRobot ) :: HorizonSide = clockwise( get_direction(robot) )

function rotate!(robot :: BorderRobot )
    robot.direction = get_borderwall( robot )
end

function change_rotation!( robot :: BorderRobot )
    robot.direction = inverse( get_direction( robot ) )
end


HorizonSideRobots.isborder( robot :: BorderRobot ) :: Bool =isborder( robot, get_direction(robot) )

function along!( robot :: BorderRobot , steps :: Int; rotation :: Rotation = Right) :: Nothing
    rotation == Left && change_rotation!( robot )
    while steps>0 
        move!( robot ); steps -= 1 
    end
end

function along!( cond :: Function, robot :: BorderRobot, ; rotation :: Rotation = Right) :: Nothing
    rotation == Left && change_rotation!( robot )
    while cond( robot )
        move!( robot )
    end
end

function along!( cond :: Function , robot :: BorderRobot, steps :: Int ; rotation :: Rotation = Right) :: Union{Int, Nothing} 
    rotation == Left && change_rotation!( robot )
    while cond( robot ) && steps>0 
        move!( robot ); steps -= 1 
    end
    steps>0 && return steps
end

function around_the_world!( robot :: BorderRobot )
    move!( robot )
    along!((x...)-> ( get_coords( robot ) != ( 0,0 ) || get_direction( robot ) != get_direction( robot ; initial = true ) ) , robot )
end

#it works
function need_move(robot :: BorderRobot, wallside :: HorizonSide) :: Bool
    if !isborder( robot, wallside ) && !isborder( robot )
        rotate!( robot ) ; return true
    end
    if ( !isborder( robot, right!( robot ) ) || !isborder( robot, left!( robot ) ) ) && isborder( robot )
        if isborder( robot, ( get_rotation( robot ) == Right ? right!( robot ) : left!( robot ) ) )
            robot.direction=( get_rotation( robot ) == Right ? left!( robot ) : right!( robot ) )
            return false
        end
    end
    i=0
    while isborder( robot ) && i<4
        rotate!( robot )
        i+=1
    end
    return i<=1
end

#move or rotate till the ability
function HorizonSideRobots.move!( robot :: BorderRobot)
    wallside = get_borderwall( robot )
    if need_move( robot ,wallside ) != false
        move!(robot, get_direction( robot ))
    end
end

#CustomErrors

struct BadStartingCondition <: Exception
    msg :: String
    BadStartingCondition() = "No border around"
end