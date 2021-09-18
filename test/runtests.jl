using GraphNeuralNetworks
using Flux
using CUDA
using Flux: gpu, @functor, f64, f32
using LinearAlgebra, Statistics, Random
using NNlib
using LearnBase
using LightGraphs
using Zygote
using Test
CUDA.allowscalar(false)

include("test_utils.jl")
include("cuda/test_utils.jl")

tests = [
    "gnngraph",
    "msgpass",
    "layers/basic",
    "layers/conv",
    "layers/pool",
]

!CUDA.functional() && @warn("CUDA unavailable, not testing GPU support")

# Testing all graph types. :sparse is a bit broken at the moment
@testset "GraphNeuralNetworks: graph format $graph_type" for graph_type in (:coo, :sparse, :dense)

    global GRAPH_T = graph_type
    for t in tests
        include("$t.jl")

        if CUDA.functional() && GRAPH_T != :sparse && isfile("cuda/$t.jl")
            include("cuda/$t.jl")
        end
    end
end