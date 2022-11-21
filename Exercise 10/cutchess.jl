using HorizonSideRobots

function collibrate(r :: Robot; track=true)
    arr=()
    while !isborder(r,Sud) || !isborder(r,West)
        if !isborder(r,Sud) move!(r,Sud); arr=(Nord, arr...) end
        if !isborder(r,West) move!(r,West); arr=(Ost, arr...) end
    end
    if track return arr end
end

gohome!(r :: Robot, arr :: NTuple) = for side in arr move!(r,side) end

function go!(r :: Robot, side :: HorizonSide, steps :: Int, ind :: Int)
    while steps>0 && !isborder(r,side)
        if mod(steps,2)==ind putmarker!(r) end
        move!(r,side)
        steps-=1
    end
    if mod(steps,2)==ind putmarker!(r) end
end


function cutchess!(r :: Robot,n :: Int)
    arr=collibrate(r)
    side=Ost
    ind= mod(n+1,2)
    for i in 1:n
        go!(r,side,n-1,ind+mod(n,2)*0^mod(i,2))
        if isborder(r,Nord) break end; move!(r,Nord)
        side=inverse(side)
    end
    collibrate(r;track=false)
    gohome!(r,arr)
end