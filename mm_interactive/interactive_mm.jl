using Gtk

b_filename = joinpath("mm_interactive", "interactive_mm_ui.glade")
b = GtkBuilder(filename = b_filename)
win = b["window_01"]
scale_01 = b["scale_01"]

function scale_01_value_changed(widget, others...)
    value = GAccessor.value(scale_01)
    Threads.@spawn begin
        println("Slider value is $value")
    end
end

signal_connect(scale_01_value_changed, scale_01, "value-changed")

showall(win)
println("Press enter to exit script and close window...")
readline()
