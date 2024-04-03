function Base.getindex(wa::WildcardArray{T,N}, i::Vararg{Int,N})::T where {T,N}
    dict_wildcard = dict(wa) 

    if any(x -> x <= 0, i) || any(i[index] > size(wa)[index] for index in 1:N)
        error("Indices must be integers larger than zero and less than or equal to the entries of the vector $(size(wa))")
    end

    priority = 0
    index = Vector{Int}(undef, N)

    for kk in Iterators.product([[0, index] for index in i]...)
        if haskey(dict_wildcard, kk)
            tmp_priority = dict_wildcard[kk].priority
        else
            tmp_priority = -Inf
        end

        if tmp_priority > priority 
            index = kk 
            priority = tmp_priority
        end
    end

    if priority == 0
        return wa.default
    end

    return dict_wildcard[index].value    # put implementation here
end