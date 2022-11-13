using HorizonSideRobots
include("../RobotHell.jl")

function collibrate!(r :: Robot; count=true, side=Nord)
    arr=Array{HorizonSide}(undef,0)
    while !isborder(r,side) || !isborder(r,clockwise(side))
        if !isborder(r,side)  move!(r,side); arr=(inverse(side), arr...) end
        if !isborder(r,clockwise(side))  move!(r,clockwise(side)); arr=(inverse(clockwise(side)),arr...) end
    end
    if count return arr end
end


function define_coords(r :: Robot, arr :: NTuple)
    x, y=0 ,0
    for side in arr
        if side==Ost x+=1 end
        if side==Sud y+=1 end
    end
    return x,y
end

function chess(r :: Robot)
    arr=collibrate!(r)
    x,y=define_coords(r,arr)
    critertia=mod(x+y,2)
    x,y =1 ,1
    side=Ost
    while true
        while !isborder(r,side)
            if mod(x+y,2)==critertia putmarker!(r) end
            move!(r,side)
            x+=1
        end
        if mod(x+y,2)==critertia putmarker!(r) end
        side=inverse(side)
        if isborder(r,Sud) break end
        move!(r,Sud)
        y+=1
    end
    collibrate!(r; count=false)
    go_home!(r,arr)
end