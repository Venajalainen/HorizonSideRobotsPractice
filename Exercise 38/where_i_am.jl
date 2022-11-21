include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")
include("../Exercise 37/northern_frontier.jl")

mutable struct Checker <: AbstractCoordRobots
    robot :: SampleRobot
    x :: Int
    y :: Int
    inside :: Bool
    Checker( robot :: Union{SampleRobot,Robot}, (x,y) :: NTuple{2,Int})=new(CoordRobot( robot ), x,y , true)
end

function HorizonSideRobots.isborder( robot :: Checker , side :: HorizonSide) 
    if robot.inside get_coords(robot) == (robot.x,robot.y) 
        if side==Sud
            robot.inside=false
        end
        if side==Nord
            robot.inside=true
        end
        robot.inside |> println
    end
    isborder( get_robot(robot), side )
end

function where_i_am( robot :: Robot )
    ncoord=northern_frontier( robot )
    checker=Checker(robot, ncoord)
    around_the_world!(BorderRobot( checker ))
    checker.inside |> println
end
