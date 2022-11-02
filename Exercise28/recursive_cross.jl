using HorizonSideRobots

mutable struct CrossRobot
    robot :: Robot
    x :: Int
    y :: Int
end

switch(f :: Function, x...) = f(x...)

inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

function HorizonSideRobots.move!(r :: CrossRobot, side :: HorizonSide)
    switch(side) do side
        side==Nord && (r.y+=1)
        side==West && (r.x+=1)
        side==Sud && (r.y-=1)
        side==Ost && (r.x-=1)
    end
    move!(r.robot,side)
end

HorizonSideRobots.isborder(r :: CrossRobot, side :: HorizonSide) = isborder(r.robot,side)

HorizonSideRobots.ismarker(r :: CrossRobot) = ismarker(r.robot)

HorizonSideRobots.putmarker!(r :: CrossRobot) = putmarker!(r.robot)

function fill(cond :: Function, r :: CrossRobot )
    coords=Set{NTuple{2,Int}}()
    function recursive()
        ((r.x,r.y) in coords) && return
        push!(coords,(r.x,r.y))
        (r.x)*(r.y)==0 && putmarker!(r)
        for side in (Nord, West, Sud, Ost)
            if !cond(r,side)
                move!(r,side); recursive(); move!(r,inverse(side))
            end
        end
    end
    recursive()
end

function recursive_cross!(r :: Robot)
    cr=CrossRobot(r,0,0)
    fill((r,side)->isborder(r,side), cr)
end