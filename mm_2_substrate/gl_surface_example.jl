using GLMakie

# Define a grid of x and y values
x = LinRange(-5, 5, 100)
y = LinRange(-5, 5, 100)

# Create a 2D grid using the x and y values
z = [sin(sqrt(xi^2 + yi^2)) for xi in x, yi in y]

# Display the plot
display(surface(x, y, z))

readline()
