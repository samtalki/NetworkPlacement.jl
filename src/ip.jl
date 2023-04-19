"""
Solve the maximum coverage integer program given cardinality constraint b

Parameters:
- `F`: Coverage/detection matrix
- `w`: Weight vector
- `b`: Cardinality constraint
"""
function ip_max_coverage(F::AbstractMatrix,w::AbstractArray,b::Integer)
	(N_E,N_V) = size(F) # Coverage/detection matrix dimension (num_edges,num_nodes)
	model = Model(HiGHS.Optimizer) #Create a new model
	@variable(model,c[1:N_E],Bin) #Create a binary variabe for the coverage vector
	@variable(model,x[1:N_V],Bin) #Create a binary vairable for the placement vector
	@objective(model,Max,sum([w_e*c_e for (w_e,c_e) in zip(w,c)])) #Maximize the weighted sum of the coverage vector
	@constraint(model,sum(x) <= b) #Cardinality constraint
	@constraint(model,c .<= F*x) #Coverage constraint (F*x is the detection vector)
	optimize!(model) #Solve the model
	return value.(x),objective_value(model) #Return the solution and objective value
end


"""
Solve the maximum coverage integer program for a range of cardinality constraints
"""
function ip_max_coverage(F::AbstractMatrix,w::AbstractArray,b_range::AbstractArray)
	iter_strategy,iter_objective = [],[] #Vectors to track the strategy and objective value
	for b in b_range #For each cardinality constraint
		x,iter_objective = solve_ip_max_coverage(F,w,b) #Solve the IP for this cardinality constraint
		push!(iter_strategy,x) #Save the strategy
		push!(iter_objective,iter_objective) #Save the objective value
	end
	return iter_strategy,iter_objective #Return the iterations of the strategy and objective value
end

"""
Solve the min-max vulnerability problem given a cardinality constraint b
Parameters:
- `F`: Coverage/detection matrix
- `w`: Weight vector
- `b`: Cardinality constraint
"""
function ip_min_max_vulnerability(F::AbstractMatrix,w::AbstractArray,b::Integer)
	(N_E,N_V) = size(F) # Coverage/detection matrix dimension (num_edges,num_nodes)
	model = Model(HiGHS.Optimizer) #Create a new model
	
	# --- Define the variables
	@variable(model,K) #A slack variable for the maximum vulnerability
	@variable(model,c[1:N_E],Bin) #Create a binary variabe for the coverage vector
	@variable(model,x[1:N_V],Bin) #Create a binary vairable for the placement vector
	
	# --- Define the constraints
	@constraint(model,sum(x) <= b) #Cardinality constraint
	@constraint(model,c .<= F*x) #Coverage constraint (F*x is the detection vector)
	for e in 1:N_E
		@constraint(model, w[e]*(1-c[e]) <= K) # the vulnerability of edge e is at most K
	end
	
	#--- Minimize the maximum vulnerability
	@objective(model,Min,K)

	#--- Minimize the maximum vulnerability
	optimize!(model) #Solve the model
	return value.(x),objective_value(model) #Return the solution and objective value
end

"""
Solve the min-max vulnerability problem for a range of cardinality constraints b_range
Parameters:
- `F`: Coverage/detection matrix
- `w`: Weight vector
- `b_range`: Range of cardinality constraints to solve the minimax problem
"""
function ip_min_max_vulnerability(F::AbstractMatrix,w::AbstractArray,b_range::AbstractArray)
	F_values,strategies = [],[] 
	for b in b_range 
		x_b,obj_b = ip_min_max_vulnerability(F,w,b)
		push!(strategies,x_b)
		push!(F_values,obj_b)
	end
	return F_values
end