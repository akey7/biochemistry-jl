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

# Renders a single frame with appropriate annotations
function render_frame(anim, vmax, km, max_vmax, annotate_km_or_vmax)
    ys = mm_curve(vmax, km)

    xtick_vals = range(start=0, stop=maximum(substrate_concentrations), length=5)
    xtick_labels = [@sprintf("%.1e", val) for val in xtick_vals]

    ytick_vals = collect(range(start=0, stop=max_vmax, length=5))
    ytick_labels = [@sprintf("%.1e", val) for val in ytick_vals]

    vmax_formatted = @sprintf("%.2e", vmax)
    km_formatted = @sprintf("%.2e", km)

    function vmax_or_km_title()
        if annotate_km_or_vmax == :km
            "Vmax=$vmax_formatted"
        elseif annotate_km_or_vmax == :vmax
            "Km=$km_formatted"
        else
            ""
        end
    end

    plot(
        substrate_concentrations, 
        ys, 
        title=vmax_or_km_title(),
        xlims=(0.0, maximum(substrate_concentrations) * 1.1),
        ylims=(0.0, max_vmax * 1.01),
        xlabel="[S] (M)", 
        ylabel="v (M/min)", 
        xticks=(xtick_vals, xtick_labels), 
        yticks=(ytick_vals, ytick_labels), 
        linewidth=3,
        legend=:none
    )

    if annotate_km_or_vmax == :km
        annotation_x = km + maximum(substrate_concentrations) * 0.175
        annotation_y = 0.95 * vmax
        vline!([km], label="Km", linecolor=:orange, linestyle=:dot, linewidth=3)
        annotate!(annotation_x, annotation_y, text("Km=$km_formatted", :orange, 12))
    elseif annotate_km_or_vmax == :vmax
        annotation_x = maximum(substrate_concentrations) * 0.2
        annotation_y = vmax - 0.05 * max_vmax
        hline!([vmax], label="Vmax", linecolor=:orange, linestyle=:dot, linewidth=3)
        annotate!(annotation_x, annotation_y, text("Vmax=$vmax_formatted", :orange, 12))
    end

    frame(anim)
end

# Creates the Km animation by holding Vmax constant and animating Km
function render_km_animation()
    vmax = 2.0e-3
    start_km = 1.0e-2
    stop_km = 1.0e-3
    kms = range(start=start_km, stop=stop_km, length=150)

    anim = Animation()

    for (index, km) in enumerate(kms)
        render_frame(anim, vmax, km, vmax, :km)

        if index % 10 == 0
            println("Km animation, frame $index rendered...")
        end
    end

    mp4(anim, "mm_km_animation.mp4", fps=30)

    println("Km animation finished!")
end

# Creates the Km animation by holding Vmax constant and animating Km
function render_vmax_animation()
    km = 5.0e-3
    start_vmax = 1.0e-3
    stop_vmax = 3.0e-3
    vmaxs = range(start=start_vmax, stop=stop_vmax, length=150)

    anim = Animation()

    for (index, vmax) in enumerate(vmaxs)
        render_frame(anim, vmax, km, stop_vmax, :vmax)

        if index % 10 == 0
            println("Vmax animation, frame $index rendered...")
        end
    end

    mp4(anim, "mm_vmax_animation.mp4", fps=30)

    println("Vmax animation finished!")
end

# Render the animations
render_km_animation()
render_vmax_animation()
