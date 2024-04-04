struct PriorityValue{T}
    priority::Int
    value::T
end

struct WildcardArray{T,N} <: AbstractArray{T,N}
    data::Dict{NTuple{N,Int},PriorityValue{T}}
    dims::NTuple{N,Int}
    default::T
end

WildcardArray(s::String, values::Vector{T}; default=0.0, startindex=0) where T <: Union{Vector{String}, Any, Int} = parse(s, values, default=default, startindex=startindex)

Base.size(wa::WildcardArray) = wa.dims
Base.ndims(wa::WildcardArray) = length(wa.dims)
Base.eltype(::WildcardArray{T,N}) where {T,N} = T

function Base.show(io::IO, m::MIME"text/plain", wa::WildcardArray{T,N}) where {T,N}
    println("WildcardArray{$T,$N}")
    [println("$(kk) => $(vv)") for (kk,vv) in zip(keys(wa.data), values(wa.data))]
end 

dict(wa::WildcardArray) = wa.data
