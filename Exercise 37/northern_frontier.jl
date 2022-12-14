include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")

mutable struct NorthernRobot{RobotType} <: CoordFamily

    robot :: RobotType
    Ny :: Int
    rotation :: Rotation
    outside :: Bool

    function NorthernRobot{RobotType}( robot :: RobotType ; side :: Union{HorizonSide, Nothing} = nothing) where RobotType <: Union{ Robot , SampleRobot}

        new_robot = typeof(robot) <: CoordFamily ? robot : CoordRobot( robot )
        Ny :: Int =0
        rotation :: Rotation = get_rotation( BorderRobot{RobotType}( robot ; side ) )
        outside :: Bool = !isborder( robot , Nord)

        new{typeof(new_robot)}( new_robot , Ny, rotation, outside )

    end

end

function HorizonSideRobots.move!(robot :: NorthernRobot, side :: HorizonSide)

    x, y = get_coords(robot)
    borderwall :: HorizonSide = robot.rotation == Right ? right!( side ) : left!( side )

    (x==0 && isborder(robot, borderwall)) && ( robot.Ny = max( robot.Ny , y ) )

    if get_coords(robot) == get_Ncoords(robot)
        if isborder( robot , borderwall) && borderwall in [Nord, Sud]
            robot.outside = Sud==borderwall
        end
        if all(isborder(robot, x) for x in [borderwall, inverse(side)])
            robot.outside=!isborder(robot,Nord)
        end
    end

    move!(get_robot(robot),side)

end

get_Ncoords( robot :: NorthernRobot) = ( 0 , robot.Ny )
get_verdict( robot :: NorthernRobot) = robot.outside

function northern_frontier( robot :: RobotType; side = nothing :: Union{HorizonSide,Nothing} ) where RobotType <: Union{Robot, SampleRobot}

    northern :: NorthernRobot = NorthernRobot{RobotType}( robot ; side=side )

    around_the_world!( northern ; side=side )

    get_verdict( northern ) |> println

    return get_Ncoords( northern )
end