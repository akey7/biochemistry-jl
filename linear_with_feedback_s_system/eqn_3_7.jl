using Base.Threads
using Plots
using Printf

gr()  # Use basic GR backend for plots

###########################################################
# SYSTEM PROPERTIES THAT WILL BE DIMENSTIONS OF THE DATA  #
# STRUCTURE.                                              #
###########################################################

n_iterations = 1000
n_metabolites = 4
n_frames = 300
x = zeros(Float64, n_iterations, n_metabolites, n_frames)

###########################################################
# SET INITIAL CONDITIONS FOR ALL FRAMES                   #
###########################################################

x[1, 1, :] .= 1.0
x[1, 2, :] .= 1.0
x[1, 3, :] .= 1.0
x[:, 4, :] .= 0.5  # X4 is a constant

###########################################################
# SET COEFFICIENTS AND EXPONENTS                          #
###########################################################

α = [0.5, 0.5, 4.0]
β = [0.5, 4.0, 2.0]
h11 = 0.5
g21 = 0.5
h33 = 0.75

###########################################################
# TIME LENGTH AND STEP SIZE                               #
###########################################################

t_max = 8.0
h = t_max / n_iterations

###########################################################
# EXTREME VALUES OF g13 PARAMETER (WHICH ARE NEGATIVE)    #
###########################################################

g13_start = 0.0
g13_end = -2.0

###########################################################
# FUNCTION TO CALCULATE SYSTEM FROM INTIAL CONIDTIONS     #
# AND PARAMETERS.                                         # 
###########################################################

function eqn_3_7(frame::Int64, g13::Float64)
    for i ∈ 2:length(x[:, 1, 1])
        x1 = x[i-1, 1, frame]
        x2 = x[i-1, 2, frame]
        x3 = x[i-1, 3, frame]
        x4 = x[i-1, 4, frame]
        x[i, 1, frame] = x1 + h*(α[1]*x3^g13*x4 - β[1]*x1^h11)
        x[i, 2, frame] = x2 + h*(α[2]*x1^g21 - β[2]*x2)
        x[i, 3, frame] = x3 + h*(α[3]*x2 - β[3]*x3^h33)
    end
end

###########################################################
# CALCULATE THE TRAJECTORY OF EACH SYSTEM FOR EACH FRAME  #
###########################################################

frames_and_g13s = collect(zip(1:n_frames, range(start=g13_start, stop=g13_end, length=n_frames)))

Threads.@threads for (frame, g13) ∈ frames_and_g13s
    eqn_3_7(frame, g13)
    println("Rendered frame=$frame g13=$g13.")
end

###########################################################
# STITCH FRAMES TOGETHER INTO A MOVIE                     #
###########################################################

# But this has to happen on one thread to preserve frame order

println("Rendering all frames...")

y_max = maximum(x[:, 1:3, :])
ytick_values = range(start=0.0, stop=y_max, length=10)
ytick_labels = [@sprintf("%.1f", ytick_value) for ytick_value in ytick_values]
line_labels = ["x1" "x2" "x3 (inhibits x1)"]
x_axis = range(start=0.0, stop=t_max, length=n_iterations)
xtick_values = range(start=0.0, stop=t_max, length=3)
xtick_labels = [@sprintf("%.1f", xtick_value) for xtick_value in xtick_values]
size = (1080, 1920 / 2)
linewidth = 3

anim = @animate for (frame, g13) ∈ frames_and_g13s
    title_g13 = @sprintf("%.2f", g13)
    y_axis = x[:, 1:3, frame]

    plot(
        x_axis,
        y_axis,
        linewidth=linewidth,
        legend=:topleft,
        legendfont=14,
        label=line_labels,
        xticks=(xtick_values, xtick_labels),
        xtickfont=14,
        ylims=(0.0, y_max * 1.01),
        yticks=(ytick_values, ytick_labels),
        ytickfont=14,
        title="g13=$title_g13",
        titlefont=20,
        size=size
    )
end

println("Writing animation...")
mp4(anim, "eqn_3_7_plot.mp4", fps=30)
