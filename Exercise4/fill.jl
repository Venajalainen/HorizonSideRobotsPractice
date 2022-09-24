using HorizonSideRobots
inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))
function go!(r :: Robot, side :: HorizonSide; paint=false)
    while !isborder(r,side) && !ismarker(r)
        if paint putmarker!(r) end
        move!(r,side)
    end
end
function fill!(r :: Robot)
    go!(r,Nord)
    side=West
    go!(r,side)
    while true
        side=inverse(side)
        go!(r,side; paint=true)
        putmarker!(r)
        if isborder(r,Sud) && isborder(r,side) break end
        move!(r,Sud)
    end
end