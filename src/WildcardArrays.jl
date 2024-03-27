module WildcardArrays

using OrderedCollections

struct WildcardArray{T<:Real,N} <: AbstractArray{T,N}
    data::OrderedDict{NTuple{N,Int},T} # this would be the ordered map
    dims::NTuple{N,Int}
    WildcardArray(dims::NTuple{N, Int}) where {N} = new{Float64, N}(OrderedDict{NTuple{N, Int}, Float64}(), dims)
    # WildcardArray(dims::Vararg{Int, N}) = new(OrderedDict{NTuple{N, Int}, T}(), Tuple(dims))
end

Base.size(wa::WildcardArray) = wa.dims
dict(wa::WildcardArray) = wa.data
eltype(::WildcardArray{T,N}) where {T,N} = T

function Base.getindex(wa::WildcardArray{T,N}, i::Vararg{Int,N})::T where {T,N}
    keys_obj = dict(wa) |> keys |> collect
    # println(keys_obj)
    # println(eltype(wa))

    if any(x -> x <= 0, i) || any(i[index] > size(wa)[index] for index in 1:N)
        error("Indices must be integers larger than zero and less than or equal to the entries of the vector $(size(wa))")
    end

    index = 0

    for kk in Iterators.product([[0, index] for index in i]...)
        temp_index = findfirst(x -> isequal(x, kk), keys_obj)

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
    ~, d₁, d₂ = size(wa)
    regex_first_colon = r"^([^:]*):"
    name_of_transition = match(regex_first_colon, s).captures[1] |> strip
    
    sp = _parse_string(s, regex_first_colon)
    
    reg_ex = Regex("\\s*$(name_of_transition):(.*):(.*):(.*):\\s*(\\S*) (\\s*.*\\s*){1,$(d₁)}R:|\\s*$(name_of_transition):(.*):(.*):(.*):\\s*(\\S*) \\s*(.*)\\s*\$")
    match_reg = match(reg_ex, s)
    tempstr = deepcopy(s)

    while !isnothing(match_reg)
        println(match_reg.captures)
        println(tempstr)
        tempstr = tempstr[maximum(match_reg.offsets) + 1:end] 
        match_reg = match(reg_ex, tempstr)
    end

    return nothing
    # parse string into WildcardArray
end

function parse!(wa::WildcardArray, s::String)
    # parse string into WildcardArray
end

function _parse_string(s::String, prefix::Regex)
    sp = string.(split(s, "\n"))
    spp = map(strip, [replace(line, prefix => "") for line in sp])
    filter!(!isempty, spp)

    return join(spp, " \n ") 
end


end