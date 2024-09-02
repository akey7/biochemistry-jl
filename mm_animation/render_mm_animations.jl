using Plots
using Printf

substrate_concentrations = collect(range(start=0, stop=3e-2, length=100))

function mm_curve(vmax, km)
    function mm(substrate_concentration)
        vmax * substrate_concentration / (km + substrate_concentration)
    end

    mm.(substrate_concentrations)
end

vmax = 1.0e-3
km = 1.0e-3  # Go up to 4e-3
ys = mm_curve(vmax, km)

xtick_vals = range(start=0, stop=maximum(substrate_concentrations), length=5)
xtick_labels = [@sprintf("%.3e", val) for val in xtick_vals]

ytick_vals = collect(range(start=0, stop=vmax, length=5))
ytick_labels = [@sprintf("%.3e", val) for val in ytick_vals]

label = "Km=$km"

plot(
    substrate_concentrations, 
    ys, 
    label=label, 
    xlims=(0.0, maximum(substrate_concentrations) * 1.1),
    ylims=(0.0, vmax * 1.01),
    xlabel="[S] (M)", 
    ylabel="d[P]/dt (M/min)", 
    xticks=(xtick_vals, xtick_labels), 
    yticks=(ytick_vals, ytick_labels), 
    linewidth=3
)

savefig("single_curve.png")
