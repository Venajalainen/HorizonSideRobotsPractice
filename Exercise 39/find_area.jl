include("../RobotHell.jl")
include("../Exercise 33-35/specrobot.jl")

mutable struct AreaFinder{RobotType} <: CoordFamily

    robot :: RobotType
    area :: Int
    rotation :: Rotation
    horizontal_direction :: HorizonSide

    function AreaFinder{RobotType}( robot :: RobotType) where RobotType <: Union{Robot, SampleRobot}

        brobot= BorderRobot{RobotType}( robot  )

        new_robot :: CoordFamily = new_robot = typeof(robot) <: CoordFamily ? robot : CoordRobot( robot )
        area :: Int = 0
        rotation :: Rotation = get_rotation( brobot )
        horizontal_direction :: HorizonSide = get_direction(brobot) in [West,Ost] ? get_direction(brobot) : West

        return new{typeof(new_robot)}( new_robot, area, rotation, horizontal_direction)

    end

end

add_area( robot :: AreaFinder, number :: Int, y :: Int) = (robot.area=robot.area+y*(number-2)-1*mod(number,3))

function HorizonSideRobots.move!(robot :: AreaFinder, side :: HorizonSide)

    r=get_robot(robot)
    x, y=get_coords(robot)


    if isborder(r,Nord) && isborder(r,Sud) && inverse(side)==robot.horizontal_direction
        add_area(robot,Int(robot.horizontal_direction),y)
    end

    (side in [West,Ost]) && (robot.horizontal_direction=side) 
    
    borderwall :: HorizonSide = robot.rotation == Right ? right!( robot.horizontal_direction ) : left!( robot.horizontal_direction )

    if isborder(r,borderwall)
        putmarker!(r)
        add_area(robot,Int(robot.horizontal_direction),y)
    end

    move!(r, side)
end

function find_area!( robot :: RobotType ) where RobotType <: Union{Robot, SampleRobot}

    areafinder = AreaFinder{RobotType}( robot )

    around_the_world!( areafinder )

    return abs(areafinder.area)
end