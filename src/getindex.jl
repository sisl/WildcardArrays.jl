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