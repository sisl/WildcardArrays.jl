using WildcardArrays
using Test

# @testset "WildcardArrays.jl" begin

str = """
R: north : warm : cold :more-warning 1 
R: * : cold : almost-cold: warning 2
R: east : * : almost-cold: warning 3
R: south : cold : *: warning 4
R: south : cold : almost-cold: * 

7 10 20

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

reg_ex = r"\s*R:(.*):(.*):(.*):\s*(.*) (.*)\s*(R):|\s*R:(.*):(.*):(.*):\s*(\S*) (\s*.*){1,1}\s*(R):|\s*R:(.*):(.*):(.*):\s*(\S*) \s*(.*)\s*$"
# rp = r"\s*R:(.*):(.*):(.*):\s*(.*) (.*)\s*(R):"
# reg_ex = r"R:(.*?)R:|R:(.*):(.*):(.*):(.*) (\d+)\n"
# bb = match(Regex(string(reg_ex.pattern, "|", rp.pattern)),str)
bb = match(reg_ex, str)
# println(bb.captures)
# println(str[maximum(bb.offsets):end])

while bb != nothing
    global str, bb
    println(str)
    # sleep(4)
    println(bb.captures)
    # sleep(1)
    str = str[maximum(bb.offsets):end]
    # println(str)
    # sleep(1)
    bb = match(reg_ex, str)
end

# println(bb.captures)

# aa = string.(split(str, "\n"))
# aa = filter(!isempty, aa)

states = ["warm", "cold", "not-to-cold", "very-very-cold", "almost-cold", "ow-this-is-very-cold"]
actions = ["north", "south", "east", "west"]
observations = ["warning", "more-warning"]
nothing
# wa = WildcardArray{Float64, 4}(4, 6, 6, 2)
# parse!(wa, str, [actions, states, states, observations])
# @test size(wa) == (4, 6, 6, 2)
# @test eltype(wa) == Float64
# @test wa[1, 1, 1, 1] == 6

# end
