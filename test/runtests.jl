using WildcardArrays
using Test
using OrderedCollections

# @testset "WildcardArrays.jl" begin

str = """
R: north : warm : cold :more-warning 1 
R: * : cold : almost-cold: warning 2
R: east : * : almost-cold: warning 3
R: south : cold : *: warning 4
R: south : cold : almost-cold: * 100 
R: * : *: almost-cold: more-warning 5
R: * : warm : *: more-warning 6
R: * : warm : almost-cold: * 7
R: east : *: *: more-warning  8
R: east : *: warm: * 9
R: east : cold: *: * 10
R: west : * : * : * 11
R: * : cold : * : * 12
R: * :*: cold : * 13
R: * :*: * : more-warning 14
R: * :*: * : * 0 
 """

str_original = deepcopy(str)
regex_2 = r"\s*(?<=(R))\s*:\s*([\d\D]*?)\s*:\s*([\d\D]*?)\s*:\s*([\d\D]*?)\s*:\s*([\d\D]*?) ([\s\S]*?)(?=(R|$))"


states = ["warm", "cold", "not-to-cold", "very-very-cold", "almost-cold", "ow-this-is-very-cold"]
pushfirst!(states, "*")
dic_states = Dict(states => (i-1) for (i,states) in enumerate(states))
actions = ["north", "south", "east", "west"]
pushfirst!(actions, "*")
dic_actions = Dict(action => (i-1) for (i,action) in enumerate(actions))
observations = ["warning", "more-warning"]
pushfirst!(observations, "*")
dic_observations = Dict(observation=> (i-1) for (i,observation) in enumerate(observations))

index=Vector{Tuple{Int, Int, Int, Int}}()
values= Vector{Float64}()

for match in eachmatch(regex_2, str)
    action, state, next_state, observation, param = match.captures[2:6]
    param = strip(param, '\n')
    # println(match.captures)
    push!(index, (dic_actions[action], dic_states[state], dic_states[next_state], dic_observations[observation]))
    push!(values, parse(Float64, param))
end

println(index)
println(values)

trans = OrderedDict(tuple => value for (tuple, value) in zip(index,values))

println(dic_states)
println(dic_actions)
println(dic_observations)
println(trans)
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
