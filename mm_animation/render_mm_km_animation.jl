using Plots
using Printf

# The range of substrate concentrations to model
substrate_concentrations = collect(range(start=0, stop=0.1, length=100))

# Calculates the Michaelis-Menten curve given the substrate concentrations
# above and the given vmax, km

function mm_curve(vmax, km)
    function mm(substrate_concentration)
        vmax * substrate_concentration / (km + substrate_concentration)
    end

    mm.(substrate_concentrations)
end

# vmax and km range for curves
vmax = 2.0e-3
start_km = 1.0e-3
stop_km = 1.0e-2
kms = range(start=start_km, stop=stop_km, length=150)

# Create an animation object
anim = Animation()

# Iterate over every km in the sequence, hold vmax constant, and
# render a frame for each km. Format floats to appropriate number
# of decimal places. Give status update every 10 frames.

for (index, km) in enumerate(kms)
    ys = mm_curve(vmax, km)

    xtick_vals = range(start=0, stop=maximum(substrate_concentrations), length=5)
    xtick_labels = [@sprintf("%.1e", val) for val in xtick_vals]

    ytick_vals = collect(range(start=0, stop=vmax, length=5))
    ytick_labels = [@sprintf("%.1e", val) for val in ytick_vals]

    vmax_formatted = @sprintf("%.2e", vmax)
    km_formatted = @sprintf("%.2e", km)
    title = "Vmax=$vmax_formatted"

    annotation_x = km + maximum(substrate_concentrations) * 0.175
    annotation_y = 0.95 * vmax

    plot(
        substrate_concentrations, 
        ys, 
        title=title,
        xlims=(0.0, maximum(substrate_concentrations) * 1.1),
        ylims=(0.0, vmax * 1.01),
        xlabel="[S] (M)", 
        ylabel="d[P]/dt (M/min)", 
        xticks=(xtick_vals, xtick_labels), 
        yticks=(ytick_vals, ytick_labels), 
        linewidth=3,
        legend=:none
    )

    vline!([km], label="Km", linecolor=:orange, linestyle=:dot, linewidth=3)
    annotate!(annotation_x, annotation_y, text("Km=$km_formatted", :orange, 12))

    frame(anim)

    if index % 10 == 0
        println("Frame $index rendered...")
    end
end

# Write the animation to a file
mp4(anim, "mm_km_animation.mp4", fps=30)

# Give the final status update
println("Done!")
