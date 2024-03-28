function parse(s::String, values::Vector{Vector{String}}; default=0.0)
    T = typeof(default)
    regex_first_colon = r"^([^:]*):"
    name_of_transition = string(match(regex_first_colon, s).captures[1] |> strip)

    dictionaries = Vector{Dict{String,Int}}()
    for vals in values
        d = Dict(v => i for (i, v) in enumerate(vals))
        d["*"] = 0
        push!(dictionaries, d)
    end

    regex, num_colons = _create_regex(name_of_transition, s)
    N = maximum(num_colons) # the WildcardArray will have N dimensions, where N is the maximum number of colons

    index=Vector{NTuple{N,Int}}()
    vv=Vector{T}()

    for (match, col) in zip(eachmatch(regex, s), num_colons)
        fields = match.captures
        filter!(x -> !isnothing(x) && !isempty(x), fields)

        param = strip(fields[end], ['\n', '\r', ' '])
        if col == N
            push!(index, Tuple(dd[kk] for (dd,kk) in zip(dictionaries, fields[1:end-1])))
            push!(vv, Base.parse(T, param))
        elseif col == N-1
            param = split(param)
            tmp_fields = [dd[kk] for (dd,kk) in zip(dictionaries, fields[1:end-1])] 
            
            for (ii,val) in enumerate(param)
                tt = deepcopy(tmp_fields)
                
                push!(index, Tuple(push!(tt, ii)))
                push!(vv, Base.parse(T,val))
            end

        elseif col == N-2
            param = string.(split(param, '\n'))
            tmp_fields = [dd[kk] for (dd,kk) in zip(dictionaries, fields[1:end-1])] 

            for (jj,line) in enumerate(param)
                tt_1 = deepcopy(tmp_fields)
                push!(tt_1, jj)

                for (ii,entry) in enumerate(string.(split(line)))
                        tt_2 = deepcopy(tt_1)
                        push!(index, Tuple(push!(tt_2, ii)))
                        push!(vv, Base.parse(T,entry))
                end 
            end
        else
            error("Unable to parse this string")
        end
    end

    data = OrderedDict(tuple => fvalue for (tuple, fvalue) in zip(index,vv))
    return WildcardArray(data, Tuple(length(vp) for vp in values), default) 
end

function parse(s::String, dims::Vector{Int}; default=0.0, startindex=0)
    values = [string.(startindex:(startindex+dim-1)) for dim in dims]
    parse(s, values, default=default)
end

function parse(s::String, dims::Vector{Any}; default=0.0, startindex=0)
    values = Vector{String}()

    for vec in dims
        if eltype(vec) == String
            push!(values, vec)
        elseif eltype(vec) == Int
            push!(values, string.(startindex:(startindex+vec-1)))
        else
            error("The elements of the dims vector must be either of type String or Int")
        end
    end

    parse(s, values, default=default)
end
    


function _create_regex(name::String, s::String)
    base_regex = ":\\s*(.*?)\\s*" # This is the base regex to capture the values between the colons
    begin_regex = "\\s*(?<=$(name))\\s*" # This is the regex to capture the beginning of the line
    end_regex = ":\\s*(.*?)\\s+([\\d\\D]*?)(?=$(name)|\$)" # This is the regex to capture the end of the line

    regex_count_colon = Regex("\\s*(?<=($(name)))(.*)(\\n|\$)")

    num_colons = [count(r":", match.captures[2]) for match in eachmatch(regex_count_colon, s)]

    _num_colons = unique(num_colons) # getting the occurence of the number of colons
    string_regex = Vector{String}()

    for num in _num_colons
        push!(string_regex, begin_regex * base_regex ^ (num-1) * end_regex)
    end
    pre_regex = join(string_regex, "|")

    return Regex(pre_regex), num_colons

end
