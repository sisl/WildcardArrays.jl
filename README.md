# WildcardArrays

[![Build Status](https://github.com/sisl/WildcardArrays.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/sisl/WildcardArrays.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![codecov](https://codecov.io/gh/sisl/WildcardArrays.jl/branch/master/graph/badge.svg?token=btTBnBTQyw)](https://codecov.io/gh/sisl/WildcardArrays.jl)


## Brief description

This package offers an interface to create matrices from a Julia string; it uses wildcards to represent the sparsity pattern in the matrix. For instance, suppose one wants to create a sparse matrix of dimension 3 x 3 x 5, in which all non-zero elements lie in the ``row`` (2,1). Such a matrix can be represented as the string
```julia  
matrix_s = """
: 2 : 1 : * 1
"""
```
where the first colon represents the start a specification and the three subsequent characters (2,1,\*) tell the package to assing the value stored in variable *val* (which can any Number type) to all elements of the row (3,2).  More details about the syntax used by the package is presented below.

WildcardArrays.jl exports a julia type called WildcardArray that can parse string representations.  
```
WildcardArray(s::String, values::Vector{Vector{String}}; default=0.0, startindex=0)

WildcardArray(s::String, values::Vector{T}; default=0.0, startindex=0) where T <: Union{Any, Int}
```

Returning to the example in the beginning, the Julia code below can be used to create a matrix with the adequate sparsity pattern. 

```julia
using WildcardArrays

matrix_s = """ 
: 2 : 1 : * 1
"""

dims = [3,3,5]; wa = WildcardArrays.parse(matrix_s, dims)
```
## Installation

To use this package, please use the command

```julia
] add git@github.com:sisl/WildcardArrays.jl.git
```

## Syntax 

The current version of the package supports instantiation of $\ell$-dimensional matrices $(N_1, N_2, \ldots, N_\ell)$, where $N_i$, $i = 1, \ldots,  \ell$, represents the maximum number of rows in each dimension. The current version supports parsing of matrices either using numeric values (as in the example above), vectors, and 2D matrices, through the syntax presented below 

Each of the $n_i$ below, for $i = 1, \ldots, \ell$, is either an integer less than or equal to $N_i$, or a wild card character '\*'.

### Specifying numerical values
```julia
: n_1 : n_2 : ... : n_l a
```
This syntax allows us to assign the value 'a' to each element specified by the string $(n_1, \ldots, n_\ell)$. 

### Specifying entire rows using vectors
```julia
: n_1 : n_2 : ... : n_{l-1} a_1 a_2 ... a_{N_l}
```
This syntax allows us to assign the value 'a_j' to the entry $(n_1, n_2, \ldots, n_{\ell-1}, j)$ for all $j =1, \ldots, N_\ell$. The package also accepts the string 'uniform' to be used instead of a vector in case one decides to assign a uniform probability distribution to the last entry. This is done using the syntax 
```julia
: n_1 : n_2 : ... : n_{l-1} uniform
 ```
### Specifying entire 2D matrices 
```julia
: n_1 : n_2 : ... : n_{l-2} 
   a11        a12   ...   a1n_l
   a21        a22   ...   a2n_l
    :           :    :      :
    :           :    :      :
an_{l-1}1  an_{l-1}2 ... an_{l-1}n_l
```

This syntax allows us to assign the value 'a_{jk}' to the entry $(n_1, n_2, \ldots, n_{\ell-2}, j, k)$, for all $j = 1, \ldots, N_{\ell-1}$, for all $k = 1, \ldots, N_{\ell}$. The package also allows us to specify identity and uniform matrices using the syntax
```julia
: n_1 : n_2 : ... : n_{l-2} uniform
: n_1 : n_2 : ... : n_{l-2} identity 
```

### Example of the syntax

The code below contains a concrete example of a Julia code that parses a string with most of the syntax described above.
```julia
# An example of a 4 x 3 x 3 WildcardArray (the default value is a zero-based syntax)
matrix_s = """
: 2 : 1 : 2 0.5  
: 3 : 2 : * 9.7
: 0 : 2 0.1 0.4 0.5 
: 1 : 0  uniform 
: 2 
0.1 0.9 0 
0.3 0.3 0.4 
0.7 0.1 0.2 
: 3 
    uniform
: 2 
 	identity
: * : *
0.3 0.4 0.3 
: * : * 
0.1 0.2 0.7 
"""

dims = [4,3,3]
wa = WildcardArrays.parse(matrix_s, dims)
```

## Parsing Partially Observable Markov Decision Processes (POMDP) transitions using the .pomdp file format

This package provides an abstraction to parse .pomdp files as described in [POMDP.org](http://pomdp.org/code/pomdp-file-spec.html). It defines a WildcardArrays data structure that is used to efficiently store the information provided by following the .pomdp file format.

We believe this data structure may be of wider interest (we are open for contributions). Our initial goal for its functionality was to bring the wide range of examples from  [POMDP.org](http://pomdp.org/code/pomdp-file-spec.html) into the [JuliaPOMDP](https://github.com/JuliaPOMDP) ecosystem. 

This package provides support to [POMDPFiles](https://github.com/JuliaPOMDP/POMDPFiles.jl), helping it define a POMDP type from .pomdp files. 


##  

Below is a simple example that illustrates the package funcitonality:

```julia
using WildcardArrays

str = """
R: north : warm : cold :more-warning 1 
R: * : cold : almost-cold: warning 2
R: east : * : almost-cold: warning 3
R: south : cold : *: warning  4
R: * : warm : almost-cold: * 7
R: east : *: *: more-warning  8
R: east : *: warm: * 9
R: east : cold: *: * 10
R: west : * : * : * 11
R: * : cold : * : * 12
R: * :*: cold : * 13
R: * :*: * : more-warning 14
R: * :*: * : * 0
R: * : * : cold 0.5 0.5
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

println(wa.data)
println(wa.dims)
nothing
```
