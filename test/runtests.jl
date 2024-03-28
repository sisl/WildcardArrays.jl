using WildcardArrays
using Test
using OrderedCollections

# @testset "WildcardArrays.jl" begin

str = """
R: north : warm : cold :more-warning 1 
R: * : cold : almost-cold: warning 

2
R: east : * : almost-cold: warning 3
R: south : cold : *: warning        4
R: * : warm : almost-cold: * 


7




R: east : *: *: more-warning  8
R: east : *: warm: * 9
R: east : cold: *: * 10
R: west : * : * : * 11
R: * : cold : * : * 12
R: * :*: cold : * 13
R: * :*: * : more-warning 14
R: * :*: * : * 0

R: * : * : cold      




0.5 0.5

R: east : warm    




1 2
1 2.
3 8.
1 2
2. 2
1 10

R: * : * 1 2
1 2.
3 8.
1 90000
2. 2
1 10


"""


str_original = deepcopy(str)
name_of_transition = "R"
N = 4

base_regex = ":\\s*(.*?)\\s*" # This is the base regex to capture the values between the colons
begin_regex = "\\s*(?<=($(name_of_transition)))\\s*" # This is the regex to capture the beginning of the line
end_regex = ":\\s*(.*?)\\s+([\\d\\D]*?)(?=($(name_of_transition)|\$))" # This is the regex to capture the end of the line

regex_count_colon = Regex("\\s*(?<=($(name_of_transition)))(.*)(\\n|\$)")

num_colons = Vector{Int}()

for match in eachmatch(regex_count_colon, str)
    aa = match.captures[2]
    push!(num_colons, count(r":", aa))
end

_num_colons = unique(num_colons)
ss = ""

# num_colons = [4,3,2]
string_regex = Vector{String}()

for num in _num_colons
    push!(string_regex, begin_regex * base_regex ^ (num-1) * end_regex)
end
# println(regex_count_colon)
# println(string_regex)
ss = join(string_regex, "|")

# regex_2 = r"\s*(?<=(R))\s*:\s*([\d\D]*?)\s*:\s*([\d\D]*?)\s*:\s*([\d\D]*?)\s*:\s*([\d\D]*?) ([\s\S]*?)(?=(R|$))"


states = ["warm", "cold", "not-to-cold", "very-very-cold", "almost-cold", "ow-this-is-very-cold"]
pushfirst!(states, "*")
dic_states = Dict(states => (i-1) for (i,states) in enumerate(states))
actions = ["north", "south", "east", "west"]
pushfirst!(actions, "*")
dic_actions = Dict(action => (i-1) for (i,action) in enumerate(actions))
observations = ["warning", "more-warning"]
pushfirst!(observations, "*")
dic_observations = Dict(observation=> (i-1) for (i,observation) in enumerate(observations))

index=Vector{NTuple{N,Int}}()
values= Vector{Float64}()

for (match, col) in zip(eachmatch(Regex(ss), str), num_colons)
    captures = match.captures
    filter!(x -> !isnothing(x) && !isempty(x), captures)
    
    if col == N
        action, state, next_state, observation, param = isequal(name_of_transition, match.captures[end]) ? match.captures[2:end-1] : match.captures[2:end]
        param = strip(param, '\n')
        # println(param)
        
        push!(index, (dic_actions[action], dic_states[state], dic_states[next_state], dic_observations[observation]))
        push!(values, parse(Float64, param))
    elseif col == N-1
        action, state, next_state, param = isequal(name_of_transition, match.captures[end]) ? match.captures[2:end-1] : match.captures[2:end]
        param = strip(param, '\n')
        param = string.(split(param))
        # println(param)
        
        for (ii,val) in enumerate(param)
            push!(index, (dic_actions[action], dic_states[state], dic_states[next_state], ii))
            push!(values, parse(Float64,val))
        end

    elseif col == N-2
        action, state, param = isequal(name_of_transition, match.captures[end]) ? match.captures[2:end-1] : match.captures[2:end]
        param = strip(param, '\n')
        param = string.(split(param, '\n'))

        for (jj,line) in enumerate(param)
           for (ii,entry) in enumerate(string.(split(line)))
                push!(index, (dic_actions[action], dic_states[state], jj, ii))
                push!(values, parse(Float64,entry))
           end 
        end
    else
        error("Unable to parse this string")
    end
end

trans = OrderedDict(tuple => value for (tuple, value) in zip(index,values))
println(index)
println(values)
nothing




# bb = match(reg_ex, str)
# # println(bb.captures)
# # println(str[maximum(bb.offsets):end])

# while bb != nothing
#     global str, bb
#     println(str)
#     # sleep(4)
#     println(bb.captures)
#     # sleep(1)
#     str = str[maximum(bb.offsets):end]
#     # println(str)
#     # sleep(1)
#     bb = match(reg_ex, str)
# end

# # println(bb.captures)

# # aa = string.(split(str, "\n"))
# # aa = filter(!isempty, aa)

# nothing
# # wa = WildcardArray{Float64, 4}(4, 6, 6, 2)
# # parse!(wa, str, [actions, states, states, observations])
# # @test size(wa) == (4, 6, 6, 2)
# # @test eltype(wa) == Float64
# # @test wa[1, 1, 1, 1] == 6

# # end
