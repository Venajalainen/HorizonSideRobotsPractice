using HorizonSideRobots
include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")
include("../Exercise 38/where_i_am.jl")

struct LabRobot{TypeRobot} <: CoordFamily
    robot :: TypeRobot
    track :: Set{NTuple{2,Int}}
    reference :: NTuple{2,Int}

    function LabRobot{RobotType}( robot :: RobotType, (x,y) :: NTuple{2,Int}) where RobotType <: Union{Robot, SampleRobot}

        new_robot = typeof(robot) <: CoordFamily ? robot : CoordRobot( robot )
        reference :: NTuple{2,Int} = (x,y)
        track :: Set{NTuple{2,Int}} = Set{NTuple{2,Int}}([reference])

        new{typeof(new_robot)}( new_robot, track, reference )
    end

end

function HorizonSideRobots.move!( robot :: LabRobot, side :: HorizonSide)

    x0, y0 = robot.reference 
    x, y = get_coords(robot)

    push!(robot.track,(x0+x,y0+y))

    move!( get_robot(robot), side)

end

get_lab( robot :: BorderRobot) =get_lab( get_robot( robot ))
get_lab( robot :: LabRobot) = robot.track

function count_labs(st_robot :: Robot) 

    robot :: CoordRobot = CoordRobot(st_robot)
    coords :: Set{NTuple{2,Int}} = Set{NTuple{2,Int}}()
    labs :: Set{Set{NTuple{2,Int}}} = Set{Set{NTuple{2,Int}}}()

    function recursive()

        x, y = get_coords( robot )

        ((x,y) in coords) && return

        push!(coords,(x,y))

        for side in (Nord, West, Sud, Ost)
            if !isborder(robot,side)
                move!(robot,side); recursive(); move!(robot,inverse(side))
            else
                r=LabRobot{Robot}( st_robot , (x,y))
                if amioutside(r;side=side)
                    putmarker!(r)
                    if !(get_lab( r ) in labs) 
                        push!(labs,get_lab(r))
                    end
                end
            end
        end
    end

    recursive()
    
    return length(labs)
end