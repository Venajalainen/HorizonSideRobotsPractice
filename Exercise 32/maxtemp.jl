using HorizonSideRobots

mutable struct TempCoordRobot
    robot :: Robot
    x :: Int
    y :: Int
    t :: Int
end

switch(f :: Function, x...) = f(x...)

HorizonSideRobots.temperature( r :: TempCoordRobot) = temperature(r.robot)

HorizonSideRobots.isborder( r :: TempCoordRobot, side :: HorizonSide) = isborder(r.robot,side)
function HorizonSideRobots.move!(r :: TempCoordRobot, side :: HorizonSide) 
    switch(side) do side
        side==Nord && (r.y+=1)
        side==Ost && (r.x-=1)
        side==Sud && (r.y-=1)
        side==West && (r.x+=1)
    end
    r.t=max(r.t,temperature(r.robot))
    move!(r.robot,side)
end

inverse( side :: HorizonSide ) = HorizonSide( mod( Int(side) +2 ,4) )

function fill(r :: TempCoordRobot)
    coords= Set{NTuple{2,Int}}()
    function recursive()
        (r.x,r.y) in coords && return
        push!(coords,(r.x,r.y))
        for side in (Nord,West,Ost,Sud)
            if !isborder(r,side)
                move!(r,side); recursive();move!(r,inverse(side))
            end
        end
    end
    recursive()
end

function find_by_temp(r :: TempCoordRobot)
    coords= Set{NTuple{2,Int}}()
    function recursive()
        (r.x,r.y) in coords && return
        r.t==temperature(r) && return
        push!(coords,(r.x,r.y))
        for side in (Nord,West,Ost,Sud)
            if !isborder(r,side)
                move!(r,side); recursive()
                temperature(r) != r.t && move!(r,inverse(side))
            end
        end
    end
    recursive()
end

function maxtemp!(r :: Robot)
    cr=TempCoordRobot(r,0,0,0)
    fill(cr)
    find_by_temp(cr)
    println(cr.t)
end