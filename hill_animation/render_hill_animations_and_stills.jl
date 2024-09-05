#####################################################################
# IMPORT MODULES                                                    #
#####################################################################

using Plots
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
        linewidth=3,
        xlims=(minimum(ligand_concentrations), maximum(ligand_concentrations) * 1.05),
        ylims=(0.0, 1.01),
        guidefont=font(18),
        xlabel="[L] (M)",
        xticks=(xtick_vals, xtick_labels),
        xtickfont=font(18),
        ylabel="theta",
        yticks=(ytick_vals, ytick_labels),
        ytickfont=font(18),
        size=(size_x, size_y),
    )
end

#####################################################################
# FUNCTION TO RENDER AND SAVE STILLS                                #
#####################################################################

function render_stills()
    ligand_concentrations = range(start=0.0, stop=1.0e-2, length=100)
    kd = 1.0e-3
    n_non_cooperative = 1.0
    # n_neg_cooperative = 0.25
    # n_pos_cooperative = 1.5

    render_frame(kd, n_non_cooperative, ligand_concentrations)
    savefig("Hill Non-Cooperative.png")
    println("Rendered non-cooperative still")
end

#####################################################################
# PRODUCE IMAGES AND MOVIES BY CALLING FUNCTIONS                    #
#####################################################################

render_stills()
