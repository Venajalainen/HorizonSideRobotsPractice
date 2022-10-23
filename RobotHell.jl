using HorizonSideRobots

#abstract type

abstract type SampleRobot end

get_robot(r :: SampleRobot) = r.robo

HorizonSideRobots.move!(robot::SampleRobot, side :: HorizonSide) = move!(get_robot(robot), side)
HorizonSideRobots.isborder(robot::SampleRobot, side :: HorizonSide) = isborder(get_robot(robot), side)
HorizonSideRobots.putmarker!(robot::SampleRobot) = putmarker!(get_robot(robot))
HorizonSideRobots.ismarker(robot::SampleRobot) = ismarker(get_robot(robot))
HorizonSideRobots.temperature(robot::SampleRobot) = temperature(get_robot(robot))
HorizonSideRobots.ismarker(r :: SampleRobot) = ismarker(get_robot(r))

#костыль

struct BaseRobot <:SampleRobot
    robo :: Robot
end

#painter struct

struct Painter <: SampleRobot
    robo :: Robot
end

HorizonSideRobots.putmarker!(r :: Painter)=putmarker!(get_robot(r))
function HorizonSideRobots.move!(r :: Painter, side :: HorizonSide)
    robo=get_robot(r); putmarker!(robo); move!(robo,side)
end

#necessary functions
switch(f :: Function, x...) = f(x...)

inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+1,4))

along!(cond :: Function, robot :: SampleRobot, side :: HorizonSide) = while cond(robot,side) && !isborder(r,side) move!(robot,side) end 

along!(cond :: Function, robot :: SampleRobot, side :: HorizonSide, max_num :: Int) =while cond(robot,side) && max_num>0 move!(robot,side) end

function numsteps_along!(cond :: Function, robot :: SampleRobot, side :: HorizonSide) :: Int 
    steps=0
    while cond(robot,side) move!(robot,side); steps+=1 end
    return steps
end

along!(robot :: SampleRobot, side :: HorizonSide) = while !isborder(robot,side) move!(robot,side) end

along!(robot :: SampleRobot, side :: HorizonSide, num_steps :: Int) = while num_steps>0 move!(robot,side); num_steps-=1 end

function snake!(cond :: Function, robot :: SampleRobot, (move_side, next_row_side) :: NTuple{2, HorizonSide}=(Ost,Nord)) 
    while cond(robot,move_side)
        along!(cond,robot,move_side); 
        if !isborder(robot,next_row_side) move!(robot,next_row_side) else break end
        move_side=inverse(move_side)
    end
end

snake!(robot :: SampleRobot, (move_side, next_row_side) :: NTuple{2, HorizonSide}=(Ost,Nord)) = snake!((x...) -> true, robot, (move_side, next_row_side))

function spiral!(cond :: Function, robot :: SampleRobot) 
    steps=1; side=Nord
    while cond(robot) 
        for i in 1:2 along!(robot,side,steps); side=clockwise(side) end
        steps+=1
    end
end

function shuttle!(cond :: Function, robot :: SampleRobot, side :: HorizonSide) 
    steps = 1
    while cond(robot,side)
        along!(robot,side,steps); side=inverse(side); steps+=1
    end
end
