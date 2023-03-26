# Visualizations

## Greedy alg
"""
Given coverage matrix F, weight vector w, and cardinality constraint `b` solve `greedy_max_coverage` and plot the results.
"""
function plot_greedy_max_coverage(F,w,b)
    iter_objective,iter_coverage,S_best = greedy_max_coverage(F,w,b)
    plot(iter_objective,
        label=L"$F(S_{i-1} \cup \{k_i\}) - F(S_{i-1})$ (Objective)")
    plot(iter_coverage,label=L"$F(S_i)$ (Weighted Coverage)")
    xlabel!("Sensor placement strategy size")
    ylabel!("Weighted Coverage")
end

"""
Given vector of coverage results vs. time, plot the greedy_max_coverage results.
"""
function plot_greedy_max_coverage(results::Vector{Any})
    
    num_strategy_sizes = length(results[1]) #length(b_1,b_2,b_3...)
    
    # Get the last iteration of each result
    coverage_b_T = zeros(length(results),num_strategy_sizes)
    b_sizes = sort([b for b in keys(results[1])])
    for (t,result_t) in enumerate(results)
        for (b_idx,b)  in enumerate(b_sizes)
            result_b_t = result_t[b]
            coverage_b_T[t,b_idx] = result_b_t["iter_coverage"][end]
        end
    end
    p = plot(coverage_b_T,
        label=permutedims([L"$b="*string(b)*L"$" for b in b_sizes]),
        title=L"$F(S_t) = \sum_{e} w_e 1[e \in \bigcup_{i \in S_t} C_i]$",
        ylabel="Weighted Wildfire Risk Coverage",
        xlabel=L"time $t$"
        )
    return p
end


"""
Given objective and coverage iterations for `greedy_max_coverage`, plot the results vs. strategy size.
"""
function plot_greedy_max_coverage(iter_objective::Vector{Float64},iter_coverage)
    @assert length(iter_objective) == length(iter_coverage) "mismatch in objective and coverage vectors"
    b_max = length(iter_coverage) -1
    p1 = plot(0:b_max,iter_objective,
        title=L"$F(S_{i-1} \cup \{k_i\}) - F(S_{i-1})$",
        ylabel="Greedy Objective")
    p2 = plot(0:b_max,iter_coverage,
        title=L"$F(S_i) = \sum_{e} w_e 1[e \in \bigcup_{i \in S_i} C_i]$",
        ylabel="Weighted Wildfire Coverage"
    )
    p = plot(p1,p2,legend=false,xlabel=L"Charger strategy size $|S_i|$")
    return p
end


## IP alg


## Visulize Graphs
"""
Plots a PowerNetworkGraph with GraphRecipes.jl
"""
function plot_network(g::PowerNetworkGraph)
    graphplot(A,
          markersize = 0.2,
          fontsize = 10,
          linecolor = :darkgrey
          )
    
end

