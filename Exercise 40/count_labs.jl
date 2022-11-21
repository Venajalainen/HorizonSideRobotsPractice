using HorizonSideRobots
include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")
include("../Exercise 38/where_i_am.jl")

function count_labs(starting_robo :: Robot) 
    robot = CoordRobot( starting_robo )
    coords=Set{NTuple{2,Int}}(); c=0
    function recursive()
        x, y = get_coords( robot )
        ((x,y) in coords) && return
        push!(coords,(x,y))
        for side in (Nord, West, Sud, Ost)
            if !isborder(robot,side)
                move!(robot,side); recursive(); move!(robot,inverse(side))
            else
                r=BorderRobot( robot )
                if where_i_am(starting_robo) == "I am outside of labirynth"
                    putmarker!(starting_robo)
                    c+=1
                end
            end
        end
    end
    recursive()
    return c
end