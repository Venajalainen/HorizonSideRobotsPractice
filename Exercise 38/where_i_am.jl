include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")
include("../Exercise 37/northern_frontier.jl")

mutable struct Checker <: CoordFamily
    robot :: SampleRobot
    x :: Int
    y :: Int
    outside :: Bool
    rotation :: Rotation
    Checker( robot :: CoordFamily, (x,y) :: NTuple{2,Int})=new( robot , x,y , true, Right)
    Checker( robot :: Union{Robot,SampleRobot}, (x,y) :: NTuple{2,Int})=new( CoordRobot(robot) , x,y , true, Right)
end

get_rotation( robot :: Checker ) = robot.rotation
get_borderwall( robot :: Checker, side :: HorizonSide ) = ( get_rotation( robot ) == Right ? right!( side ) : left!( side ) )

function HorizonSideRobots.isborder( robot :: Checker , side :: HorizonSide) 
    r=get_robot(robot); borderwall=get_borderwall(robot,side)
    if get_coords(robot) == (robot.x,robot.y) && isborder(r,borderwall) && borderwall==Nord
        robot.outside=false
    end
    isborder( r, side )
end

function amioutside( robot :: Union{Robot,CoordFamily}; side = nothing :: Union{HorizonSide,Nothing}) 
    ncoord=northern_frontier( robot; side=side )
    checker=Checker(robot, ncoord)
    if side!==nothing brobot=BorderRobot( checker, side ) else brobot=BorderRobot( checker ) end
    checker.rotation=get_rotation( brobot )
    around_the_world!(brobot)
    return checker.outside
end

function where_i_am( robot :: Union{Robot,CoordFamily} )
    if amioutside(robot)
        return "I am outside" 
    else
        return "I am inside" 
    end
end
