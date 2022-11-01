include("twice.jl")
r=Robot("start_cond.sit"; animate=true)
print(twice!(r,West))