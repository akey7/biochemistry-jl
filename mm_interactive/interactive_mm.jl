using Gtk

b_filename = joinpath("mm_interactive", "interactive_mm_ui.glade")
b = GtkBuilder(filename = b_filename)
win = b["window_01"]
scale_km = b["scale_km"]
scale_vmax = b["scale_vmax"]
scale_inhibitor = b["scale_inhibitor"]
scale_ki = b["scale_ki"]
button_update = b["button_update"]
drawing_area_01 = b["drawing_area_01"]

function button_update_clicked(widget, others...)
    km = GAccessor.value(scale_km)
    vmax = GAccessor.value(scale_vmax)
    inhibitor = GAccessor.value(scale_inhibitor)
    ki = GAccessor.value(scale_ki)
    km *= 1e-4
    vmax *= 1e-4
    inhibitor *= 1e-4
    ki *= 1e-4
    Threads.@spawn begin
        println("km=$km vmax=$vmax inhibitor=$inhibitor ki=$ki")
    end
end

signal_connect(button_update_clicked, button_update, "clicked")

showall(win)
button_update_clicked(button_update)  # Get the initial default values from UI
println("Press enter to exit script and close window...")
readline()
