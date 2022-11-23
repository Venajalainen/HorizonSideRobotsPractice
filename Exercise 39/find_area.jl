include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")

mutable struct AreaFinder <: CoordFamily
    robot :: Union{Robot,SampleRobot}
    points :: Dict{Int,Vector{Int}}
    AreaFinder( robot :: CoordFamily ) = new( robot , Dict{Int,Vector{Int}}())
    AreaFinder( robot :: Union{Robot,SampleRobot} ) = new( CoordRobot(robot) , Dict{Int,Vector{Int}}())
end

function HorizonSideRobots.move!(robot :: AreaFinder, side :: HorizonSide)
    x,y = get_coords( robot )
    if y in keys(robot.points)
        !(x in robot.points[y]) && push!(robot.points[y],x)
    else
        robot.points[y]=Vector{Int}([x])
    end
    move!( get_robot(robot), side)
end

get_points( robot :: AreaFinder ) = robot.points

function find_area!( robot :: AreaFinder)
    area=0; points=robot.points
    for key in keys(points)
        area+=maximum(points[key])-minimum(points[key]) - length(points[key])+1
    end
    return area
end

function find_area!( robot :: Robot )
    areafinder=BorderRobot( AreaFinder( robot ) )
    around_the_world!( areafinder )
    return find_area!( get_robot(areafinder) )
end