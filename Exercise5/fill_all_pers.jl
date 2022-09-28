using HorizonSideRobots

inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))
clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+1,4))
anticlockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+3,4))

function go!(r :: Robot, side :: HorizonSide; paint=false)
    while !isborder(r,side) && !ismarker(r)
        if paint putmarker!(r) end
        move!(r,side)
    end
end

function go!(r :: Robot,side :: HorizonSide, steps :: Int)
    while steps>0
        move!(r,side)
        steps-=1
    end
end

function go_detect!(r :: Robot, side :: HorizonSide)
    while !isborder(r,side) && !isborder(r,Sud)
        move!(r,side)
    end
end

function closest_bord(r :: Robot)
    for i in 0:3
        if isborder(r,HorizonSide(i)) return HorizonSide(i) end
    end
end

function perfill!(r :: Robot)
    for i in [2,3,0,1]
        go!(r,HorizonSide(i);paint=true)
    end
end

function collibrate!(r :: Robot; count=true)
    x, y=0, 0
    while !isborder(r,Nord) || !isborder(r,West)
        if !isborder(r,Nord)  move!(r,Nord); y+=1 end
        if !isborder(r,West)  move!(r,West); x+=1 end
    end
    if count return x,y end
end

function go_home!(r :: Robot, x :: Int, y :: Int)
    if x>y go!(r,Ost,x); go!(r,Sud,y)
    else go!(r,Sud,y); go!(r,Ost,x) end
end

function find_inner_per(r :: Robot)
    side=Ost
    while true
        go_detect!(r,side)
        if isborder(r,side) side=inverse(side) end
        if !isborder(r,Sud) move!(r,Sud) else break end
    end
end

function fill_all_pers(r :: Robot)
    x, y=collibrate!(r)
    perfill!(r)
    find_inner_per(r)
    side=closest_bord(r)
    for i in 1:5
        while isborder(r,side)
            putmarker!(r)
            move!(r,clockwise(side))
        end
        move!(r,side)
        side=anticlockwise(side)
    end
    collibrate!(r; count=false)
    go_home!(r,x,y)
end