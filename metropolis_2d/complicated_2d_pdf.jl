using Plots
using CairoMakie
using Random
using Distributions

Random.seed!(1234)

μ1 = [0.0, 0.0]  # Means
Σ1 = [1.0 0.0; 0.0 1.0]  # Covariance matrix--off diagonal 0.0, directions uncorrelated.
mv1 = MvNormal(μ1, Σ1)

μ2 = [-1.0, 1.0]
Σ2 = [0.5 0.0; 0.0 0.5]
mv2 = MvNormal(μ2, Σ2)

μ3 = [0.0, 1.0]
Σ3 = [0.5 0.0; 0.0 0.5]
mv3 = MvNormal(μ3, Σ3)

# Compute the sum of PDFs
function complicated_pdf(x, y)
    pdf(mv1, [x, y]) + pdf(mv2, [x, y]) + pdf(mv3, [x, y])
end

# Create a grid of points for the x and y axes
xs = range(start=-3, stop=3, length=100)
ys = range(start=-3, stop=3, length=100)

# Compute the PDF values over the grid
zs = [complicated_pdf(x, y) for x in xs, y in ys]

fig = Figure(resolution = (750, 700))
ax = Axis(fig[1, 1])
contour_plot = CairoMakie.contour!(ax, xs, ys, zs, levels=20, colormap=:viridis, linewidth = 3)
Colorbar(fig[1, 2], limits=(0, maximum(zs)), colormap=:viridis, flipaxis=false, size=50)
save("figure.pdf", fig, pdf_version="1.4")
