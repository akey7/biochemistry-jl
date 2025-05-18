using Gtk

b_filename = joinpath("mm_interactive", "interactive_mm_ui.glade")
b = GtkBuilder(filename = b_filename)
win = b["window_01"]
showall(win)
readline()
println("Press enter to terminate script...")
