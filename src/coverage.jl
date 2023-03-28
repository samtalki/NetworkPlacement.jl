"""
Builds the coverage matrix and criticality weights given a PowerModels case dictionary and a dictionary of weights
"""
function build_coverage_data(case_dict::Dict,weights::Dict{Int,Float64})
    @assert haskey(case_dict,"basic_network") "Requires basic network format"
    F = calc_basic_incidence_matrix(case_dict) #Calculate the basic incidence matrix
    (N_E,N_V) = size(A)
    w = zeros(N_E) #Criticality weights
    power_risks = get_power_risks(case_dict) #Get the power_risks for each branch
    @assert length(power_risks) == N_E "Number of power_risks inconsistent with number of branches"
    for (branch_id,weight) in weights
        w[branch_id] = weight*power_risks[branch_id] #Set criticality weight
    end
    return F,w #return coverage matrix and weights
end

"""
Given a vector of weights corresponding to time, returns the coverage matrix and a vector of criticality weights
"""
function build_coverage_data(case_dict::Dict,weights_vector::Vector{Any})
    @assert haskey(case_dict,"basic_network") "Requires basic network format"
    F = calc_basic_incidence_matrix(case_dict) #Calculate the basic incidence matrix
    (N_E,N_V) = size(F)
    W = zeros(N_E,length(weights_vector)) #Criticality weights as a function of time
    power_risks = get_power_risks(case_dict) #Get the power_risks for each branch
    for (t,weights) in enumerate(weights_vector)
        w = zeros(length(weights))
        for (branch_id,weight) in weights
            w[branch_id] = weight*power_risks[branch_id] #Set criticality weight
        end
        W[:,t] = w
    end
    return F,W #return coverage matrix and matrix of weights as a function of time, W ∈ ℝ^(N_E x T)
end


"""
Gets the baseline power_risks for each branch in the graph
"""
function get_power_risks(case_dict::Dict)
    n_branch = length(case_dict["branch"]) #Number of branches
    power_risks = Dict() #Initialize the power_risks
    for (branch_id_label,branch) in case_dict["branch"] #For each branch
        branch_id = branch["index"] #Get the branch_id
        power_risks[branch_id] = branch["power_risk"] #Set the power_risk
    end
    return power_risks
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

