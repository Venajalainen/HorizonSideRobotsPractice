using HorizonSideRobots
include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")
include("../Exercise 38/where_i_am.jl")

function fill(cond :: Function, robot :: AbstractCoordRobots) 
    coords=Set{NTuple{2,Int}}()
    function recursive()
        x, y = get_coords( robot )
        ((x,y) in coords) && return
        push!(coords,(x,y))
        for side in (Nord, West, Sud, Ost)
            if !cond(robot,side)
                move!(robot,side); recursive(); move!(robot,inverse(side))
            end
        end
    end
    recursive()
end