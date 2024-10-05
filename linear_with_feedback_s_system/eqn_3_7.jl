# using Plots

###########################################################
# SYSTEM VALUES FOR ALL FRAMES                            #
###########################################################

n_iterations = 1000
n_metabolites = 4
n_frames = 300
systems = zeros(Float64, n_iterations, n_metabolites, n_frames)

###########################################################
# SET INITIAL CONDITIONS FOR ALL FRAMES                   #
###########################################################

systems[1, 1, :] .= 1.0
systems[1, 2, :] .= 1.0
systems[1, 3, :] .= 1.0
systems[:, 4, :] .= 0.5  # X4 is a constant

###########################################################
# FUNCTION TO CALCULATE SYSTEM FROM INTIAL CONIDTIONS     #
# AND PARAMETERS.                                         # 
###########################################################

function eqn_3_7(frame::Int64, g13::Float64)
    for i ∈ 2:length(systems[:, 1, 1])
        println(i)
    end
end

###########################################################
# RENDER AND SAVE ALL FRAMES                              #
###########################################################

eqn_3_7(1, -2.0)
