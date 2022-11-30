using HorizonSideRobots
include("../RobotHell.jl")

mutable struct AndrCrossRobot <: CoordFamily
    robot :: Robot
    x :: Int
    y :: Int
end

function HorizonSideRobots.move!(r :: AndrCrossRobot, side :: HorizonSide)
    switch(side) do side
        side==Nord && (r.y+=1)
        side==West && (r.x+=1)
        side==Sud && (r.y-=1)
        side==Ost && (r.x-=1)
    end
    move!(r.robot,side)
end

HorizonSideRobots.putmarker!(r :: AndrCrossRobot) = abs(r.x)==abs(r.y) && putmarker!(r.robot)

function fill(cond :: Function, r :: AndrCrossRobot )
    coords=Set{NTuple{2,Int}}()
    function recursive()
        ((r.x,r.y) in coords) && return
        push!(coords,(r.x,r.y))
        putmarker!(r)
        for side in (Nord, West, Sud, Ost)
            if !cond(r,side)
                move!(r,side); recursive(); move!(r,inverse(side))
            end
        end
    end
    recursive()
end

function recursive_andrcross!(r :: Robot)
    cr=AndrCrossRobot(r,0,0)
    fill((r,side)->isborder(r,side), cr)
end