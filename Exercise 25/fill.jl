using HorizonSideRobots

mutable struct CoordRobot
    robo :: Robot
    x :: Int
    y :: Int
end

switch(f :: Function, x...) = f(x...)

inverse( side :: HorizonSide ) = HorizonSide( mod( Int( side ) + 2, 4 ))

function HorizonSideRobots.move!(r :: CoordRobot, side :: HorizonSide)
    putmarker!(r.robo)
    switch(side) do side
        side==Nord && (r.y+=1)
        side==Sud && (r.y-=1)
        side==West && (r.x+=1)
        side==Ost && (r.x-=1)
    end
    move!(r.robo,side)
end

function fill!(robot :: Robot)
    coords=Set{NTuple{2,Int}}(); r=CoordRobot(robot,0,0)
    function recursive()
        ((r.x,r.y) in coords) && return
        push!(coords,(r.x,r.y))
        for side in (Nord, West, Sud, Ost)
            if !isborder(r.robo,side)
                move!(r,side); recursive(); move!(r,inverse(side))
            end
        end
    end
    recursive()
end