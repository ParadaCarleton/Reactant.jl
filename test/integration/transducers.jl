using Test
using Reactant
using Transducers

@testset "Transducers folds over traced arrays" begin
    values = Float32[1, 2, 3, 4]
    traced = Reactant.to_rarray(values)

    associative(array) = foldxl(+, Map(exp), array)
    with_init(array) = foldxl(+, Map(exp), array; init=1.0f0)
    sequential(array) = foldxl((total, element) -> total + 2element, Map(exp), array; init=0.0f0)

    @test Float32(@jit(associative(traced))) ≈ sum(exp, values)
    @test Float32(@jit(with_init(traced))) ≈ 1 + sum(exp, values)
    @test Float32(@jit(sequential(traced))) ≈ foldl((total, element) -> total + 2element, exp.(values); init=0.0f0)
end
