include("../RobotHell.jl")
include("../Exercise33-35/specrobot.jl")

mutable struct Checker <: AbstractCoordRobots
    robot :: Union{SampleRobot, Robot}
    w_borders :: Int
    e_borders :: Int
    n_borders :: Int
    s_borders :: Int
    Checker( robot ) = new( CoordRobot( robot ) , 0 , 0 , 0 , 0 )
end

get_borders( robot :: BorderRobot ) = get_borders( get_robot( robot ) )
get_borders( robot :: Checker ) = (robot.w_borders,robot.s_borders,robot.n_borders,robot.e_borders)
get_coords( robot :: Checker) = get_coords( get_robot( robot ) )

function HorizonSideRobots.move!( robot :: Checker, side :: HorizonSide)
    x, y = get_coords( robot )
    switch(x,y) do x, y
        (x==0 && isborder( robot , Nord) ) && ( robot.n_borders+=1)
        (x==0 && isborder( robot , Sud)) && ( robot.s_borders+=1)
        (isborder( robot , West) && y==0) && ( robot.w_borders+=1)
        (isborder( robot , Ost) && y==0) && ( robot.e_borders+=1)
    end
    move!( get_robot(robot) , side)
end

function verdict( robot :: BorderRobot)
    around_the_world!( robot )
    if mod(sum( get_borders( robot ) ),2)==0
        return "I am inside labirynth"
    else
        return "I am outside of labirynth"
    end
end

function where_i_am( r :: Robot )
    robot=BorderRobot( Checker( r ) )
    verdict( robot ) |> println
end
