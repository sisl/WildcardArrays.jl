module WildcardArrays

struct WildcardArray{T,N} <: AbstractArray{T,N}
    data # this would be the ordered map
    dims::NTuple{N,Int}
end

Base.size(wa::WildcardArray) = wa.dims

function Base.getindex(wa::WildcardArray, i::Vararg{Int, N}) where {N} 
    # put implementation here
end

Base.ndims(wa::WildcardArray) = length(wa.dims)

function parse(s::String)
    # parse string into WildcardArray
end

end