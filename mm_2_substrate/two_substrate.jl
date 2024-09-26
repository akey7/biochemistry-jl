using GLMakie

# Function to compute v_HGPRT from Joshi and Palsson
function v_hgprt(hx, prpp; v_hgprt_max=0.201, k_hgprt_prpp=0.005, k_hgprt_hx=0.220)
    hx_mm = hx / (hx + k_hgprt_hx)
    prpp_mm = prpp / (prpp + k_hgprt_prpp)
    v_hgprt_max * hx_mm * prpp_mm
end

# PRPP and hypoxanthine concentration ranges
prpp_concentrations = range(start=0.0025, stop=0.01, length=100)
hx_concentrations = range(start=0.11, stop=0.44, length=100)

# Compute the v_HGPRT for each combination of HX and PRPP concentration
vs = [v_hgprt(hx, prpp) for hx in hx_concentrations, prpp in prpp_concentrations]

# Display the surface in an interactive window
display(surface(prpp_concentrations, hx_concentrations, vs))

# Do not quit right away, but rather wait for a keystroke to exit.
readline()
