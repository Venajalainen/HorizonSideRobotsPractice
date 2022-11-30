include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")

mutable struct NorthernRobot <: CoordFamily
    robot :: SampleRobot
    Ny :: Int
    rotation :: Rotation
    NorthernRobot(robot :: Union{Robot,SampleRobot} ) = new( CoordRobot( robot ) , 0, Right )
    NorthernRobot(robot :: CoordFamily ) = new( robot  , 0 , Right)
end

get_rotation( robot :: NorthernRobot ) = robot.rotation
get_borderwall( robot :: NorthernRobot, side :: HorizonSide ) = ( get_rotation( robot ) == Right ? right!( side ) : left!( side ) )

function HorizonSideRobots.move!(robot :: NorthernRobot, side :: HorizonSide)
    x, y=get_coords(robot)
    (x==0 && isborder(robot, get_borderwall(robot,side))) && ( robot.Ny = max( robot.Ny , y ) )
    move!(get_robot(robot),side)
end

get_northern_coords( robot :: BorderRobot) = get_northern_coords(get_robot( robot ) )
get_northern_coords( robot :: NorthernRobot) = ( 0 , robot.Ny )

function northern_frontier( robot :: Union{Robot,CoordFamily}; side = nothing :: Union{HorizonSide,Nothing} )
    northern=NorthernRobot( robot )
    if side!==nothing brobot=BorderRobot( northern, side ) else brobot=BorderRobot( northern ) end
    northern.rotation=get_rotation(brobot)
    around_the_world!( brobot )
    return get_northern_coords( brobot )
end