using WildcardArrays
using Test

@testset "WildcardArrays.jl" begin

str = """
R: north : warm : cold :more-warning 6 
R: * : cold : almost-cold: warning 7
R: east : * : almost-cold: warning 7
R: south : cold : *: warning 7
R: south : cold : almost-cold: * 7

R: * : *: almost-cold: more-warning 8
R: * : warm : *: more-warning 8
R: * : warm : almost-cold: * 8
R: east : *: *: more-warning 8
R: east : *: warm: * 8
R: east : cold: *: * 8
R: west : * : * : * 10
R: * : cold : * : * 10
R: * :*: cold : * 10
R: * :*: * : more-warning 10
R: * :*: * : * 0 
"""

states = ["warm", "cold", "not-to-cold", "very-very-cold", "almost-cold", "ow-this-is-very-cold"]
actions = ["north", "south", "east", "west"]
observations = ["warning", "more-warning"]

wa = WildcardArray{Float64, 4}(4, 6, 6, 2)
parse!(wa, str, [actions, states, states, observations])
@test size(wa) == (4, 6, 6, 2)
@test eltype(wa) == Float64
@test wa[1, 1, 1, 1] == 6

end
