using HorizonSideRobots
include("../RobotHell.jl")
include("../Exercise 2/perimetr.jl")

function go!( cond :: Function, r :: Robot, side :: HorizonSide, steps :: Int)
    while steps>0
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
        along!((r,side)->isborder(r,anticlockwise(side)), Painter(r), side)
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

