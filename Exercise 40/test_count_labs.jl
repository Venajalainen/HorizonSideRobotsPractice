include("count_labs.jl")
r = Robot("test2.sit")
count_labs( r ) |> println
show!(r)