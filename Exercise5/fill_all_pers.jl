 using HorizonSideRobots

 inverse(side :: HorizonSide) = HorizonSide(mod(Int(side)+2,4))
 
 clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+3,4))

 anticlockwise(side :: HorizonSide) = HorizonSide(mod(Int(side)+1,4))

function go!(r :: Robot, side :: HorizonSide; paint=false)
    while !isborder(r,side) && !ismarker(r)
        if paint putmarker!(r) end
        move!(r,side)
    end
end

function go!(r :: Robot, side :: HorizonSide, steps :: Int)
    while steps>0
        if detect_inner_border(r,side) return true end
        move!(r,side)
        steps-=1
    end
    return false
end

function go!(r :: Robot, side :: HorizonSide)
    while isborder(r,clockwise(side))
        putmarker!(r)
        move!(r,side)
    end
end

function perfill!(r :: Robot)
    side=Nord
    go!(r,side)
    while !ismarker(r)
        side=clockwise(side)
        go!(r,side;paint=true)
    end
end

function fill_inper(r :: Robot)
    side=anticlockwise(detect_inner_border(r))
    for i in 0:3
        go!(r,side)
        side=clockwise(side)
        move!(r,side)
    end
end

function close_area(r :: Robot, width :: Int, height :: Int)
    width=max(0,width)
    height=max(0,height)
    for i in [3,2,1,0]
         if go!(r,HorizonSide(mod(i,4)),width*0^((i+1)%2)+height*0^(i%2)) return true end
    end
    move!(r,Sud)
    move!(r,Ost)
    return false
end

function detect_inner_border(r :: Robot, side :: HorizonSide)
    return isborder(r,side) || isborder(r,clockwise(side))
end

function detect_inner_border(r :: Robot)
    for i in 0:3
        if isborder(r,HorizonSide(i)) return HorizonSide(i) end
    end
end

function collibrate!(r :: Robot)
    width, height= 0, 0
    while !isborder(r,Sud) || !isborder(r,Ost)
        if !isborder(r,Sud) move!(r,Sud) end
        if !isborder(r,Ost) move!(r,Ost) end
    end
    while !isborder(r,Nord) || !isborder(r,West)
        if !isborder(r,Nord) 
            move!(r,Nord)
            height+=1
        end
        if !isborder(r,West)
            move!(r,West) 
            width+=1
        end
    end
    return width+1, height+1
end
function fill_all_pers!(r :: Robot)
    width, height=collibrate!(r)
    perfill!(r)
    while !close_area(r,width-1,height-1)
        width=max(0,width-2)
        height=max(0,height-2)
        if height==0 && width==0
            break
        end
    end
    fill_inper(r)
end