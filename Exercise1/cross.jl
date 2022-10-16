using HorizonSideRobots

inverse( side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

go!( cond :: Function, r :: Robot, side :: HorizonSide; paint=false) = 
while !cond(r,side)
        move!(r,side) ; if paint putmarker!(r) end
end

function cross!( r :: Robot)
    for side in (HorizonSide(i) for i in 0:3)
        go!((r,side)->isborder(r,side), r, side;paint=true); go!((r,side)->!ismarker(r), r ,inverse(side))
    end
    putmarker!(r)
end