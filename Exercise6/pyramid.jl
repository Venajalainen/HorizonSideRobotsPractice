using HorizonSideRobots

inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+1,4))

function go!(r :: Robot,side :: HorizonSide, steps :: Int; paint=false)
    while steps>0
        if paint putmarker!(r) end
        move!(r,side)
        steps-=1
    end
    if paint putmarker!(r) end
end

function collibrate!(r :: Robot; count=true, side=Nord)
    x, y=0, 0
    while !isborder(r,side) || !isborder(r,clockwise(side))
        if !isborder(r,side)  move!(r,side); y+=1 end
        if !isborder(r,clockwise(side))  move!(r,clockwise(side)); x+=1 end
    end
    if count return x,y end
end

function go_home!(r :: Robot, x :: Int, y :: Int)
    if x>y go!(r,Ost,x); go!(r,Sud,y)
    else go!(r,Sud,y); go!(r,Ost,x) end
end

function pyramid(r :: Robot)
    x, y=collibrate!(r)
    width,height= collibrate!(r;side=Sud)
    side=West
    while true
        if width==0 putmarker!(r) end 
        if width>0 go!(r,side,width;paint=true) end
        if isborder(r,Nord) break; else move!(r,Nord) end
        if side==Ost move!(r,West) end
        height-=1
        width-=1
        side=inverse(side)
    end
    go_home!(r,x,y)
end