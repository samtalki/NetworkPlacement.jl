include("../src/SensorPlacement.jl")
import .SensorPlacement as SP
using PowerModels,Plots,GraphRecipes,Graphs,LinearAlgebra,Random,FileIO,JLD2

# # Load the case
path = "data/networks/RTS_GMLC_risk.m"
net = make_basic_network(parse_file(path))

# # Load the 2021 wildfire risks
risks = load("data/risks/RTS_2021.jld2")["2021"]
T = length(risks)

# # Build the coverage matrix and weights
F,W = SP.build_coverage_data(net,risks)

# # Solve the greedy algorithm at each time step
b_values = [5,10,25]
results_T = [] #results as a function of time
for (t,w) in enumerate(W)
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

# # Plot the results