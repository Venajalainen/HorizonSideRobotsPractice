using HorizonSideRobots

inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+1,4))

anticlockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+3,4))

function collibrate!(r :: Robot; track=true)
    arr=()
    while !isborder(r, Nord) || !isborder(r,West)
        if !isborder(r,Nord) arr=(Sud,arr...); move!(r, Nord) end
        if !isborder(r,West) arr=(Ost,arr...); move!(r, West) end
    end
    if track return arr end
end

go!( cond :: Function, r :: Robot, side :: HorizonSide; paint=false) = 
while !cond(r,side)
    if paint putmarker!(r) end; move!(r,side) 
end

function go!( cond :: Function, r :: Robot, side :: HorizonSide, steps :: Int)
    while steps>0
        #println(cond(r, side)," ",isborder(r,Sud)," ",side," ", anticlockwise(side))
        if cond(r, side) return (true, side) end
        move!(r,side); steps-=1
    end
    return (false,side) 
end


function count_dimension!(r :: Robot, side :: HorizonSide)
    steps=0
    while !isborder(r,side)
        move!(r,side)
        steps+=1
    end
    return steps
end

gohome!(r :: Robot, arr :: NTuple) = 
for side in arr 
    move!(r,side)
end

function perimetr!(r :: Robot)
    for side in (Ost,Sud,West,Nord)
        go!((r,side)->isborder(r,side), r, side;paint=true)
    end
end

function close_borders(r :: Robot, side :: HorizonSide, x :: Int, y :: Int)
    for i in 1:4
        res=go!((r,side)->isborder(r,anticlockwise(side)),r,side ,x*mod(i,2)+y*mod(i+1,2))
        if res[1]==true return res end
        side=anticlockwise(side)
    end
    return (false,Nord)
end

function find_innerper(r :: Robot)
    collibrate!(r;track=false); side=Ost; flag=()
    x=count_dimension!(r,Ost); collibrate!(r;track=false)
    y=count_dimension!(r,Sud); collibrate!(r;track=false)
    while true
        flag=close_borders(r,side,x,y)
        if flag[1]==true break end
        x-=2; y-=2
        move!(r,Sud); move!(r,Ost)
    end
    return flag[2]
end

function fill_innerper(r :: Robot, side :: HorizonSide)
    for i in 1:4
        go!((r,side)->!isborder(r,anticlockwise(side)), r, side; paint=true)
        side=anticlockwise(side)
        move!(r,side)
    end
end

function fill_all_pers!(r :: Robot)
    wayhome=collibrate!(r)
    perimetr!(r); collibrate!(r;track=false)
    side=find_innerper(r)
    println(side)
    fill_innerper(r,side)
    collibrate!(r; track=false); gohome!(r,wayhome)
end

