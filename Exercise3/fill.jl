using HorizonSideRobots

inverse( side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

go!( cond :: Function, r :: Robot, side :: HorizonSide; paint=false) = 
while !cond(r,side)
        move!(r,side) ; if paint putmarker!(r) end
end

function collibrate!(r :: Robot; track=true)
    arr=()
    while !isborder(r, Nord) || !isborder(r,West)
        if !isborder(r,Nord) arr=(Sud,arr...); move!(r, Nord) end
        if !isborder(r,West) arr=(Ost,arr...); move!(r, West) end
    end
    if track return arr end
end

gohome!(r :: Robot, arr :: NTuple) = 
for side in arr 
    move!(r,side)
end

function fill!( r :: Robot)
    wayhome=collibrate!(r); side=Ost
    while true
        putmarker!(r)
        go!((r,side)->isborder(r,side),r,side;paint=true)
        if isborder(r,Sud) break end
        move!(r,Sud); side=inverse(side)
    end
    collibrate!(r;track=false)
    gohome!(r,wayhome)
end