using Base64
using Gtk
using Plots
using Cairo

gr()

b_filename = joinpath("hb_o2_binding", "hb_o2_binding_ui.glade")
b = GtkBuilder(filename = b_filename)
win = b["window_01"]
frame_01 = b["frame_01"]
scale_ph = b["scale_ph"]
scale_co2 = b["scale_co2"]
scale_bpg = b["scale_bpg"]
button_update = b["button_update"]
canvas_01 = GtkCanvas()
push!(frame_01, canvas_01)

function button_update_clicked(widget, others...)
    ph = GAccessor.value(scale_ph)
    co2 = GAccessor.value(scale_co2)
    bpg = GAccessor.value(scale_bpg)
    println("ph=$ph co2=$co2 bpg=$bpg")
end

signal_connect(button_update_clicked, button_update, "clicked")

showall(win)
button_update_clicked(button_update)  # Get the initial default values from UI
if !isinteractive()
    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    wait(c)
end
