using Plots
using CairoMakie
using Random
using Distributions

Random.seed!(1234)

#####################################################################
# CREATE A COMPLICATED f(x,y) THAT IS THE SUM OF 3 NORMAL           #
# DISTRIBUTIONS                                                     #
#####################################################################

μ1 = [0.0, 0.0]  # Means
Σ1 = [1.0 0.0; 0.0 1.0]  # Covariance matrix--off diagonal 0.0, directions uncorrelated.
mv1 = MvNormal(μ1, Σ1)

μ2 = [-2.0, 2.0]
Σ2 = [0.5 0.0; 0.0 0.5]
mv2 = MvNormal(μ2, Σ2)

μ3 = [2.0, 0.0]
Σ3 = [0.5 0.0; 0.0 0.5]
mv3 = MvNormal(μ3, Σ3)

# Compute the sum of PDFs
function complicated_pdf(x, y)
    pdf(mv1, [x, y]) + pdf(mv2, [x, y]) + pdf(mv3, [x, y])
end

#####################################################################
# CREATE A CONTOUR PLOT OF THE PDF                                  #
#####################################################################

# Create a grid of points for the x and y axes
xs = range(start=-4.0, stop=4.0, length=100)
ys = range(start=-3.0, stop=4.0, length=100)

# Compute the PDF values over the grid
zs = [complicated_pdf(x, y) for x in xs, y in ys]

fig = Figure(resolution = (750, 700))
ax = Axis(fig[1, 1], title="2D PDF for Sampling")
CairoMakie.xlims!(ax, minimum(xs), maximum(xs))
CairoMakie.ylims!(ax, minimum(ys), maximum(ys))
contour_plot = CairoMakie.contour!(ax, xs, ys, zs, levels=20, colormap=:viridis, linewidth = 3)
Colorbar(fig[1, 2], limits=(0, maximum(zs)), colormap=:viridis, flipaxis=false, size=25)
save("figure.png", fig)
