using HypothesisTests
using Distributions
using StatsBase

function two_sample_poisson_boot_ci_quant(x,y, B, N, alpha, quant)
    theta_quantile_diff = []
    genPois = Poisson(1)

    for b in 1:B
        pois_temp=rand(genPois, N)
        append!(theta_quantile_diff, quantile(vcat(fill.(x, pois_temp)...),quant) - quantile(vcat(fill.(y, pois_temp)...), quant))
    end
    return quantile!(theta_quantile_diff, [alpha/2,1-alpha/2])
end


function two_sample_poisson_boot_ci_quant_faster(x,y, B, N, alpha, quant)

    genBinom = Binomial(N+1, quant)
    binom_sample1_quantile_indexes=rand(genBinom, B)
    binom_sample2_quantile_indexes=rand(genBinom, B)
    ordered_y = sort(y)
    ordered_x = sort(x)
    diff_in_quantile = ordered_x[binom_sample1_quantile_indexes] - ordered_y[binom_sample2_quantile_indexes]

    return quantile!(diff_in_quantile, [alpha/2,1-alpha/2])
end


function one_sample_poisson_boot_ci_quant_faster(x, B, N, alpha, quant)
    ordered_x = sort(x)
    bounds = quantile(Binomial(N+1,quant), [alpha/2, 1-alpha/2])
    return ordered_x[[floor(bounds[1]),ceil(bounds[2])]]
end
