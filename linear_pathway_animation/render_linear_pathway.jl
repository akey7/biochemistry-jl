using Plots
using PyPlot
pyplot()

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
        if i <= c[:input_2_turn_on_step] && i >= c[:input_2_turn_off_step]
            in[i, 2] = c[:input_2_on_level]
        else
            in[i, 2] = c[:input_2_off_level]
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
            println("Passed iteration $i")
        end
    end

    x 
end

#####################################################################
# REASONABLE DEFAULTS                                               #
#####################################################################

reasonable_defaults = Dict(
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

x_trajectory = trajectory(reasonable_defaults)
scatter(x=1:1000, y=x_trajectory[:, 1])
savefig("foo.png")
