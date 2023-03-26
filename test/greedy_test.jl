include("../src/SensorPlacement.jl")
import .SensorPlacement as SP
using PowerModels,Plots,GraphRecipes,Graphs,LinearAlgebra,Random,FileIO,JLD2

# # Load the case
path = "test/data/networks/RTS_GMLC_risk.m"
net = make_basic_network(parse_file(path))

# # Load the 2021 wildfire risks
risks = load("test/data/risks/risks_RTS_2021.jld2")["2021"]
T = length(risks)

# # Build the coverage matrix and weights
F,W = SP.build_coverage_data(net,risks)

# # Solve the greedy algorithm at each time step
b_values = [5,10,25,40]
results_T = [] #results as a function of time
for (t,w) in enumerate(eachcol(W))
    results = Dict{Int,Dict{String,Any}}()
    for b in b_values
        iter_objective,iter_coverage,S = SP.greedy_max_coverage(F,w,b)
        results[b] = Dict(
            "iter_objective" => iter_objective,
            "iter_coverage" => iter_coverage,
            "S" => S
        )
    end
    push!(results_T,results)
end

# # Plot the results vs strategy size
t_select = 10 #random time to select risk value
for b in b_values
    _iter_objective,_iter_coverage = results_T[t_select][b]["iter_objective"],results_T[t_select][b]["iter_coverage"]
    size_plot = SP.plot_greedy_max_coverage(_iter_objective,_iter_coverage)
    savefig(size_plot,"test/figures/RTS_greedy_max_coverage_b"*string(b)*"_t_"*string(t_select)*".pdf")
end

# # Plot the results vs time
time_plot = SP.plot_greedy_max_coverage(results_T)
savefig(time_plot,"test/figures/RTS_greedy_max_coverage_time.pdf")