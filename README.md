# NetworkPlacement.jl

This package implements some classic network placement algorithms that can be used for tasks that involve placing a finite amount of resources in a network/graph according to some objective.

Some examples of this task includes:

- Optimally placing sensors 
- Optimally placing EV chargers
- Optimally placing electric generators

## Urban Computing Project background
### Project name:
Electric power network charger placement for extreme event resilience via submodular optimization

### Contributors:
- Samuel Talkington
- Utkarsh Nattamai Subramanian Rajkumar
- Hassan Naveed

### PDFs of report and presentation:
These documents are located in the `docs` directory.

## Setup and Installation

This package is a propotype for the course CSE 8803: Urban Computing at the Georgia Institute of Technology. This package is not yet registered in the Julia package registry. To install it, you can clone this repository and then activate the package in the Julia REPL.

While in the package directory, run the following commands in the REPL:
```julia 
julia> ] activate .
julia> ] instantiate
```

## Usage

### Implemented algorithms
The package is currently under development. The following algorithms are implemented:

- [x] Greedy
- [x] Integer programming (IP)
- [x] Min-max criticality

### Reproducing Urban Computing project results
The results presented in the project report can be reproduced by running the following commands in the REPL:


#### Network risk graph
```julia
julia> ] activate .
julia> include("tests/network_plot.jl")
```

#### Greedy algorithm test suite
```julia
julia> ] activate .
julia> include("tests/greedy_test.jl")
```

#### Minimax criticality IP algorithm test suite
```julia
julia> ] activate .
julia> include("tests/minimax_test.jl")
```

#### IP algorithm test suite
```julia
julia> ] activate .
julia> include("tests/ip_test.jl")
``` 

## Contributing

### Needed future work:
The following algorithms need to be implemented:

- [ ] Greedy with local search
- [ ] Mixed strategy (random + greedy)
- [ ] Mixed strategy (random + IP)

### Contribution recommendations:
Contributions are welcome! Please open an issue or a pull request if you have any suggestions or if you find any bugs.


# Acknowledgements
This material is based upon work supported by the National Science Foundation Graduate Research Fellowship Program under Grant No. DGE-1650044. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.