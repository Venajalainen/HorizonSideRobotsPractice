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

function go!(r ::Robot, side :: HorizonSide)
    while !isborder(r,side)
        move!(r,side)
    end
end

function collibrate!(r :: Robot; count=true, side=Nord)
    arr=Array{HorizonSide}(undef,0)
    while !isborder(r,side) || !isborder(r,clockwise(side))
        if !isborder(r,side)  move!(r,side); arr=(inverse(side), arr...) end
        if !isborder(r,clockwise(side))  move!(r,clockwise(side)); arr=(inverse(clockwise(side)),arr...) end
    end
    if count return arr end
end

function go_home!(r :: Robot, arr)
    for side in arr
        move!(r,side)
    end
end

function corners(r :: Robot)
    arr=collibrate!(r)
    for i in [3,2,1,0]
        putmarker!(r)
        go!(r,HorizonSide(i))
    end
    go_home!(r,arr)
end