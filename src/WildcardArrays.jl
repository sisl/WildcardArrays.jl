module WildcardArrays

using OrderedCollections

struct WildcardArray{T,N} <: AbstractArray{T,N}
    data::OrderedDict{NTuple{N, Int}, T} # this would be the ordered map
    dims::NTuple{N,Int}
end

Base.size(wa::WildcardArray) = wa.dims
dict(wa::WildcardArray) = wa.data

function Base.getindex(wa::WildcardArray, i::Vararg{Int, N}) where {N} 
    keys_obj = dict(wa) |> keys |> collect

    # if !isequal(n,3)
    #     error("The key argument must be an integer tuple of size equal to 3")
    # end

    if any(x -> x <= 0, i) || any(i[index] > size(wa)[index] for index in 1:N)
        println(i)
        error("Indices must be integers larger than zero and less than or equal to the entries of the vector $(max_num)")
    end

    index = 1
    status = false

    possible_keys = Iterators.product([[0,index] for index in i]...) |> collect 
    
    # [collect(key), [key[1], 0, 0], [key[1], 0, key[3]], [key[1], key[2], 0], [0, key[2], 0], [0, key[2], key[3]], [0, 0, key[3]], [0,0,0]] # all possible keys on the reduced dictionary
    
    for kk in possible_keys
        temp_index = findfirst(x->isequal(x,kk), keys_obj)

        if !isnothing(temp_index)
            status = true
            if temp_index > index
                index = temp_index
            end
        end
    end

    if !status
       return nothing 
    end

    return dict(wa)[keys_obj[index]]    # put implementation here
end

Base.ndims(wa::WildcardArray) = length(wa.dims)

function parse(s::String)
    # parse string into WildcardArray
end

end