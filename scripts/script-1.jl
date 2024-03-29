using WildcardArrays
using Debugger

# str_1 = """
# T: east : warm : almost-cold 0.5  
# T: west : cold : * 9.7
# T: west : almost-cold
# 0.1 0.1 0.1 0.1 0 0.6
# T: west : cold
# uniform
# T: south 
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# T: east
#     uniform
# T: north
#  	identity
# T: * : *
# 0.1 0.2 0.3 0.4 0 0 
# T: * : * 0.1 0.2 0.3 0.4 0 0 
# T: * : warm 0.1 0.3 0.2 0.4 0 0 
# T: north : * 0.2 0.1 0.3 0.4 0 0 
# T: *
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# 0.1 0.1 0.1 0.1 0 0.6
# T: west : warm: warm 100
# """

# actions = ["north", "south", "east", "west"]
# states = ["warm", "almost-cold", "cold"]

# vv = [actions, states, states]
# wa = WildcardArrays.parse(str_1, vv)

    str = """
######################################################################
# TRANSITIONS
#

#########################
# Inspection Actions
#
# Inspection does not affect the state of the part (these are all
# non-destructive tests).
T: UT
identity

T: LP
identity

T: VISUAL
identity

#########################
# MACHINE Action
#
# The machining process can introduce defects, either through the 
# machining itself or from handling the part. Thus the part quality 
# can degrade as a result of machinining.
# There is also a chance that the machining process could remove
# a defect, but we ignore this case.
# Note that machining a finished machined part is a bit odd, but
# we assume that should it be chosen it can introduce defects
# from the material handling phase.

T: MACHINE 
#	SA	SB	SC	RA	RB	RC	FA	FB	FC	DONE
#------------------------------------------------------
#SA	
	0.0	0.0	0.0	0.97	0.02	0.01	0.0	0.0	0.0	0.0
#SB	
	0.0	0.0	0.0	0.0	0.99	0.01	0.0	0.0	0.0	0.0
#SC	
	0.0	0.0	0.0	0.0	0.0	1.0	0.0	0.0	0.0	0.0
#RA	
	0.0	0.0	0.0	0.0	0.0	0.0	0.96	0.02	0.02	0.0
#RB	
	0.0	0.0	0.0	0.0	0.0	0.0	0.0	0.98	0.02	0.0
#RC	
	0.0	0.0	0.0	0.0	0.0	0.0	0.0	0.0	1.0	0.0
#FA	
	0.0	0.0	0.0	0.0	0.0	0.0	0.95	0.01	0.04	0.0
#FB	
	0.0	0.0	0.0	0.0	0.0	0.0	0.0	0.96	0.04	0.0
#FC	
	0.0	0.0	0.0	0.0	0.0	0.0	0.0	0.0	1.0	0.0
#DONE
	0.0	0.0	0.0	0.0	0.0	0.0	0.0	0.0	0.0	1.0

#########################
# SHIP Action
# 
# Shipping means the game is over and we proceed to the absorbing 
# state.
T: SHIP : * : DONE 1.0
#########################
# SCRAP Action
#
# Shipping means the game is over and we proceed to the absorbing 
# state.
T: SCRAP : * : DONE 1.0
"""

tmp_str = string.(split(str, "\n"))
# println(tmp_str)
filter!(x -> !startswith(x, '#'), tmp_str)
filter!(x -> !isempty(x), tmp_str)
str = join(tmp_str, "\n")

actions = ["UT", "LP", "VISUAL", "MACHINE", "SHIP", "SCRAP"]
states = ["SLAB-A", "SLAB-B", "SLAB-C", "ROUGH-A", "ROUGH-B", "ROUGH-C", "FIN-A", "FIN-B", "FIN-C", "DONE"]
observations = ["NORMAL", "QUESTIONABLE", "PROBLEM", "GRADE-A", "GRADE-B", "GRADE-C"]

vv = [actions, states, states]
wa = WildcardArrays.parse(str, vv)

nothing