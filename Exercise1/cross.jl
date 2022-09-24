using HorizonSideRobots
inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))
clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+3,4))
function step(r :: Robot, side :: HorizonSide)
    if !isborder(r,side)
        move!(r,side)
    end
end
function go!(r :: Robot, side :: HorizonSide; paint=false)
    while !isborder(r,side) && !ismarker(r)
        if paint putmarker!(r) end
        move!(r,side)
    end
end
function cross!(r :: Robot)
    putmarker!(r)
    for i in 0:3
        side=HorizonSide(i)
        step(r,side)
        go!(r,side)
        go!(r,inverse(side); paint=true)
    end
end