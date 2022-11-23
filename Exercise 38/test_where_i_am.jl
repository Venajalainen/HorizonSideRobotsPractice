include("where_i_am.jl")

number_of_tests = 8

function test( i :: Int)
    r=Robot("test$i.sit")
    ("test$i", where_i_am(r)) |> println
    show!(r)
end

for i in 1:number_of_tests
    test(i)
end