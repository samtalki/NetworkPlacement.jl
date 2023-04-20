# NetworkPlacement.jl

This package implements some classic network placement algorithms that can be used for tasks that involve placing a finite amount of resources in a network/graph according to some objective.

Some examples of this task includes:

- Optimally placing sensors 
- Optimally placing EV chargers
- Optimally placing electric generators


## Setup and Installation

This package is not yet registered in the Julia package registry. To install it, you can clone this repository and then activate the package in the Julia REPL.

While in the package directory, run the following commands in the REPL:
```julia 
julia> ] activate .
julia> ] instantiate
```

## Usage

The package is currently under development. The following algorithms are implemented:

- [x] Greedy
- [x] Integer programming (IP)
- [x] Min-max criticality


## Contributing

### Needed future work:
The following algorithms need to be implemented:

- [ ] Greedy with local search
- [ ] Mixed strategy (random + greedy)
- [ ] Mixed strategy (random + IP)

### Contribution recommendations:
Contributions are welcome! Please open an issue or a pull request if you have any suggestions or if you find any bugs.

