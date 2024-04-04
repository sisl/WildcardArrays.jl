# WildcardArrays.jl

[![Build Status](https://github.com/sisl/WildcardArrays.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/sisl/WildcardArrays.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![codecov](https://codecov.io/gh/sisl/WildcardArrays.jl/branch/master/graph/badge.svg?token=btTBnBTQyw)](https://codecov.io/gh/sisl/WildcardArrays.jl)

## Brief description

This package offers an interface to create matrices from a Julia string. It uses wildcards to represent the sparsity pattern of a matrix. For instance, we represent a sparse matrix of dimension 3 x 3 x 5 where all non-zero elements lie in the ``row`` (3,2) by
```
matrix_s = """
: 2 : 1 : * 1
"""
```
where the first colon represents the start of a specification, and the three subsequent characters (2,1,\*) specify that the value 1 should be stored to all elements of the row (3,2). Our default standard is to adopt a zero-based indexing of the matrix entries, but this can be changed according to the user preference. 


## Installation

To use this package, please run the command

```julia
] add git@github.com:sisl/WildcardArrays.jl.git
```

## API 

WildcardArrays.jl exports a julia type called WildcardArray that can parse string representations.  
```
WildcardArray(s::String, values::Vector{T}; default=0.0, startindex=0) where T <: Union{Any, Int, Vector{String}}
```

The (optional) default parameter is the value to be returned when querying a WildcardArray at an index that is not explicitly specified in its string definition, e.g., this would lead to zero being returned when querying the matrix in the above example at the index 1,1,1. Startindex can be used to change the indexing of a WildcardArray. 

The Julia code below can be used to create a WildcardArray from `matrix_s`

```julia
using WildcardArrays

matrix_s = """ 
: 2 : 1 : * 1
"""

dims = [3,3,5]; wa = WildcardArray(matrix_s, dims)
```

## Syntax 

The current version supports instantiation of $\ell$-dimensional matrices $(N_1, N_2, \ldots, N_\ell)$, where $N_i$, $i = 1, \ldots,  \ell$, is an integer representing the size of each dimension, either using numeric values (as in the example above), vectors, and 2D matrices, by means of the following syntax (each of the $n_i$ below, for $i = 1, \ldots, \ell$, can be either an integer less than or equal to $N_i$, or a wild card character '\*'):

### 1. Specifying numerical values
```
: n_1 : n_2 : ... : n_l a
```
This syntax allows us to assign the value 'a' to each element specified by the string $(n_1, \ldots, n_\ell)$. 

### 2. Specifying entire rows using vectors
```julia
: n_1 : n_2 : ... : n_{l-1} a_1 a_2 ... a_{N_l}
```
This syntax allows us to assign the value 'a_j' to the entry $(n_1, n_2, \ldots, n_{\ell-1}, j)$ for all $j =1, \ldots, N_\ell$. The package also accepts the string 'uniform' to be used instead of a vector, as a short notation to define a uniform probability distribution over the elements of the last entry, as in 
```
: n_1 : n_2 : ... : n_{l-1} uniform
 ```
### 3. Specifying entire 2D matrices 
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

For a fully-fledged example, please refer to the Julia code 
```julia
# An example of a 4 x 3 x 3 WildcardArray (notice that we are using a zero-based indexing)

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
wa = WildcardArray(matrix_s, dims)
```

## Application to parse .POMDP files 

The inspiration for this package arose due to our intention to parse the .POMDP file format described in [POMDP.org](http://pomdp.org/code/pomdp-file-spec.html). Recognizing that this data structure could be of wider interest, we decide to wrap its functionality into this package and share it with the Julia community! 

In the near future, we will use the above functionalities to bring the examples from [POMDP.org](http://pomdp.org/code/pomdp-file-spec.html) into the [JuliaPOMDP](https://github.com/JuliaPOMDP) ecosystem by releasing a new version of the [POMDPFiles]() package. Here is a teaser on how this package can be used to parse reward transitions using the syntax described in [POMDP.org](http://pomdp.org/code/pomdp-file-spec.html).  


```julia
using WildcardArrays

str = """
R: * : * 
1 2
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

wa = WildcardArray(str, vv)

wa[1,1,1,1] # This should be equal to one
wa[4,2,4,2] # This should be equal to 90000

nothing
```
