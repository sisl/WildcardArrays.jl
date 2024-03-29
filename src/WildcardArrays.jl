module WildcardArrays

using OrderedCollections

struct WildcardArray{T,N} <: AbstractArray{T,N}
    data::OrderedDict{NTuple{N,Int},T} # this would be the ordered map
    dims::NTuple{N,Int}
    default::T
end

Base.size(wa::WildcardArray) = wa.dims
Base.ndims(wa::WildcardArray) = length(wa.dims)

dict(wa::WildcardArray) = wa.data
eltype(::WildcardArray{T,N}) where {T,N} = T

include("./getindex.jl")

export 
    WildcardArray

include("./parse.jl")

end

