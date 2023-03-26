# Visualizations

## Greedy alg
"""
Given cardinality constraint `b` solve `greedy_max_coverage` and plot the results.
"""
function plot_greedy_max_coverage(b)
    iter_objective,iter_coverage,S_best = greedy_max_coverage(b)
    plot(iter_objective,
        label=L"$F(S_{i-1} \cup \{k_i\}) - F(S_{i-1})$ (Objective)")
    plot(iter_coverage,label=L"$F(S_i)$ (Weighted Coverage)")
    xlabel!("Sensor placement strategy size")
    ylabel!("Weighted Coverage")
end

"""
Given cardinality constraint `b` solve `greedy_max_coverage` and plot the results.
"""
function plot_greedy_max_coverage(iter_objective,iter_coverage)
    p1 = plot(0:25,iter_objective,
        title=L"$F(S_{i-1} \cup \{k_i\}) - F(S_{i-1})$",
        ylabel="Greedy Objective")
    p2 = plot(0:25,iter_coverage,
        title=L"$F(S_i) = \sum_{e} w_e 1[e \in \bigcup_{i \in S_i} C_i]$",
        ylabel="Weighted Coverage"
    )
    p = plot(p1,p2,legend=false,xlabel=L"Sensor Strategy size $|S_i|$")
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

