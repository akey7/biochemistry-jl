#####################################################################
# IMPORT MODULES                                                    #
#####################################################################

using Plots
using Plots.PlotMeasures
using Printf

#####################################################################
# SIZE OF ANIMATIONS AND FPS                                        #
#####################################################################

size_x = 1080
size_y = 1920 / 2
fps = 30

#####################################################################
# HILL EQUATION                                                     #
#####################################################################

function hill_eqn(kd, n, ligand_concentrations)
    function hill(ligand_concentration)
        ligand_concentration^n / (kd + ligand_concentration^n)
    end

    hill.(ligand_concentrations)
end

#####################################################################
# FUNCTION TO RENDER A SINGLE FRAME                                 #
#####################################################################

function render_frame(kd, n, ligand_concentrations)
    ys = hill_eqn(kd, n, ligand_concentrations)
    y_ref = hill_eqn(kd, 1.0, ligand_concentrations)
    kd_formatted = @sprintf("%.1e", kd)

    xtick_vals = range(
        start=minimum(ligand_concentrations),
        stop=maximum(ligand_concentrations),
        length=5
    )

    xtick_labels = [@sprintf("%.1e", val) for val in xtick_vals]

    # Y will always range from 0.0 to 1.0 in the Hill eqn
    ytick_vals = range(start=0.0, stop=1.0, length=5)
    ytick_labels = [@sprintf("%.2f", val) for val in ytick_vals]

    plot(
        ligand_concentrations,
        ys,
        label="n=$n",
        linecolor=RGB(57/255, 0, 153/255),
        titlefont=font(24),
        linewidth=5,
        xlims=(minimum(ligand_concentrations), maximum(ligand_concentrations) * 1.25),
        ylims=(0.0, 1.01),
        guidefont=font(20),
        xlabel="[L] (M)",
        xticks=(xtick_vals, xtick_labels),
        xtickfont=font(18),
        ylabel="Fraction of Receptor Sites Bound",
        yticks=(ytick_vals, ytick_labels),
        ytickfont=font(18),
        size=(size_x, size_y),
        margin=25px,
        legend=:none
    )

    annotate!(
        (0.875, maximum(ys)),
        text("n=$n", 20, RGB(57/255, 0, 153/255))
    )

    if n != 1.0
        plot!(
            ligand_concentrations, 
            y_ref,
            label="n=1.0",
            linecolor=RGB(255/255, 189/255, 0/255),
            linewidth=5
        )

        annotate!(
            (0.875, maximum(y_ref)),
            text("n=1.0", 20, RGB(255/255, 189/255, 0/255))
        )
    end

    vline!([kd], linecolor=RGB(255/255, 0/255, 84/255), linewidth=5)

    annotate!(
        (kd / maximum(ligand_concentrations) * 1.75, 0.975),
        text("Kd=$kd_formatted", 20, RGB(255/255, 0/255, 84/255))
    )
end

#####################################################################
# FUNCTION TO RENDER AND SAVE STILLS                                #
#####################################################################

function render_stills()
    ligand_concentrations = range(start=0.0, stop=2.0e-2, length=100)
    kd = 2.5e-3
    n_neg_cooperative = 0.9
    n_pos_cooperative = 1.1

    render_frame(kd, n_neg_cooperative, ligand_concentrations)
    savefig("Hill Negative Cooperativity.png")
    println("Rendered negative-cooperativity still")

    render_frame(kd, n_pos_cooperative, ligand_concentrations)
    savefig("Hill Positive Cooperativity.png")
    println("Rendered positive-cooperativity still")
end

#####################################################################
# FUNCTION TO RENDER AND SAVE HILL COEFFICIENT ANIMATIONS           #
#####################################################################

function render_hill_coeff_animations()
    num_frames = 10 * fps
    kd = 2.5e-3
    ligand_concentrations = range(start=0.0, stop=2.0e-2, length=100)
    neg_cooperative_ns = range(start=0.25, stop=1.0, length=num_frames)
    pos_cooperative_ns = range(start=1.0, stop=2.0, length=num_frames)

    anim_neg = Animation()
    
    for (index, neg_cooperative_n) in enumerate(neg_cooperative_ns)
        render_frame(kd, neg_cooperative_n, ligand_concentrations)
        frame(anim_neg)

        if index % 10 == 0
            println("Negative cooperativity frame $index of $num_frames rendered")
        end
    end

    mp4(anim_neg, "Hill Equation Negative Cooperativity.mp4", fps=fps)

    anim_pos = Animation()

    for (index, pos_cooperative_n) in enumerate(pos_cooperative_ns)
        render_frame(kd, pos_cooperative_n, ligand_concentrations)
        frame(anim_pos)

        if index % 10 == 0
            println("Positive cooperativity frame $index of $num_frames rendered")
        end
    end

    mp4(anim_pos, "Hill Equation Positive Cooperativity.mp4", fps=fps)
end

#####################################################################
# PRODUCE IMAGES AND MOVIES BY CALLING FUNCTIONS                    #
#####################################################################

render_stills()
render_hill_coeff_animations()
