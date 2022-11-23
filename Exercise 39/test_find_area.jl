include("find_area.jl")

function test( i :: Int )
    r=Robot("test$i.sit")
    ("test$i.sit",find_area!(r)) |>println
    show!(r)
end

number_of_tests=6
for i in 1:number_of_tests
    test(i)
end
