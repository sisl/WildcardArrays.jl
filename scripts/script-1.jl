using WildcardArrays

str = """
T: east : warm : almost-cold 0.5  
T: west : cold : * 9.7
T: west : almost-cold
0.1 0.1 0.1 0.1 0 0.6
T: west : cold
uniform
T: south 
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
T: east
    uniform
T: north
 	identity
T: * : *
0.1 0.2 0.3 0.4 0 0 
T: * : * 0.1 0.2 0.3 0.4 0 0 
T: * : warm 0.1 0.3 0.2 0.4 0 0 
T: north : * 0.2 0.1 0.3 0.4 0 0 
T: *
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
0.1 0.1 0.1 0.1 0 0.6
T: west : warm: warm 100
"""

actions = ["north", "south", "east", "west"]
states = ["warm", "almost-cold", "cold"]

vv = [actions, states, states]
wa = WildcardArrays.parse(str, vv)
nothing