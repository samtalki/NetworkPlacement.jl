"""
Builds the coverage matrix and criticality weights given a PowerModels case dictionary and a dictionary of weights
"""
function build_coverage_data(case_dict::Dict,weights::Dict{Int,Float64})
    @assert haskey(case_dict,"basic_network") "Requires basic network format"
    F = calc_basic_incidence_matrix(case_dict) #Calculate the basic incidence matrix
    (N_E,N_V) = size(A)
    w = zeros(N_E) #Criticality weights
    for (bus_id,weight) in weights
        w[bus_id] = weight
    end
    return F,w #return coverage matrix and weights
end

"""
Given a vector of weights corresponding to time, returns the coverage matrix and a vector of criticality weights
"""
function build_coverage_data(case_dict::Dict,weights_vector::Vector{Dict{Int,Float64}})
    @assert haskey(case_dict,"basic_network") "Requires basic network format"
    F = calc_basic_incidence_matrix(case_dict) #Calculate the basic incidence matrix
    (N_E,N_V) = size(A)
    W = zeros(length(weights[1]),length(weights)) #Criticality weights as a function of time
    for (t,weights) in enumerate(weights_vector)
        w = zeros(length(weights))
        for (bus_id,weight) in weights
            w[bus_id] = weight
        end
        W[:,t] = w
    end
    return F,W #return coverage matrix and matrix of weights as a function of time, W ∈ ℝ^(N_E x T)
end


"""
Gets each of the zones for each bus/node/vertex in the graph
"""
function get_bus_zones(case_dict::Dict)
    n_bus = length(case_dict["bus"]) #Number of buses
    zones = zeros(Int,n_bus) #Initialize the zones
    for (bus_id,bus) in case_dict["bus"] #For each bus
        zones[bus_id] = bus["zone"] #Set the zone
    end
    return zones
end

