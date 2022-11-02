include("recursive_cross.jl")
r=Robot("start_cond.sit")
recursive_cross!(r)
show!(r)