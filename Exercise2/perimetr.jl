using HorizonSideRobots

inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

function collibrate!(r :: Robot)
    arr=()
    while !isborder(r, Nord) || !isborder(r,West)
        if !isborder(r,Nord) arr=(Sud,arr...); move!(r, Nord) end
        if !isborder(r,West) arr=(Ost,arr...); move!(r, West) end
    end
    return arr
end

go!( cond :: Function, r :: Robot, side :: HorizonSide; paint=false) = 
while !cond(r,side)
        move!(r,side) ; if paint putmarker!(r) end
end

gohome!(r :: Robot, arr :: NTuple) = 
for side in arr 
    move!(r,side)
end

function perimetr!(r :: Robot)
    wayhome= collibrate!(r)
    for side in (Ost,Sud,West,Nord)
        go!((r,side)->isborder(r,side), r, side;paint=true)
    end
    gohome!(r,wayhome)
end