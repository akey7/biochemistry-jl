# using Plots

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
# TIME LENGTH AND STEP SIZE                               #
###########################################################

t_max = 10.0
h = t_max / n_iterations

###########################################################
# EXTREME VALUES OF g13 PARAMETER (WHICH ARE NEGATIVE)    #
###########################################################

g13_start = 0.0
g13_end = -5.0

###########################################################
# FUNCTION TO CALCULATE SYSTEM FROM INTIAL CONIDTIONS     #
# AND PARAMETERS.                                         # 
###########################################################

function eqn_3_7(frame::Int64, g13::Float64)
    for i ∈ 2:length(x[:, 1, 1])
        x1 = x[i-1, 1, frame]
        x1 = x[i-1, 2, frame]
        x1 = x[i-1, 3, frame]
        x1 = x[i-1, 4, frame]
        
    end
end

###########################################################
# RENDER AND SAVE ALL FRAMES                              #
###########################################################

frames_and_g13s = collect(zip(1:n_frames, range(start=g13_start, stop=g13_end, length=n_frames)))

for (frame, g13) ∈ frames_and_g13s
    println("Rendering frame=$frame g13=$g13")
end
