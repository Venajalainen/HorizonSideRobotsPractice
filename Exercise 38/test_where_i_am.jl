include("where_i_am.jl")
r=Robot("untitled.sit"; animate=true)
where_i_am(r) |> println
show!(r)