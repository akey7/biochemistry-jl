using Gtk 
b = GtkBuilder(filename = "mm_interactive/basic_ui.glade")
win = b["window_01"]
showall(win)
readline()
