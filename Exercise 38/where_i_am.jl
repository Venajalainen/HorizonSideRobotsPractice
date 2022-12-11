include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")
include("../Exercise 37/northern_frontier.jl")

mutable struct Checker{RobotType} <: CoordFamily

    robot :: RobotType
    coords :: NTuple{2,Int}
    outside :: Bool
    rotation :: Rotation

    function Checker{RobotType}( robot :: RobotType ; side :: Union{Nothing, HorizonSide} = nothing) where RobotType <: Union{Robot,SampleRobot}
        
        new_robot = typeof(robot) <: CoordFamily ? robot : CoordRobot( robot )
        coords :: NTuple{2,Int} = northern_frontier( robot ; side=side)
        outside :: Bool = true
        rotation :: Rotation = get_rotation( BorderRobot( robot , side) )

        return new{typeof(robot)}( new_robot , coords, outside ,rotation )

    end

end

function HorizonSideRobots.isborder( robot :: Checker , side :: HorizonSide) 

    borderwall = ( robot.rotation == Right ? right!( side ) : left!( side ) )

    (get_coords(robot) == robot.coords && isborder(get_robot(robot),borderwall) && borderwall==Nord) && (robot.outside=false)

    isborder( get_robot(robot), side )
end

function amioutside( robot :: RobotType; side = nothing :: Union{HorizonSide,Nothing}) where RobotType <: Union{ Robot, SampleRobot}

    checker=Checker{RobotType}(robot; side=side)

    around_the_world!( checker ; side=side )

    return checker.outside
end

function where_i_am( robot :: RobotType ) where RobotType <: Union{Robot, SampleRobot}

    if amioutside(robot)

        return "I am outside" 

    else

        return "I am inside" 
        
    end
end
