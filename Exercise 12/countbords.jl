using HorizonSideRobots

inverse( side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))

function collibrate!( r :: Robot; track=false )
    arr=()
    while !isborder(r,Sud) || !isborder(r,West)
        if !isborder(r,Sud) move!(r,Sud); arr=(Nord,arr...) end
        if !isborder(r,West) move!(r,West); arr=(Ost,arr...) end
    end
    if track return arr end
end

gohome!(r :: Robot, arr :: NTuple)=for side in arr move!(r,side) end

function go_count!( r :: Robot, side :: HorizonSide)
    flag=falses(2); c=0
    while !isborder(r,side)
        if isborder(r,Nord)
            if !(flag[1] || flag[2]) c+=1 end
            flag=trues(2)
        else
            if flag[1] flag[1]=false 
            else flag[2]=false end
        end
        move!(r,side)
    end
    return c
end

function countbords!(r :: Robot)
    wayhome=collibrate!(r; track=true); side=Ost; c=0
    while !isborder(r,Nord) && !isborder(r,side)
        c+=go_count!(r,side); side=inverse(side);move!(r,Nord)
        println("c: ", c)
    end
    collibrate!(r)
    gohome!(r,wayhome)
    println(c)
end
