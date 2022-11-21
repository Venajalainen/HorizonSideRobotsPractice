include("where_i_am.jl")
r=Robot("test4.sit"; animate=true)
where_i_am(r) |> println
show!(r)