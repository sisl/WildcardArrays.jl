# WildcardArrays

[![Build Status](https://github.com/sisl/WildcardArrays.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/sisl/WildcardArrays.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This package provides an abstraction to parse .pomdp files as described in [POMDP.org](http://pomdp.org/code/pomdp-file-spec.html). It defines a WildcardArrays data structure that is used to efficiently store the information provided by following the .pomdp file format.

We believe this data structure may be of wider interest (we are open for contributions). Our initial goal for its functionality was to bring the wide range of examples from  [POMDP.org](http://pomdp.org/code/pomdp-file-spec.html) into the [JuliaPOMDP](https://github.com/JuliaPOMDP) ecosystem. 

This package provides an abstraction to [POMDPFiles](https://github.com/JuliaPOMDP/POMDPFiles.jl), helping it define a POMDP type from .pomdp files. 
