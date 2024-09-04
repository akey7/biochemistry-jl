#####################################################################
# IMPORT MODULES                                                    #
#####################################################################

using Plots
using Printf

#####################################################################
# SIZE OF IMAGES AND MOVIES AND NUMBER OF FRAMES FOR ANIMATIONS     #
#####################################################################

size_x = 1080 / 2
size_y = 1920 / 4
num_frames = 300

#####################################################################
# FUNCTION TO CALCULATE TRAJECTORY                                  #
#####################################################################

function trajectory(c)
    # Setup trajectory matrix
    x = zeros(Float64, c[:steps], 5)
    
    # Setup inputs into the system
    in = zeros(Float64, c[:steps], 2)
    
    for i in 1:length(in[:, 1])
        in[i, 1] = c[:input1_level]
    end

    for i in 1:length(in[:, 2])
        if i  >= c[:input_2_turn_off_step] && i <= c[:input_2_turn_on_step]
            in[i, 2] = c[:input_2_off_level]
        else
            in[i, 2] = c[:input_2_on_level]
        end
    end

    # Setup initial conditions
    x[1, 1:5] .= c[:initial_conditions]

    # Run the trajectory
    h = c[:duration_minutes] / c[:steps]
    h42 = c[:h42]
    for i in 2:length(x[:, 1])
        x1 = x[i-1, 1]
        x2 = x[i-1, 2]
        x3 = x[i-1, 3]
        x4 = x[i-1, 4]
        x5 = x[i-1, 5]
        in1 = in[i-1, 1]
        in2 = in[i-1, 2]
        x[i, 1] = x1 + h*(in1 + in2*x4^0.5 - x1^0.5)
        x[i, 2] = x2 + h*(x1^0.5 - x2^0.75)
        x[i, 3] = x3 + h*(2*x2^0.75 - 2*x3^0.4)
        x[i, 4] = x4 + h*(2*x3^0.4 - in2*x4^0.5 - x2^h42*x4^0.5)
        x[i, 5] = x5 + h*(x2^h42*x4^0.5 - x5^0.5)

        if i % 10 == 0
            println("Trajectory calculation iteration $i")
        end
    end

    println("Trajectory calculation finished")

    Dict(:x => x, :inputs => in)
end

#####################################################################
# REASONABLE DEFAULTS TO RECREATE FIG 5A                            #
#####################################################################

fig_5a_defaults = Dict(
    :duration_minutes => 100, 
    :steps => 1000, 
    :input1_level => 0.1, 
    :input_2_on_level => 0.99,
    :input_2_off_level => 0.01,
    :input_2_turn_off_step => 101, 
    :input_2_turn_on_step => 601,
    :h42 => 0.75,
    :initial_conditions => [1.0, 1.0, 1.0, 1.0, 1.0]
)

#####################################################################
# CREATE THE PLOT FROM FIG 5A                                       #
#####################################################################

result = trajectory(fig_5a_defaults)

xs = range(
    start=0,
    stop=fig_5a_defaults[:duration_minutes],
    length=fig_5a_defaults[:steps]
)

xtick_vals = range(start=minimum(xs), stop=maximum(xs), length=5)
input2_xtick_labels = [@sprintf("%.1f", val) for val in xtick_vals]
output_xtick_labels = ["" for val in xtick_vals]

output_ytick_vals = range(start=0.0, stop=maximum(result[:x]), length=4)
output_ytick_labels = [@sprintf("%.1f", val) for val in output_ytick_vals]

output_plot = plot(
    xs, 
    result[:x],
    labels=["G6P" "FBP" "3-PGA" "PEP" "Pyruvate"],
    xticks=(xtick_vals, output_xtick_labels),
    yticks=(output_ytick_vals, output_ytick_labels),
    xlims=(0.0, maximum(xs) * 1.01),
    ylims=(0.0, maximum(result[:x]) * 1.01),
    xlabel="",
    ylabel="concentration"
)

input2_ytick_vals = range(start=0.0, stop=maximum(result[:inputs][:,2]), length=4)
input2_ytick_labels = [@sprintf("%.1f", val) for val in input2_ytick_vals]

input2_plot = plot(
    xs, 
    result[:inputs][:, 2],
    labels="Input 2",
    xticks=(xtick_vals, input2_xtick_labels),
    yticks=(input2_ytick_vals, input2_ytick_labels),
    xlims=(0.0, maximum(xs) * 1.01),
    ylims=(0.0, maximum(result[:inputs][:, 2]) * 1.01),
    xlabel="sec",
    ylabel="concentration"
)

plot(output_plot, input2_plot, layout=(2, 1), size=(size_x, size_y))
savefig("Fig 5A.png")

println("Rendering done!")
