include("fill_all_pers.jl")
r=Robot("start_cond.sit")
#r=Robot("test.sit")
fill_all_pers!(r)
show!(r)