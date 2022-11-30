include("../RobotHell.jl")
include("specrobot.jl")

r=Robot("test2.sit";animate=true)
robot=BorderRobot(r)
putmarker!(robot)
around_the_world!(robot)