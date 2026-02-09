using Plots

# Data
N_occ = 1
ls = [10, 50, 100, 200]

# FLOPS enhanced JD
FLOPS_beta25_impl1 = [71381572176, 267402005934, 450561598598, 1114613230262]
# baseline FLOPS for beta=8
FLOPS_8_BD = [78181993860, 295787013900, 37581874054200, 217184624648000]
# Exact diagonalization FLOPS
Exact_diago = 20 * (11994^3)

# Plot (log-log)
p = plot(
    ls, FLOPS_8_BD;
    xscale = :log10,
    yscale = :log10,
    marker = :diamond,
    label  = "Block-Davidson",
    xlabel = "Number of computed eigenvalues",
    ylabel = "FLOPs",
    title  = "FLOPs Comparison for Hydrogen (\$N_{occ} = 1\$)",
    grid   = true,
)

plot!(p, ls, FLOPS_beta25_impl1; marker = :utriangle, label = "Enhanced JD")

hline!(p, [Exact_diago]; linestyle = :dash, label = "Exact Diagonalization")

# X ticks like "10×N_occ", ...
xticks_vals   = [10, 50, 100, 200] .* N_occ
xticks_labels = ["$(m)×\$N_{occ}\$" for m in (10, 50, 100, 200)]
plot!(p; xticks = (xticks_vals, xticks_labels))

# Save + show
savefig(p, "FLOPS_comparison_Hydrogen.pdf")
display(p)
