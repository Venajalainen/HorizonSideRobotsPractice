include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")
include("../Exercise 37/northern_frontier.jl")


function amioutside( robot :: RobotType; side = nothing :: Union{HorizonSide,Nothing}) where RobotType <: Union{ Robot, SampleRobot}

    checker=NorthernRobot{RobotType}(robot; side=side)

    around_the_world!( checker ; side=side )

    return get_verdict(checker)
end

function where_i_am( robot :: RobotType ) where RobotType <: Union{Robot, SampleRobot}

    if amioutside(robot)

        return "I am outside" 

    else

        return "I am inside" 
        
    end
end
