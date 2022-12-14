function binary_search( arr :: Array{T}, element :: T ) where T
    first_index=firstindex(arr)
    last_index=lastindex(arr)
    ind=0

    if element>arr[last_index] || element<arr[first_index] return false end


    while true
        mean_index=(first_index+last_index) ÷ 2

        if arr[mean_index]<element
            first_index=mean_index+1
        else
            last_index=mean_index-1
        end

        if arr[mean_index]==element
            return true
        end

        if first_index==last_index ind+=1 end
        if ind==2 break end

    end
    return false
end

function func( x )
    s=1
    while x>0
        s*=x%10
        x÷=10
    end
    return s
end

global c=0

for i in range(    10000,99999)
    if func( i ) % 15 ==0 && func(i)>0
        global c+=1
    end
end

println(c)