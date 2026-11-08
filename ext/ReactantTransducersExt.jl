module ReactantTransducersExt

using Reactant: Reactant, AnyTracedRArray
using Transducers: Transducers, Completing, InitOf, Map, __foldl__, transduce

"""A sequential fold reads elements one by one. A trace has a static shape, so unrolling is exact."""
function Transducers.__foldl__(rf, init, arr::AnyTracedRArray)
    return Reactant.@allowscalar invoke(__foldl__, Tuple{Any,Any,AbstractArray}, rf, init, arr)
end

"""A Map-only pipeline of an associative operation is one data-parallel reduction."""
function Transducers.transduce(
    xf::Map,
    rf::Completing{<:Union{typeof(+),typeof(*),typeof(max),typeof(min)}},
    init,
    arr::AnyTracedRArray,
)
    return init isa InitOf ? mapreduce(xf.f, rf.f, arr) : mapreduce(xf.f, rf.f, arr; init)
end

end
