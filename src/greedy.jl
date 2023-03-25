"""
Given:
	
	- S: A sensor placement strategy that contains the nodes that have sensors
	- F: a |E| x |V| dimensional detection matrix such that f_{e,v} = 1 if a sensor placed at node v can detect a burst for pipe e, and 0 otherwise,
	- w: an |E| dimensional vector of criticality weights

Returns: the coverage of the strategy S
"""
function coverage(S::Set;F=F,w=w)
	N_E,N_V = size(F) #Detection matrix dimension (num_edges,num_nodes)
	coverage = 0
	for e in 1:N_E #for each sensor
		covered = false
		for v in S
			if F[e,v] == 1
				covered = true
			end
		end
		if covered
			coverage += w[e]
		end
	end
	return coverage
end


"""
Given a cardinality constraint `b`, and detection matrix `F`, find the greedy sensor submodular maximization solution that finds the 1 - 1/e approximate best sensor placement strategy.
"""
function greedy_max_coverage(b::Integer;F=F)
	(N_E,N_V) = size(F) #Detection matrix dimension (num_edges,num_nodes)
	iter_objective = [0.0] #Vector to track objective values
	iter_coverage = [0.0] #Vector to track coverage values
	S = Set() #Set of indeces to select
	for i in 1:b #For i=1,..,b where |S| <= b
		k_i = Set() #Initial guess for the maximizing index
		objective = coverage(union(S,k_i)) - coverage(S) #Initialize the objective
		for j in 1:N_V #for each node index j
            objective_j = coverage(union(S,j)) - coverage(S) #calc objective for node j
            if objective_j > objective #If the objective at j is larger
                objective = objective_j #Update the current best objective
                k_i = j #Update the current maximizing index
            end
		end
		push!(iter_objective,objective) #Save the objective at this iteration
		push!(iter_coverage,coverage(S)) #Save the coverage at this iteration
		S = union(S,k_i) #Unionize the maximizing index with the current set
	end
	return iter_objective,iter_coverage,S
end


"""
Given cardinality constraint `b` solve `greedy_max_coverage` and plot the results.
"""
function plot_greedy_max_coverage(b)
    iter_objective,iter_coverage,S_best = greedy_max_coverage(b)
    plot(iter_objective,
        label=L"$F(S_{i-1} \cup \{k_i\}) - F(S_{i-1})$ (Objective)")
    plot(iter_coverage,label=L"$F(S_i)$ (Weighted Coverage)")
    xlabel!("Sensor placement strategy size")
    ylabel!("Weighted Coverage")
end

"""
Given cardinality constraint `b` solve `greedy_max_coverage` and plot the results.
"""
function plot_greedy_max_coverage(iter_objective,iter_coverage)
    p1 = plot(0:25,iter_objective,
        title=L"$F(S_{i-1} \cup \{k_i\}) - F(S_{i-1})$",
        ylabel="Greedy Objective")
    p2 = plot(0:25,iter_coverage,
        title=L"$F(S_i) = \sum_{e} w_e 1[e \in \bigcup_{i \in S_i} C_i]$",
        ylabel="Weighted Coverage"
    )
    plot(p1,p2,legend=false,xlabel=L"Sensor Strategy size $|S_i|$")
end