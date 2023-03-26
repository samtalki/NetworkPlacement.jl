module SensorPlacement


using PowerModels
using Graphs
using JuMP
using Gurobi
using Plots
using HiGHS
using SparseArrays
using LinearAlgebra
using Random
using FileIO
using JLD2

include("structs.jl")
include("coverage.jl")
include("greedy.jl")
include("ip.jl")
include("vis.jl")
greet() = print("Hello World!")

end # module SensorPlacement
