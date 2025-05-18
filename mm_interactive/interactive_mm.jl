using Gtk

b_filename = joinpath("mm_interactive", "interactive_mm_ui.glade")
b = GtkBuilder(filename = b_filename)
win = b["window_01"]
scale_km = b["scale_km"]
scale_vmax = b["scale_vmax"]

function scale_km_value_changed(widget, others...)
    value = GAccessor.value(scale_km)
    value *= 1e-4
    Threads.@spawn begin
        println("Km = $value")
    end
end

function scale_vmax_value_changed(widget, others...)
    value = GAccessor.value(scale_vmax)
    value *= 1e-4
    Threads.@spawn begin
        println("Vmax = $value")
    end
end 

signal_connect(scale_km_value_changed, scale_km, "value-changed")
signal_connect(scale_vmax_value_changed, scale_vmax, "value-changed")

showall(win)
println("Press enter to exit script and close window...")
readline()
