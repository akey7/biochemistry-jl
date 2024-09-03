#####################################################################
# LENGTH AND NUMBER OF STEPS IN SIMULATION                          #
#####################################################################

duration_minutes = 100
steps = 1000
h = duration_minutes / steps

#####################################################################
# FUNCTION TO INTITIALIZE INPUT VECTORS                             #
#####################################################################

function intitialize_inputs(input1_level=0.1, input_2_on_level=0.99, input_2_off_level=0.01, input_2_turn_off_step=101, input_2_turn_on_step=601)
    inputs = zeros(Float64, 2, steps)
    inputs[1, :] = input1_level
    for j in 1:length(inputs[2, :])
        if j <= input_2_turn_on_step && j >= input_2_turn_off_step
            inputs[2, j] = input_2_on_level
        else
            inputs[2, j] = input_2_off_level
        end
    end
end
