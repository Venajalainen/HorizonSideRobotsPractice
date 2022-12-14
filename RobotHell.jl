using HorizonSideRobots

#abstract type

abstract type SampleRobot end

get_robot(r :: SampleRobot) = r.robot

HorizonSideRobots.move!(robot::SampleRobot, side :: HorizonSide) = move!(get_robot(robot), side)
HorizonSideRobots.isborder(robot::SampleRobot, side :: HorizonSide) = isborder(get_robot(robot), side)
HorizonSideRobots.putmarker!(robot::SampleRobot) = putmarker!(get_robot(robot))
HorizonSideRobots.ismarker(robot::SampleRobot) = ismarker(get_robot(robot))
HorizonSideRobots.temperature(robot::SampleRobot) = temperature(get_robot(robot))
HorizonSideRobots.ismarker(r :: SampleRobot) = ismarker(get_robot(r))

abstract type CoordFamily <: SampleRobot end

get_coords(robot :: CoordFamily) = get_coords( get_robot( robot ))

#coord robot remembers start coordinate

mutable struct CoordRobot <: CoordFamily
    robot :: Union{SampleRobot,Robot}
    x :: Int
    y :: Int
    CoordRobot(robot :: Union{SampleRobot,Robot} ) = new(robot,0,0)
    CoordRobot(robot :: Union{SampleRobot,Robot} , x, y ) = new(robot,x,y)
end

function HorizonSideRobots.move!(r :: CoordRobot, side :: HorizonSide)
    switch(side) do side
        side==Nord && (r.y+=1)
        side==Sud && (r.y-=1)
        side==West && (r.x+=1)
        side==Ost && (r.x-=1)
    end
    move!(get_robot(r),side)
end

get_coords( robot :: CoordRobot ) = (robot.x,robot.y)

#painter struct

struct Painter <: SampleRobot
    robot :: Robot
end

HorizonSideRobots.putmarker!(r :: Painter)=putmarker!(get_robot(r))
function HorizonSideRobots.move!(r :: Painter, side :: HorizonSide)
    robot=get_robot(r); putmarker!(robot); move!(robot,side)
end

#necessary functions
switch(f :: Function, x...) = f(x...)

inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+1,4))

anticlockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+3,4))

along!(cond :: Function, robot :: Union{SampleRobot, Robot} , side :: HorizonSide) = while cond(robot,side) && !isborder(r,side) move!(robot,side) end 

along!(cond :: Function, robot :: Union{SampleRobot, Robot}, side :: HorizonSide, max_num :: Int) =while (cond(robot,side) && max_num>0) move!(robot,side); max_num-=1 end

function numsteps_along!(cond :: Function, robot :: Union{SampleRobot, Robot}, side :: HorizonSide) :: Int 
    steps=0
    while cond(robot,side) move!(robot,side); steps+=1 end
    return steps
end

along!(robot :: Union{SampleRobot, Robot}, side :: HorizonSide) = while !isborder(robot,side) move!(robot,side) end

along!(robot :: Union{SampleRobot, Robot}, side :: HorizonSide, num_steps :: Int) = while num_steps>0 move!(robot,side); num_steps-=1 end

function snake!(cond :: Function, robot :: Union{SampleRobot, Robot}, (move_side, next_row_side) :: NTuple{2, HorizonSide}=(Ost,Nord)) 
    while cond(robot,move_side)
        along!(cond,robot,move_side); 
        if !isborder(robot,next_row_side) move!(robot,next_row_side) else break end
        move_side=inverse(move_side)
    end
end

snake!(robot :: Union{SampleRobot, Robot}, (move_side, next_row_side) :: NTuple{2, HorizonSide}=(Ost,Nord)) = snake!((x...) -> true, robot, (move_side, next_row_side))

function spiral!(cond :: Function, robot :: Union{SampleRobot, Robot}) 
    steps=1; side=Nord
    while cond(robot) 
        for i in 1:2 along!(cond,robot,side,steps); side=clockwise(side) end
        steps+=1
    end
end

function shuttle!(cond :: Function, robot :: Union{SampleRobot, Robot}, side :: HorizonSide) 
    steps = 1
    while cond(robot,side)
        along!(robot,side,steps); side=inverse(side); steps+=1
    end
end

function collibrate!(robot :: Union{SampleRobot, Robot}; track :: Bool = true)
    arr=()
    while !isborder(robot, Nord) || !isborder(robot,West)
        if !isborder(robot,Nord) arr=(Sud,arr...); move!(robot, Nord) end
        if !isborder(robot,West) arr=(Ost,arr...); move!(robot, West) end
    end
    track && return arr
end

gohome!(robot :: Union{SampleRobot, Robot}, arr :: NTuple) = 
for side in arr 
    move!(robot,side)
end

#testing

function test_func( test_function :: Function, test :: Array{Int}; animate=false)
    for i in test
        r=Robot("test$i.sit"; animate=animate)
        "test$i.sit : " |> print; test_function( r ) |> println
        !animate && show!(r)
    end
end

function test_func( test_function :: Function, test :: Int;  animate=false)
    for i in 1:test
        r=Robot("test$i.sit"; animate=animate)
        "test$i.sit : " |> print; test_function( r ) |> println
        !animate && show!(r)
    end
end