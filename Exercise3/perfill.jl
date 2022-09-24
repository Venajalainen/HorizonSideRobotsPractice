using HorizonSideRobots
clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+3,4))
function go!(r :: Robot, side :: HorizonSide; paint=false)
    while !isborder(r,side) && !ismarker(r)
        if paint putmarker!(r) end
        move!(r,side)
    end
end
function perfill!(r :: Robot)
    side=Nord
    go!(r,side)
    while !ismarker(r)
        side=clockwise(side)
        go!(r,side;paint=true)
    end
end