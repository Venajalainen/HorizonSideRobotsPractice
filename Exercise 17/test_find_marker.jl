#include("find_marker_a.jl")
#r=Robot("start_cond.sit")
#find_marker_a!(r)
#show!(r)

include("find_marker_b.jl")
r=Robot("findmarkerb.sit")
find_marker_b!(r)
show!(r)