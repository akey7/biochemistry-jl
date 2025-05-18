using Gtk4

win = GtkWindow("My First Gtk4.jl Program", 400, 200)

b = GtkButton("Click Me")
push!(win, b)

# Make the window visible
show(win)

# Set up a callback for the button
signal_connect(b, "clicked") do widget
    println("Button clicked!")
end

# Create an application object
app = GtkApplication("org.example.MyApp", 0)

# This callback function is called when the application is activated
function on_app_activate(app)
    # Show the window
    present(win)
end

# Connect the "activate" signal to the callback
signal_connect(on_app_activate, app, "activate")

# Start the application and run until it exits
run(app)
readline()