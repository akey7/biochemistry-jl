using Gtk 

function btn_clicked(widget)
    println(widget, " was clicked!")
end

b = GtkBuilder(filename = "mm_interactive/basic_ui.glade")
win = b["window_01"]
btn = b["button_01"]
signal_connect(btn_clicked, btn, "clicked")
showall(win)
readline()
