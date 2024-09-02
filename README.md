# biochemistry-jl
Biochemistry simulations in Julia.

## Setup

### Jupyter Notebooks for Quarto and Julia Jupyter Support

First, create a virtual environment for **Python** and install Jupyter Lab in it. This is required for Quarto builds of Julia. Run these commands from the root of the repo:

```
conda create --prefix env python=3.11
conda activate ./env
conda install jupyterlab
```

[See this page for additional guidance.](https://quarto.org/docs/projects/virtual-environments.html)

### The Julia Kernel for Jupyter

This only needs to be done once per machine per Julia version. This might need to be changed slightly for each Julia upgrade.

To run this part of the setup, the Python environment above should be activated so that Jupyter can install an additional kernel.

[First install IJulia according to these instructions.](https://julialang.github.io/IJulia.jl/stable/manual/installation/). In brief, the relevant commands are:

```
julia
using Pkg
Pkg.add("IJulia")
using IJulia
installkernel("Julia nodeps", "--depwarn=no")
installkernel("Julia", "--project=@.")
```

### Quarto installation

[This only needs to be done once per machine for each upgrade of Quarto.](https://quarto.org/docs/get-started/)

### FINALLY! Check the Quarto installation

```
quarto check jupyter
```

If everything comes back good, you are ready!

## Demos and How to Run Them

### Michaelis-Menten Kinetics

```
cd mm
```
