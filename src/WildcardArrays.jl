module WildcardArrays

import Base: show, size, ndims, eltype

include("./types.jl") # WildcardArray and PriorityValue
include("./getindex.jl") # implementing get_index for WildcardArray

export 
    WildcardArray

include("./parse.jl") 

end

