function parse(s::String, values::Vector{Vector{String}}; default=0.0, startindex=0) 
    T = typeof(default)
    N = length(values)
    regex_first_colon = r"^([^:]*):"
    name_of_transition = string(match(regex_first_colon, s).captures[1] |> strip)

    dictionaries = Vector{Dict{String,Int}}()
    for vals in values
        d = Dict(v => i for (i, v) in enumerate(vals))
        d["*"] = 0
        push!(dictionaries, d)
    end

    regex, collection_regex, num_colons, dic_colons = _create_regex(name_of_transition, s) 

    index=Vector{NTuple{N,Int}}()
    vv=Vector{T}()

    for (m, col) in zip(eachmatch(regex, s), num_colons)
        tmp_str = "$(name_of_transition)" * m.match * "\n$(name_of_transition):"
        fields = match(collection_regex[dic_colons[col]], tmp_str).captures # choosing the right regex. dic_colons[col] contains the index of the correct regex 
        deleteat!(fields, 1) # remove the first element which is the name_of_transition 
        fields = map(x->strip(x, ['\n', '\r', ' ']), fields)

        param = fields[end]
        if col == N
            push!(index, Tuple(dd[kk] for (dd,kk) in zip(dictionaries, fields[1:end-1])))
            push!(vv, Base.parse(T, param))

        elseif col == N-1
            param = string.(split(param))
            tmp_fields = [dd[kk] for (dd,kk) in zip(dictionaries, fields[1:end-1])] 

            if isequal(param, ["uniform"])
                param = [string(1/length(values[end])) for _ in values[end]]
            end

            for (ii,val) in enumerate(param)
                tt = deepcopy(tmp_fields)
                
                push!(index, Tuple(push!(tt, ii)))
                push!(vv, Base.parse(T,val))
            end

        elseif col == N-2
            param = string.(split(param, '\n'))
            tmp_fields = [dd[kk] for (dd,kk) in zip(dictionaries, fields[1:end-1])] 

            if isequal(param, ["uniform"])
                param = [join([string(1/length(values[end])) for _ in values[end]], " ") for __ in 1:length(values[end-1])] # if uniform, then create the uniform matrix
            end

            if isequal(param, ["identity"])
                param = [join([i == j ? "1.0" : "0.0" for j in 1:length(values[end])], " ") for i in 1:length(values[end-1])] # if identity, then create the identity matrix
            end

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

function parse(s::String, values::Vector{T}; default=0.0, startindex=0) where T <: Union{Any, Int}
    vv = Vector{Vector{String}}()

    for vec in values
        if Base.eltype(vec) == String
            push!(vv, vec)
        elseif vec isa Int
            push!(vv, string.(startindex:(startindex+vec-1)))
        else
            error("The elements of the values must be either of a Vector{String} or Int. Unable to parse this string.")
        end
    end

    parse(s, vv, default=default)
end
    


function _create_regex(name::String, s::String) 
    base_regex = ":\\s*([^:\\s]+)\\s*" # This is the base regex to capture the values between the colons
    begin_regex = "(\\s*[(?<=$(name))\\s+]\\s*|\\s*)" # This is the regex to capture the beginning of the line
    end_regex = ":\\s*([^:\\s]+)\\s+([^$(name):]*)[\\s\$]*" # This is the regex to capture the end of the line

    regex_count_colon = Regex("\\s*$(name)\\s*:(.*)|\\s*:(.*)")
    num_colons = [count(r":", m.match) for m in eachmatch(regex_count_colon, s)]
    _num_colons = unique(num_colons) # getting the occurence of the number of colons
    filter!(x->x>0, _num_colons) # removing possible zeros
    filter!(x->x>0, num_colons) # removing possible zeros

    sorted_colons = sort(_num_colons, rev=true)
    string_regex = [begin_regex * base_regex ^ (num-1) * end_regex for num in sorted_colons] 
    pre_regex = join(string_regex, "|")
    ordinal_colons = Dict(num => i for (i, num) in enumerate(sorted_colons))

    return Regex(pre_regex), Regex.(string_regex), num_colons, ordinal_colons
end
