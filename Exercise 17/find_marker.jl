using HorizonSideRobots

clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+1,4))

anticlockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+3,4))

function avoid!(r,side)
    if isborder(r,side)
        move!(r,clockwise(side))
        avoid!(r,side)
        move!(r,anticlockwise(side))
    else
        move!(r,side)
    end
end

along!(cond :: Function, robot :: Robot, side :: HorizonSide, max_num :: Int) = while (cond(robot,side) && max_num>0)
     if (isborder(r,side) && max_num!=0)  avoid!(r,side) else  move!(robot,side) end;  max_num-=1 
    end

function modified_spiral(cond :: Function, robot :: Robot) 
    steps=1; side=Nord
    while cond(robot) 
        for i in 1:2 along!(cond,robot,side,steps); side=clockwise(side) end
        steps+=1
    end
end
function find_markera!(r :: Robot)
    modified_spiral((x...)->!ismarker(r),r)
end