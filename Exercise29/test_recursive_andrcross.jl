include("recursive_andrcross.jl")
r=Robot("start_cond.sit")
recursive_andrcross!(r)
show!(r)