using Random
using Statistics
using Distributions
using CSV
using DataFrames
include("algorithms.jl")

Random.seed!(1234)
genNorm = Normal(0,1)

N = 100000
B = 100000
QQs = [0.01, 0.1, 0.25, 0.5]
alpha = 0.05
reps = 10000

######################### sim 1 – One-sample Bootstrap

file1 = "sim1.csv"
for q in 1:length(QQs)
    for r in 1:reps
        x = rand(genNorm, N)
        y = rand(genNorm, N)

        temp_fast = two_sample_poisson_boot_ci_quant_faster(x,y, B, N, alpha, QQs[q])

        #Significant result fast
        if temp_fast[1]>0 || temp_fast[2]<0
            sig_fast=1
        else
            sig_fast=0
        end
        if mod(r,100)==0
            println(r)
        end

        df = DataFrame(lower_fast=temp_fast[1],upper_fast=temp_fast[2], sig_fast=sig_fast, N=N, B=B,Q=QQs[q], alpha=alpha, rep=r)
        CSV.write(file1, df, header = (r==1&&q==1), append = true)
    end
end



#########################sim2 – Two-sample Bootstrap

file2 = "sim2.csv"
for q in 1:length(QQs)
    normquant=quantile(genNorm, QQs[q])
    for r in 1:reps
        x = rand(genNorm, N)
        temp_fast = one_sample_poisson_boot_ci_quant_faster(x, B, N, alpha, QQs[q])

        #Significant result
        if temp_fast[1]>normquant || temp_fast[2]<normquant
            sig_fast=1
        else
            sig_fast=0
        end
        if mod(r,100)==0
            println(r)
        end

        df = DataFrame(lower_fast=temp_fast[1],upper_fast=temp_fast[2], sig_fast=sig_fast, N=N, B=B,Q=QQs[q], alpha=alpha, rep=r)
        CSV.write(file2, df, header = (r==1&&q==1), append = true)
    end
end
