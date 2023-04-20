include("../src/SensorPlacement.jl")
import .SensorPlacement as SP
using PowerModels,Plots,GraphRecipes,Graphs,LinearAlgebra,Random,FileIO,JLD2

# Load the case
path = "test/data/networks/RTS_GMLC_risk.m"
net = SP.make_basic_network(SP.parse_file(path))

# Load the 2021 wildfire risks
risks = load("test/data/risks/risks_RTS_2021.jld2")["2021"]
T = length(risks) ÷ 5

# Build the coverage matrix and weights
F,W = SP.build_coverage_data(net,risks)

b_values = 1:40

# Solutions of greedy algorithm at each time step
greedy_strategy_T = [] #strategies as a function of b for each time step
greedy_objective_T = [] #objective values as a function of b for each time step
greedy_coverage_T = [] #coverage values as a function of b for each time step

# Solutions of IP algorithm at each time step
ip_strategy_T = [] #strategies as a function of b for each time step
ip_objective_T = [] #objective values as a function of b for each time step
ip_coverage_T = [] #coverage values as a function of b for each time step



for t=1:T
    w = W[:,t]
    #-------------------- Greedy
    #solve the greedy algorithm for the maximum value of b in b_values at the current time step
    greedy_iter_objective_t,greedy_iter_coverage_t,greedy_S_t = SP.greedy_max_coverage(F,w,b_values[end])
    # save the greedy results
    push!(greedy_strategy_T,greedy_S_t)
    push!(greedy_objective_T,greedy_iter_objective_t)
    push!(greedy_coverage_T,greedy_iter_coverage_t)

    #-------------------- IP
    #solve the IP algorithm for all values of b in b_values at the current time step
    ip_strategy_t,ip_iter_objective_t = SP.ip_max_coverage(F,w,b_values)
    #compute the IP coverage at the current time step
    ip_iter_coverage_t = []
    for x in ip_strategy_t
        S_t = Set()
        for (i,s) in enumerate(x)
            if s == 1
                push!(S_t,i)
            end
        end
        push!(ip_iter_coverage_t,SP.coverage(S_t,F,w))
    end
    #save the IP results
    push!(ip_strategy_T,ip_strategy_t)
    push!(ip_objective_T,ip_iter_objective_t)
    push!(ip_coverage_T,ip_iter_coverage_t)
end

#----- Plot the greedy coverage and convergence
t_select = 10
plot(1:40,greedy_coverage_T[t_select][2:end],xlabel="Strategy size b",ylabel="Weighted coverage",title="Risk coverage vs. total chargers at time t = "*string(t_select))
savefig("test/figures/ip/greedy_coverage.pdf")


#----- Plot the greedy coverage
t_select = 10
plot(1:40,greedy_objective_T[t_select][2:end],xlabel="Strategy size b",ylabel="Greedy objective",title="Objective value vs. total chargers at time t = "*string(t_select))
savefig("test/figures/ip/greedy_objective.pdf")


# ------ Plot the OBJECTIVE of the greedy and IP results vs b
t_select = 10
plot(b_values,greedy_objective_T[t_select][2:end],label="Greedy",xlabel="b",ylabel="Objective",title="Objective vs b at time t = "*string(t_select))
plot!(b_values,ip_objective_T[t_select],label="IP")
savefig("test/figures/ip/greedy_vs_ip_objective.pdf")


# ------ Plot the COVERAGE of the greedy and IP results vs b
t_select = 10
plot(b_values,greedy_coverage_T[t_select][2:end],label="Greedy",xlabel="b",ylabel="Coverage",title="Coverage vs b at time t = "*string(t_select))
plot!(b_values,ip_coverage_T[t_select],label="IP")
savefig("test/figures/ip/greedy_vs_ip_coverage.pdf")

# plot the results in time


# # # Plot the results vs time
# time_plot = SP.plot_max_coverage(results_T)
# savefig(time_plot,"test/figures/ip/base_weighted_RTS_ip_max_coverage_time.pdf")