module WildcardArrays

using OrderedCollections

struct WildcardArray{T,N} <: AbstractArray{T,N} where T <: Real
    data::OrderedDict{NTuple{N, Int}, T} # this would be the ordered map
    dims::NTuple{N,Int}
    WildcardArray(dims::NTuple{N, Int}) = new(OrderedDict{NTuple{N, Int}, T}(), dims)
    WildcardArray(dims::Vararg{Int, N}) = new(OrderedDict{NTuple{N, Int}, T}(), Tuple(dims))
end

Base.size(wa::WildcardArray) = wa.dims
dict(wa::WildcardArray) = wa.data
eltype(::WildcardArray{T,N}) = T

function Base.getindex(wa::WildcardArray{T,N}, i::Vararg{Int, N})::T 
    keys_obj = dict(wa) |> keys |> collect
    # println(keys_obj)
    # println(eltype(wa))

    if any(x -> x <= 0, i) || any(i[index] > size(wa)[index] for index in 1:N)
        error("Indices must be integers larger than zero and less than or equal to the entries of the vector $(size(wa))")
    end

    index = 0

    for kk in Iterators.product([[0,index] for index in i]...)
        temp_index = findfirst(x->isequal(x,kk), keys_obj)

        if !isnothing(temp_index)
            if temp_index > index
                index = temp_index
            end
        end
    end

    if index == 0
       return zero(T) 
    end

    return dict(wa)[keys_obj[index]]    # put implementation here
end

Base.ndims(wa::WildcardArray) = length(wa.dims)

function parse!(wa::WildcardArray, s::String, values::Vector{Vector{String}})
    # parse string into WildcardArray
end

function parse!(wa::WildcardArray, s::String)
    # parse string into WildcardArray
end


end