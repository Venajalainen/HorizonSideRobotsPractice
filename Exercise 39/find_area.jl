include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")

struct Point
    x :: Int
    y :: Int
    Point( (x, y) :: NTuple{2,Int}) = new( x, y )
    Point( x :: Int, y :: Int) = new( x, y)
end

distance( p :: Point ) = sqrt( (p.x)^2 +(p.y)^2 )

struct TheVector
    p :: Point
    TheVector( p1 :: Point, p2 :: Point ) = new(Point(p2.x-p1.x, p2.y-p1.y))
end

veclength( v :: TheVector) = distance(v.p)

struct Rectangle
    v1 :: TheVector
    v2 :: TheVector
    substract :: Bool
end

function area( rect :: Rectangle) 
    return veclength(rect.v1)*veclength(rect.v2)*(-1)^Int(rect.substract)
end

mutable struct AreaFinder <: AbstractCoordRobots
    robot :: SampleRobot
    points :: Vector{Point}
    areas :: Vector{Int}
    perimetr :: Int
    AreaFinder( robot ) = new( CoordRobot(robot,1,1) , Vector{Point}(), Vector{Int}())
end

function HorizonSideRobots.move!(robot :: AreaFinder, side :: HorizonSide)
     move!( get_robot(robot), side)
     robot.perimetr+=1
end

get_coords( robot :: AreaFinder ) = get_coords( get_robot(robot) )
get_points( robot :: AreaFinder ) = robot.points

function activate!( robot :: BorderRobot )
    finder=get_robot(robot)
    points = get_points( finder )
    if length( points ) == 2
        finder.points=push!(finder.points,Point(get_coords(robot)))
        v1=TheVector(points[3],points[2])
        v2=TheVector(points[2],points[1])
        if get_rotation(robot) == Right
            rect=Rectangle( v1, v2, false)
        else
            rect=Rectangle( v1, v2, true)
        end
        println(points)
        println(veclength(rect.v1)," ",veclength(rect.v2))
        finder.areas=push!(finder.areas,area(rect))
        finder.points=empty(points)
    else
        finder.points=push!(finder.points,Point(get_coords(robot)))
    end
end

function find_area!( robot :: AreaFinder)
    return sum(robot.areas)
end

function find_area!( robot :: Robot )
    areafinder=BorderRobot( AreaFinder( robot ) )
    around_the_world!( areafinder )
    find_area!( get_robot( areafinder) ) |> println
end