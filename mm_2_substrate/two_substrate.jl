using GLMakie

function v_hgprt(hx, prpp; v_hgprt_max=0.201, k_hgprt_prpp=0.005, k_hgprt_hx=0.220)
    hx_mm = hx / (hx + k_hgprt_hx)
    prpp_mm = prpp / (prpp + k_hgprt_prpp)
    v_hgprt_max * hx_mm * prpp_mm
end

prpp_concentrations = range(start=0.0025, stop=0.01, length=100)
hx_concentrations = range(start=0.11, stop=0.44, length=100)

vs = [v_hgprt(hx, prpp) for hx in hx_concentrations, prpp in prpp_concentrations]

display(surface(prpp_concentrations, hx_concentrations, vs))

readline()
