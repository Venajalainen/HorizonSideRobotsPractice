include("northern_frontier.jl")
r=Robot("test2.sit")
northern_frontier( r ) |> println
show!(r)