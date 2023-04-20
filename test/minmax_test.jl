include("../src/SensorPlacement.jl")
import .SensorPlacement as SP
using PowerModels,Plots,GraphRecipes,Graphs,LinearAlgebra,Random,FileIO,JLD2
using LaTeXStrings

# # Load the case
path = "test/data/networks/RTS_GMLC_risk.m"
net = make_basic_network(parse_file(path))


# # Load the 2021 wildfire risks
risks = load("test/data/risks/risks_RTS_2021.jld2")["2021"]
T = length(risks) ÷ 5

# # Build the coverage matrix and weights
F,W = SP.build_coverage_data(net,risks)

# # Solve the greedy algorithm at each time step
b_values = 1:40
results_T = [] #results as a function of time

# Results
K_T,F_T,S_T = [],[],[]

for (t,w) in enumerate(eachcol(W))
    K_values,F_values,strategies = SP.ip_min_max_vulnerability(F,w,b_values)
    push!(K_T,K_values)
    push!(F_T,F_values)
    push!(S_T,strategies)
end


# # Plot the results vs strategy size
b_values = 1:40
t_select = 10 #random time to select risk value
plot(b_values,K_T[t_select],xlabel="b",ylabel="Maximum Criticality",label="Max criticality",title="Max Vulnerability at t = "*string(t_select))
vline!([19],label=L"Diminishing returns $b$ ≈ 30%",color="black",ls=:dash)
savefig("test/figures/minmax/criticality.pdf")

# # Plot the criticality results vs time
b_values = [1,5,10,25]

p = plot()
for b in b_values
    K_T_b = [k_t[b] for k_t in K_T] # select the maximum criticality at the maximum charger placement
    plot!(1:T,K_T_b,xlabel="time (t)",ylabel="Maximum Criticality",title="Min-Max Vulnerability vs. Time",label=L"$b = "*string(b)*L"$")
    
end
savefig("test/figures/minmax/criticality_v_time.pdf")



# # Plot the coverage results vs time
b_values = [1,5,10,25]

p = plot()
for b in b_values
    F_T_b = [f_t[b] for f_t in F_T] # select the maximum criticality at the maximum charger placement
    plot!(1:T,F_T_b,xlabel="time (t)",ylabel="Weighted coverage",title="Max-min Coverage vs. Time",label=L"$b = "*string(b)*L"$")
    
end
savefig("test/figures/minmax/coverage_v_time.pdf")


