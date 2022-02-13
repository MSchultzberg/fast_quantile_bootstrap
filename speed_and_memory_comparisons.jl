using Random
using Distributions
using BenchmarkTools
include("algorithms.jl")

##########################################################
########## Speedchecks
Random.seed!(0072)
genNorm = Normal(1,1)
N = 1000
B = 10000
quant = 0.5
alpha = 0.05
x = rand(genNorm, N)
y = rand(genNorm, N)
BenchmarkTools.DEFAULT_PARAMETERS.samples = 100
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 200
a = @benchmark two_sample_poisson_boot_ci_quant(x,y, B, N, alpha, quant)
b = @benchmark two_sample_poisson_boot_ci_quant_faster(x,y, B, N, alpha, quant)
