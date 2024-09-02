using Plots
using Printf

substrate_concentrations = collect(range(start=0, stop=0.1, length=100))

function mm_curve(vmax, km)
    function mm(substrate_concentration)
        vmax * substrate_concentration / (km + substrate_concentration)
    end

    mm.(substrate_concentrations)
end

vmax = 2.0e-3
kms = range(start=1.0e-3, stop=1.0e-2, length=150)

anim = Animation()

for (index, km) in enumerate(kms)
    ys = mm_curve(vmax, km)

    xtick_vals = range(start=0, stop=maximum(substrate_concentrations), length=5)
    xtick_labels = [@sprintf("%.1e", val) for val in xtick_vals]

    ytick_vals = collect(range(start=0, stop=vmax, length=5))
    ytick_labels = [@sprintf("%.1e", val) for val in ytick_vals]

    km_formatted = @sprintf("%.3e", km)
    label = "Km=$km_formatted"

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
        linewidth=3,
        legend=:right
    )

    frame(anim)

    if index % 10 == 0
        println("Frame $index rendered...")
    end
end

mp4(anim, "mm_km_sweep.mp4", fps=30)

println("Done!")
