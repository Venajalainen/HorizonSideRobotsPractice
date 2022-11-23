include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")

mutable struct NorthernRobot <: CoordFamily
    robot :: SampleRobot
    Ny :: Int
    #NorthernRobot(robot :: Union{Robot,SampleRobot} ) = new( CoordRobot( robot ) , 0 )
    NorthernRobot(robot :: CoordFamily ) = new( robot  , 0 )
end

function HorizonSideRobots.move!(robot :: NorthernRobot, side :: HorizonSide)
    x, y=get_coords(robot)
    x==0 && ( robot.Ny = max( robot.Ny , y ) )
    move!(get_robot(robot),side)
end

get_northern_coords( robot :: BorderRobot) = get_northern_coords(get_robot( robot ) )
get_northern_coords( robot :: NorthernRobot) = ( 0 , robot.Ny )

function northern_frontier( robot :: Union{Robot,CoordFamily}; side = nothing :: Union{HorizonSide,Nothing} )
    if side!==nothing brobot=BorderRobot( NorthernRobot( robot ), side ) else brobot=BorderRobot( NorthernRobot( robot ) ) end
    around_the_world!( brobot )
    return get_northern_coords( brobot )
end