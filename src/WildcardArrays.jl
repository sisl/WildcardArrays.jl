module WildcardArrays

using OrderedCollections
import Base: show, size, ndims, eltype

struct WildcardArray{T,N} <: AbstractArray{T,N}
    data::OrderedDict{NTuple{N,Int},T} # this would be the ordered map
    dims::NTuple{N,Int}
    default::T
end

WildcardArray(s::String, values::Vector{T}; default=0.0, startindex=0) where T = parse(s, values, default=default, startindex=startindex)

Base.size(wa::WildcardArray) = wa.dims
Base.ndims(wa::WildcardArray) = length(wa.dims)
function Base.show(io::IO, m::MIME"text/plain", wa::WildcardArray{T,N}) where {T,N}
    println("WildcardArray{$T,$N}")
    [println("$(kk) => $(vv)") for (kk,vv) in zip(keys(wa.data), values(wa.data))]
end 
Base.show(wa::WildcardArray) = Base.show(stdout, MIME("text/plain"), wa) 
Base.eltype(::WildcardArray{T,N}) where {T,N} = T

dict(wa::WildcardArray) = wa.data

include("./getindex.jl")

export 
    WildcardArray,
    dict
include("./parse.jl")

end

