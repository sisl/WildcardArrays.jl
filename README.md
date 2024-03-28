# WildcardArrays

[![Build Status](https://github.com/sisl/WildcardArrays.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/sisl/WildcardArrays.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This package provides an abstraction to parse .pomdp files as described in [POMDP.org](http://pomdp.org/code/pomdp-file-spec.html). It defines a WildcardArrays data structure that is used to efficiently store the information provided by following the .pomdp file format.

We believe this data structure may be of wider interest (we are open for contributions). Our initial goal for its functionality was to bring the wide range of examples from  [POMDP.org](http://pomdp.org/code/pomdp-file-spec.html) into the [JuliaPOMDP](https://github.com/JuliaPOMDP) ecosystem. 

This package provides support to [POMDPFiles](https://github.com/JuliaPOMDP/POMDPFiles.jl), helping it define a POMDP type from .pomdp files. 

## Installation

To use this package, please use the command

```julia
] add git@github.com:sisl/WildcardArrays.jl.git
```

## Quick Start

Below is a simple example that illustrates the package funcitonality:

```julia
using WildcardArrays

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

wa = WildcardArrays.parse(str, vv)
```
