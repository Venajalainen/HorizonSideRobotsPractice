include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")
include("../Exercise 37/northern_frontier.jl")

mutable struct Checker <: CoordFamily
    robot :: SampleRobot
    x :: Int
    y :: Int
    outside :: Bool
    Checker( robot :: CoordFamily, (x,y) :: NTuple{2,Int})=new( robot , x,y , true)
    #Checker( robot :: Union{Robot,SampleRobot}, (x,y) :: NTuple{2,Int})=new( CoordRobot(robot) , x,y , true)
end

function HorizonSideRobots.isborder( robot :: Checker , side :: HorizonSide) 
    if robot.outside && get_coords(robot) == (robot.x,robot.y) && side == Nord
        if side==Nord
            robot.outside=!isborder(get_robot(robot),Nord)
        end
    end
    isborder( get_robot(robot), side )
end

function amioutside( robot :: Union{Robot,CoordFamily}; side = nothing :: Union{HorizonSide,Nothing}) 
    ncoord=northern_frontier( robot; side=side )
    checker=Checker(robot, ncoord)
    if side!==nothing brobot=BorderRobot( checker, side ) else brobot=BorderRobot( checker ) end
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
