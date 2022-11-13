using HorizonSideRobots

inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+1,4))

anticlockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+3,4))

function shuttle_over!(cond :: Function, robot :: Robot, side :: HorizonSide) 
    steps = 1; initial_side=clockwise(side); shift=0; move_side=clockwise(side)
    while cond(robot,side)
        along!(robot,move_side,steps); move_side=inverse(move_side)
        if initial_side==move_side shift+=steps else shift-=steps end
        steps+=1
    end
    move!(robot,side)
    if shift<0
        along!(robot, inverse(initial_side), abs(shift))
    else
        along!(robot, initial_side, shift)
    end
end

along!(robot :: Robot, side :: HorizonSide, steps :: Int) =
while steps>0
    move!(robot,side); steps-=1
end

along!(cond :: Function, robot :: Robot, side :: HorizonSide, max_num :: Int) = while (cond(robot,side) && max_num>0)
    if (isborder(robot,side) && max_num!=0)  shuttle_over!((x...)->isborder(robot,side),robot,side) else  move!(robot,side) end;  max_num-=1 
end

function spiral(cond :: Function, robot :: Robot) 
    steps=1; side=Nord
    while cond(robot) 
        for i in 1:2 along!(cond,robot,side,steps); side=clockwise(side) end
        steps+=1
    end
end

function find_marker_b!(r :: Robot)
    spiral((x...)->!ismarker(r),r)
end