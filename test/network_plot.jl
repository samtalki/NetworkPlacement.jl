using Plots,GraphRecipes,Graphs,LinearAlgebra,Random,FileIO,LaTeXStrings
using PowerModels
include("../src/SensorPlacement.jl")
import .SensorPlacement as SP


# Load the case
path = "test/data/networks/RTS_GMLC_risk.m"
net = make_basic_network(parse_file(path))
compute_ac_pf!(net) #compute the power flow

# plot the risk heatmap
riskmap = SP.plot_network(net) #plot the risk heatmap
savefig(riskmap,"test/figures/rts_heat_graph.pdf")