using Plots, Gtk, Cairo, Base64

# 1. Use explicit PNG output via png() instead of savefig()
gr()  # Ensure GR backend
plt = plot(1:10, rand(10))

# 2. Save to buffer using unexported png method
buf = IOBuffer()
Plots.png(plt, buf)  # No format keyword needed [1][2]

# 3. Convert to Cairo image
seekstart(buf)
img = Cairo.read_from_png(buf)

# 4. Display in Gtk (unchanged)
win = GtkWindow("Working Example")
canvas = GtkCanvas()
push!(win, canvas)

@guarded draw(canvas) do widget
    ctx = getgc(canvas)
    set_source_surface(ctx, img)
    paint(ctx)
end
showall(win)

readline()
