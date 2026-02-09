# Output
set terminal pdfcairo enhanced color font "Helvetica,10" size 7in,5in
set output "FLOPS_comparison_Hydrogen.pdf"

# Axes
set logscale x
set logscale y
set xlabel "Number of computed eigenvalues"
set ylabel "FLOPs"
set title "FLOPs Comparison for Hydrogen (N_{occ} = 1)"

# Grid
set grid

# X ticks: 10×N_occ, 50×N_occ, ...
set xtics ( \
    "10×N_{occ}" 10, \
    "50×N_{occ}" 50, \
    "100×N_{occ}" 100, \
    "200×N_{occ}" 200 )

# Data blocks
$BlockDavidson << EOD
10   78181993860
50   295787013900
100  37581874054200
200  217184624648000
EOD

$EnhancedJD << EOD
10   71381572176
50   267402005934
100  450561598598
200  1114613230262
EOD

# Exact diagonalization FLOPs
Exact_diago = 20*(11994**3)

# Plot
plot \
    Exact_diago with lines dashtype 2 lw 2 title "Exact Diagonalization", \
    $BlockDavidson using 1:2 with linespoints pt 5 ps 1.2 lw 2 title "Block-Davidson", \
    $EnhancedJD using 1:2 with linespoints pt 7 ps 1.2 lw 2 title "Enhanced JD"

unset output
