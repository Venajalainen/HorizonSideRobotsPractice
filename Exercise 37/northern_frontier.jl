include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")

mutable struct NorthernRobot <: AbstractCoordRobots
    robot :: CoordRobot
    Ny :: Int
    NorthernRobot(robot :: Union{SampleRobot,Robot} ) = new( CoordRobot( robot ) , 0 )
end

function HorizonSideRobots.move!(robot :: NorthernRobot, side :: HorizonSide)
    x, y=get_coords(robot)
    x==0 && ( robot.Ny = max( robot.Ny , y ) )
    move!(get_robot(robot),side)
end

get_northern_coords( robot :: BorderRobot) = get_northern_coords(get_robot( robot ) )
get_northern_coords( robot :: NorthernRobot) = ( 0 , robot.Ny )

function northern_frontier( robot :: Robot )
    brobot=BorderRobot( NorthernRobot( robot ) )
    around_the_world!( brobot )
    return get_northern_coords( brobot )
end