include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")

mutable struct NorthernRobot{RobotType} <: CoordFamily

    robot :: RobotType
    Ny :: Int
    rotation :: Rotation

    function NorthernRobot{RobotType}( robot :: RobotType ; side :: Union{HorizonSide, Nothing} = nothing) where RobotType <: Union{ Robot , SampleRobot}

        new_robot = typeof(robot) <: CoordFamily ? robot : CoordRobot( robot )
        Ny :: Int =0
        rotation :: Rotation = get_rotation( BorderRobot( robot , side ) )

        new{typeof(new_robot)}( new_robot , Ny, rotation )

    end

end

function HorizonSideRobots.move!(robot :: NorthernRobot, side :: HorizonSide)

    x, y = get_coords(robot)
    borderwall :: HorizonSide = robot.rotation == Right ? right!( side ) : left!( side )

    (x==0 && isborder(robot, borderwall)) && ( robot.Ny = max( robot.Ny , y ) )

    move!(get_robot(robot),side)

end

get_Ncoords( robot :: NorthernRobot) = ( 0 , robot.Ny )

function northern_frontier( robot :: RobotType; side = nothing :: Union{HorizonSide,Nothing} ) where RobotType <: Union{Robot, SampleRobot}

    northern :: NorthernRobot = NorthernRobot{RobotType}( robot ; side=side )

    around_the_world!( northern ; side=side )

    return get_Ncoords( northern )
end