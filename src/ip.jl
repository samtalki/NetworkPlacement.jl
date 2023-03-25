function ip_max_coverage(b::Integer;F=F,w=w)
	(N_E,N_V) = size(F) #Detection matrix dimension (num_edges,num_nodes)
	coverage = Model(HiGHS.Optimizer)
	@variable(coverage,z[1:N_V],Bin)
	@constraint(coverage,sum(z)<=b)
	@objective(coverage,Max,(transpose(w)*F*z)/norm(z))
	optimize!(coverage)
	return value.(z),objective_value(coverage)
end

function solve_ip_max_coverage(b_max=25)
	iter_obj,iter_z = [],[]
	for b in 1:b_max
		z_b,obj_b = ip_max_coverage(b)
		push!(iter_obj,obj_b)
		push!(iter_z,z_b)
	end
	return iter_obj,iter_z
end