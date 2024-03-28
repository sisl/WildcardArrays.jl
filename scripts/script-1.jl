using WildcardArrays, OrderedCollections

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

states = ["warm", "cold", "not-to-cold", "very-very-cold", "almost-cold", "ow-this-is-very-cold"]
actions = ["north", "south", "east", "west"]
observations = ["warning", "more-warning"]
vv = [actions, states, states, observations]
nothing
