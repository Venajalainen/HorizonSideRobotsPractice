using HorizonSideRobots
include("../RobotHell.jl")
include("../Exercise 2/perimetr.jl")

mutable struct SpecificCoordRobot <: SampleRobot
    robo :: Robot
    x :: Int
    y :: Int
end

function HorizonSideRobots.isborder(r :: SpecificCoordRobot, side :: HorizonSide)
    return isborder(r.robo,side)
end

function HorizonSideRobots.move!(r :: SpecificCoordRobot, side :: HorizonSide)
    switch(r,side) do r,side
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

go!( cond :: Function, r, side :: HorizonSide; paint=false) = 
while !cond(r,side)
        move!(r,side) ; if paint putmarker!(r) end
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
