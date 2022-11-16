include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")

mutable struct AreaFinder <: AbstractCoordRobots
    robot :: SampleRobot
    sides :: Vector{Int}
    perimetr :: Int
    rotations :: Int
    AreaFinder( robot ) = new( CoordRobot(robot,0,0) , Vector{Int}(),0,0)
end

function HorizonSideRobots.move!(robot :: AreaFinder, side :: HorizonSide)
    robot.perimetr+=1
    move!( get_robot(robot), side)
end

get_coords( robot :: AreaFinder ) = get_coords( get_robot(robot) )
get_points( robot :: AreaFinder ) = robot.points

function activate!( robot :: BorderRobot, check :: Bool )
    finder=get_robot(robot)
    if !check finder.perimetr-=1 end
    finder.sides=push!(
        finder.sides,
        finder.perimetr*(-1)^Int(
            get_direction(robot)==robot.initial_direction || get_direction(robot) == right!(robot.initial_direction)
            )
        )
    finder.perimetr=0
    finder.rotations+=1
end

function find_area!( robot :: BorderRobot)
    areafinder=get_robot(robot)
    activate!(robot, false)
    areafinder.sides |> println
    arr=[areafinder.sides...][2:div(areafinder.rotations,3)*3]
    summa=0
    for i in 1:2:length(arr)
        summa+=arr[i]*arr[i+1]
    end
    return summa
end

function find_area!( robot :: Robot )
    areafinder=BorderRobot( AreaFinder( robot ) )
    along!( (x...)-> areafinder.initial_direction==areafinder.direction, areafinder)
    around_the_world!( areafinder )
    find_area!( areafinder ) |> println
end