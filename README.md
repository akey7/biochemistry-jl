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

## Michaelis-Menten kinetics

### Still plot on an HTML report

```
conda activate ./env
cd mm_basic
quarto render mm_basic_kinetics.qmd
```

After quarto finishes, open `mm_basic_kinetics.html` in a browser.

### Animated K<sub>M</sub> and V<sub>max</sub> plot for video creation

```
cd mm_animation
julia render_mm_km_animation.jl
```

Then open the `mm_km_animation.mp4` and `mm_vmax_animation.mp4` files in that folder.

## Linear pathway from Voit et al.

### Overview of simulation

This system comes from the paper by Voit et al found at:

> Voit, E., Neves, A. R. & Santos, H. The intricate side of systems biology. Proc. Natl. Acad. Sci. U.S.A. 103, 9452–9457 (2006).

The metabolic pathway is a simplified glycolytic pathway, as shown in Figure 4 of the paper. The description is "Generic linear feedforward activated pathway in which a downstream metabolite (X4) is needed as a second substrate for the first step."

![Image of biochemical pathway](images/voit_et_al_fig_04.png "Voit et al Fig. 4")

The differential equations that model this system are given in Equation 1 of the paper, as shown below:

![Image of differential equations](images/voit_et_al_eqn_01.png "Voit et al Eqn 1")

The variables X<sub>n</sub> correspond to the following metabolites:

| Variable | Metabolite |
| -------- | ---------- |
| X1       | G6P        |
| X2       | FBP        |
| X3       | 3-PGA      |
| X4       | PEP        |
| X5       | Pyruvate   |

Input1 is a small steady stream of glucose, while Input2 is stream of glucose of concentration over time.

### How to run and plot simulation

To run a simulation to reproduce Figure 5 of Voit et al. and create an animation based on that figure, run these commands:

```
cd linear_pathway_animation
julia render_lineary_pathway_animation.jl
```

Then image and movie files will be rendered to that folder.

## Hill Equation

The Hill equaiton models cooperativitiy in binding of ligands to a protein. There are 3 types of cooperativity:

1. Non-cooperativity: Where binding of a ligand does not affect the binding of subsequent lignads.
2. Negative cooperativity: Where binding of one ligand lowers affinity for subsequent ligands.
3. Positive cooperativity: Where binding of one ligand increases affinity for subsequent ligands.

The animation from this script walks through each of these types of cooperativity.
