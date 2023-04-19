"""
Solve the maximum coverage integer program given cardinality constraint b

Parameters:
- `b`: Cardinality constraint
- `F`: Coverage/detection matrix
- `w`: Weight vector
"""
function ip_max_coverage(b::Integer,F::AbstractMatrix,w::AbstractArray)
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
Solve the maximum coverage problem for every cardinality constraint from 1 to `b_max`.

Parameters:
- `b_max`: Maximum cardinality constraint
- `F`: Coverage/detection matrix
- `w`: Weight vector
"""
function solve_ip_max_coverage(b_max::Integer,F::AbstractMatrix,w::AbstractArray)
	iter_obj,iter_z = [],[]
	for b in 1:b_max
		x_b,obj_b = ip_max_coverage(b,F,w)
		push!(iter_obj,obj_b)
		push!(iter_z,z_b)
	end
	return iter_obj,iter_z
end

"""
Solve the min-max vulnerability problem given a cardinality constraint b
"""
function ip_min_max_vulnerability(b::Integer,F::AbstractMatrix,w::AbstractArray)
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


function ip_min_max_vulnerability(b_max::Int,F::AbstractMatrix,w::AbstractArray)
	F_values,strategies = [],[] 
	for b in 1:b_max 
		x_b,obj_b = ip_min_max_vulnerability(b,F,w)
		push!(strategies,x_b)
		push!(F_values,obj_b)
	end
	return F_values
end