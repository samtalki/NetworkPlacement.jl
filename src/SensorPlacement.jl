module SensorPlacement
using JuMP
using Gurobi
using Plots
using HiGHS
using SparseArrays
using LinearAlgebra
using Random
using FileIO
using JLD2

include("greedy.jl")
include("ip.jl")
include("build.jl")
greet() = print("Hello World!")

end # module SensorPlacement
