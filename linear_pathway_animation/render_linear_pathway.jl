#####################################################################
# LENGTH AND NUMBER OF STEPS IN SIMULATION                          #
#####################################################################



#####################################################################
# FUNCTION TO CALCULATE TRAJECTORY                                  #
#####################################################################

function trajectory(c)
    # Setup trajectory matrix
    x = zeros(Float64, c[:steps], 5)
    
    # Setup inputs into the system
    inputs = zeros(Float64, c[:steps], 2)
    
    for i in 1:length(inputs[:, 1])
        inputs[i, 1] = c[:input1_level]
    end

    for i in 1:length(inputs[:, 2])
        if i <= c[:input_2_turn_on_step] && i >= c[:input_2_turn_off_step]
            inputs[i, 2] = c[:input_2_on_level]
        else
            inputs[i, 2] = c[:input_2_off_level]
        end
    end

    # Setup initial conditions
    x[1, 1:5] .= c[:initial_conditions]
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
    :initial_conditions => [1.0, 1.0, 1.0, 1.0, 1.0]
)

trajectory(reasonable_defaults)
