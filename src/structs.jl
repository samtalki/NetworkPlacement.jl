mutable struct PowerNetworkGraph{T<:SimpleGraph}
    G::T
    N_V::Int
    N_E::Int
    bus_id_to_vertex_id::Dict
    branch_id_to_edge_id::Dict
    case_dict::Dict{String,Any}
end

mutable struct WeightedPowerNetworkGraph{T<:PowerNetworkGraph}
    G::T
    F::Union{Matrix{Int},SparseMatrixCSC{Int,Int}}
    w::Vector{Float64}
end


"""
Builds a power network graph given a PowerModels case dictionary
"""
function build_power_network_graph(case_dict::Dict)
    @assert haskey(case_dict,"basic_network") "Requires basic network format"
    A = calc_basic_incidence_matrix(case_dict) #Calculate the basic incidence matrix
    (N_E,N_V) = size(A) #Detection matrix dimension (num_edges,num_nodes)
    n_branch,n_bus = length(case_dict["branch"]),length(case_dict["bus"]) #Number of buses and branches
    @assert n_branch == N_E && n_bus==N_V "Dimensions of models inconsistent"

    G = SimpleGraph(n_bus,n_branch) #Initialize the graph
    bus_id_to_vertex_id = Dict{String,Int}() #Map from bus_id to vertex_id
    for (vertex_id,(bus_id,bus)) in enumerate(case_dict["bus"]) #For each bus
        add_vertex!(G) #Add the bus to the graph
        bus_id_to_vertex_id[bus_id] = vertex_id #Add the bus_id to the map
    end
    branch_id_to_edge_id = Dict{String,Int}() #Map from branch_id to edge_id
    for (edge_id,(branch_id,branch)) in enumerate(case_dict["branch"]) #For each branch
        add_edge!(G,branch["f_bus"],branch["t_bus"]) #Add the branch to the graph
        branch_id_to_edge_id[branch_id] = edge_id #Add the branch_id to the map
    end
    N_V = nv(G) #Number of nodes
    N_E = ne(G) #Number of edges
    return PowerNetworkGraph(G,N_V,N_E,bus_id_to_vertex_id,branch_id_to_edge_id,case_dict)
end

"""
Build weighted power network graph
"""
function build_weighted_power_network_graph(case_dict::Dict,weights::Dict{Int,Float64})
    G = build_power_network_graph(case_dict) #Build the power network graph
    w = build_criticality_weights(G,weights) #Build the criticality matrices
    F = build_coverage_matrix(G,weights)
    return WeightedPowerNetworkGraph(G,F,w)
end



"""
Build criticality matrices for the given graph and weights
"""
function build_criticality_weights(G::PowerNetworkGraph,weights::Dict{Int,Float64})
    N_E = G.N_E #Number of edges
    w = zeros(N_E) #Criticality weights
    for (e,(u,v)) in enumerate(edges(G.G)) #For each edge
        w[e] = weights[G.branch_id_to_edge_id[e]] #Set criticality weight
    end
    return w
end

"""
Builds the coverage matrix for the given graph and weights
"""
function build_coverage_matrix(G::PowerNetworkGraph,weights::Dict{Int,Float64})
    N_E = G.N_E #Number of edges
    N_V = G.N_V #Number of vertices
    F = zeros(N_E,N_V) #Initialize the coverage matrix

    zones = get_bus_zones(G) #Get the zones for each bus
    
    for (e,(u,v)) in enumerate(edges(G.G)) #For each edge
        F[e,G.bus_id_to_vertex_id[u]] = 1 #Set the coverage matrix
        F[e,G.bus_id_to_vertex_id[v]] = 1 #Set the coverage matrix
    end
    return F
end


