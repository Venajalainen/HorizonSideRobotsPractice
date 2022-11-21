include("../Exercise 33-35/specrobot.jl")

function markborder!( robot :: Robot )
    painter = BorderRobot(CoordRobot( Painter( robot ) ) )
    around_the_world!(painter)
end