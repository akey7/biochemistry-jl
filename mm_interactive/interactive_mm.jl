using Base64
using Gtk
using Plots
using Cairo

gr()

substrate = range(1.0e-6, 1.0e-2, 100)

function competitive_inhibition_curve(km, vmax, inhibitor, ki)
    num = vmax .* substrate
    denom = km * (1 + inhibitor/ki) .+ substrate
    return num ./ denom
end

function non_competitive_inhibition_curve(km, vmax, inhibitor, ki)
    num = vmax .* substrate
    denom = (1 + inhibitor / ki) .* (km .+ substrate)
    return num ./ denom
end

mm_curve(km, vmax) = vmax .* substrate ./ (km .+ substrate)

function plot_competitive_inhibition_curve(vs, inhibited_vs, inhibited_title)
    label = ["Uninhibited" inhibited_title]
    ymax = 1.0e-3
    plt = plot(
        substrate,
        [vs, inhibited_vs],
        label = label,
        ylims = (0.0, ymax),
        xlabel = "[S] (M)",
        ylabel = "v (M/hr)",
    )
    buf = IOBuffer()
    Plots.png(plt, buf)
    seekstart(buf)
    return Cairo.read_from_png(buf)
end

b_filename = joinpath("mm_interactive", "interactive_mm_ui.glade")
b = GtkBuilder(filename = b_filename)
win = b["window_01"]
radio_competitive = b["radio_competitive"]
radio_non_competitive = b["radio_non_competitive"]
scale_km = b["scale_km"]
scale_vmax = b["scale_vmax"]
scale_inhibitor = b["scale_inhibitor"]
scale_ki = b["scale_ki"]
button_update = b["button_update"]
frame_01 = b["frame_01"]
canvas_01 = GtkCanvas()
push!(frame_01, canvas_01)

function button_update_clicked(widget, others...)
    km = GAccessor.value(scale_km)
    vmax = GAccessor.value(scale_vmax)
    inhibitor = GAccessor.value(scale_inhibitor)
    ki = GAccessor.value(scale_ki)
    km *= 1e-4
    vmax *= 1e-4
    inhibitor *= 1e-4
    ki *= 1e-4
    is_competitive = get_gtk_property(radio_competitive, :active, Bool)
    println("km=$km vmax=$vmax inhibitor=$inhibitor ki=$ki is_competitive=$is_competitive")
    inhibited_vs =
        is_competitive ? competitive_inhibition_curve(km, vmax, inhibitor, ki) :
        non_competitive_inhibition_curve(km, vmax, inhibitor, ki)
    inhibited_title = is_competitive ? "Competitive" : "Non-Competitive"
    mm_vs = mm_curve(km, vmax)
    img = plot_competitive_inhibition_curve(mm_vs, inhibited_vs, inhibited_title)
    ctx = getgc(canvas_01)
    set_source_surface(ctx, img)
    paint(ctx)
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
