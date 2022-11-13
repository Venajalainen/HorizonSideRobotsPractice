include("../RobotHell.jl")
using HorizonSideRobots

mutable struct ChessRobot <: SampleRobot
    robo :: Robot
    x :: Int
    y :: Int
end

function collibrate!( r :: ChessRobot; track=false )
    arr=()
    while !isborder(r,Sud) || !isborder(r,West)
        if !isborder(r,Sud) move!(r,Sud); arr=(Nord,arr...) end
        if !isborder(r,West) move!(r,West); arr=(Ost,arr...) end
    end
    if track return arr end
end

function HorizonSideRobots.move!(r :: ChessRobot, side :: HorizonSide)
    if mod(r.x+r.y,2)==0 putmarker!(get_robot(r)) end
    switch(side) do side
        side==Nord && (r.y+=1)
        side==Sud && (r.y-=1)
        side==West && (r.x+=1)
        side==Ost && (r.x-=1)
    end
    move!(get_robot(r),side)
end



function chromchess(r :: Robot)
    mech=ChessRobot(r,0,0)
    wayhome=collibrate!(mech;track=true)
    snake!(mech)
    collibrate!(mech); gohome!(mech,wayhome)
end