function parse(s::String, values::Vector{Vector{String}})
    dims = [length(vp) for vp in values] # the dimensions will be given by the values vector
    regex_first_colon = r"^([^:]*):"
    name_of_transition = string(match(regex_first_colon, s).captures[1] |> strip)
    
    # sp = _parse_string(s, regex_first_colon) # removing the name of the transition

    dictionaries = Vector{Dict}()

    for vec in values
        tmp = deepcopy(vec)
        pushfirst!(tmp, "*")
        push!(dictionaries, Dict(nn => (vv - 1) for (vv, nn) in enumerate(tmp)))
    end

    regex, num_colons = _create_regex(name_of_transition, s)
    N = maximum(num_colons) # the WildcardArray will have N dimensions, where N is the maximum number of colons

    index=Vector{NTuple{N,Int}}()
    vv=Vector{Float64}()

    for (match, col) in zip(eachmatch(regex, s), num_colons)
        fields = match.captures
        filter!(x -> !isnothing(x) && !isempty(x), fields)
        
        if col == N
            param = strip(fields[end], '\n')
            param = strip(param, ' ')
            
            push!(index, Tuple(dd[kk] for (dd,kk) in zip(dictionaries, fields[1:end-1])))
            push!(vv, Base.parse(Float64, param))
        elseif col == N-1
            param = strip(fields[end], '\n')
            param = string.(split(param))

            tmp_fields = [dd[kk] for (dd,kk) in zip(dictionaries, fields[1:end-1])] 
            
            for (ii,val) in enumerate(param)
                tt = deepcopy(tmp_fields)
                
                push!(index, Tuple(push!(tt, ii)))
                push!(vv, Base.parse(Float64,val))
            end

        elseif col == N-2
            param = strip(fields[end], '\n')
            param = string.(split(param, '\n'))

            tmp_fields = [dd[kk] for (dd,kk) in zip(dictionaries, fields[1:end-1])] 

            for (jj,line) in enumerate(param)
                tt_1 = deepcopy(tmp_fields)
                push!(tt_1, jj)

                for (ii,entry) in enumerate(string.(split(line)))
                        tt_2 = deepcopy(tt_1)
                        push!(index, Tuple(push!(tt_2, ii)))
                        push!(vv, Base.parse(Float64,entry))
                end 
            end
        else
            error("Unable to parse this string")
        end
    end

    data = OrderedDict(tuple => fvalue for (tuple, fvalue) in zip(index,vv))

    return WildcardArray{Float64, N}(data, Tuple(dims)) 
    
end

# function _parse_string(s::String, prefix::Regex)
#     sp = string.(split(s, "\n"))
#     spp = map(strip, [replace(line, prefix => "") for line in sp])
#     filter!(!isempty, spp)

#     return join(spp, " \n ") 
# end

function _create_regex(name::String, s::String)
    base_regex = ":\\s*(.*?)\\s*" # This is the base regex to capture the values between the colons
    begin_regex = "\\s*(?<=$(name))\\s*" # This is the regex to capture the beginning of the line
    end_regex = ":\\s*(.*?)\\s+([\\d\\D]*?)(?=$(name)|\$)" # This is the regex to capture the end of the line

    regex_count_colon = Regex("\\s*(?<=($(name)))(.*)(\\n|\$)")

    num_colons = Vector{Int}()

    for match in eachmatch(regex_count_colon, s)
        tmp = match.captures[2]
        push!(num_colons, count(r":", tmp))
    end

    _num_colons = unique(num_colons) # getting the occurence of the number of colons
    string_regex = Vector{String}()

    for num in _num_colons
        push!(string_regex, begin_regex * base_regex ^ (num-1) * end_regex)
    end
    pre_regex = join(string_regex, "|")

    return Regex(pre_regex), num_colons

end
