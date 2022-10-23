include("countbords.jl")
r=Robot("start_cond.sit";animate=true)
countbords!(r)
#show!(r)