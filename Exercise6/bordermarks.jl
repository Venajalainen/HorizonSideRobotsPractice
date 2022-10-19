using HorizonSideRobots

mutable struct SpecificCoordRobot
    robo :: Robot
    x :: Int
    y :: Int
end

function HorizonSideRobots.isborder(r :: SpecificCoordRobot, side :: HorizonSide)
    return isborder(r.robo,side)
end

switch(f :: Function, x :: Any) = f(x...)

function HorizonSideRobots.move!(r :: SpecificCoordRobot, side :: HorizonSide)
    switch((;r,side)) do r,side
        side==Nord && (r.y+=1)
        side==Sud && (r.y-=1)
        side==West && (r.x+=1)
        side==Ost && (r.x-=1)
    end
    move!(r.robo,side)
end

function HorizonSideRobots.putmarker!(r :: SpecificCoordRobot)
    if r.x==0 || r.y==0 putmarker!(r.robo) end
end

inverse( side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

go!( cond :: Function, r, side :: HorizonSide; paint=false) = 
while !cond(r,side)
        move!(r,side) ; if paint putmarker!(r) end
end

function collibrate!(r; track=true)
    arr=()
    println("nice")
    while !isborder(r, Nord) || !isborder(r,West)
        if !isborder(r,Nord) arr=(Sud,arr...); move!(r, Nord) end
        if !isborder(r,West) arr=(Ost,arr...); move!(r, West) end
    end
    if track return arr end
end

gohome!(r, arr :: NTuple) = 
for side in arr 
    move!(r,side)
end

function perimetr!(r)
    for side in (Ost,Sud,West,Nord)
        go!((r,side)->isborder(r,side), r, side;paint=true)
    end
end

function bordermarka!(r :: Robot)
    wayhome=collibrate!(r)
    perimetr!(r)
    gohome!(r,wayhome)
end

function bordermarkb!(r :: Robot)
    spec=SpecificCoordRobot(r,0,0)
    wayhome=collibrate!(spec)
    perimetr!(spec)
    gohome!(spec,wayhome)
end
