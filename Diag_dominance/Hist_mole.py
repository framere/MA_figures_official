import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from matplotlib.ticker import LogLocator

# sns.set(style="whitegrid")
sns.set_context("notebook", font_scale=1.5)

colors = sns.color_palette("tab10")

molecule_names = ['uracil'] #'hBN', 'He', 'Si', 'He'

for mol in molecule_names:
    df = pd.read_csv(f'/home/fmereto/MA_figures_official/txt_files/ratio_{mol}.txt',  sep=r"\s+", header=None, engine="c")
    indices = df.index
    if mol == "He":
        step_high = 10
        step_low = 30
    else:
        step_high = 1000
        step_low = 1000

    # Take column values
    values = df.iloc[:, 0]

    # Remove non-finite entries
    values = values[np.isfinite(values)]

    # Split into low and high regions
    low_mask  = values <= 1e2
    high_mask = values > 1e2

    # Indices for each region
    low_indices  = values[low_mask].index[::step_low]
    high_indices = values[high_mask].index[::step_high]

    # Combine sampled indices
    sampled_indices = low_indices.union(high_indices)

    # Final sampled values
    sampled_values = values.loc[sampled_indices]
    sampled_values = sampled_values[sampled_values > 5e1]  # Ensure all values are positive
    if len(sampled_values) == 0:
        print(f"Skipping {mol}: no valid positive values.")
        continue

    vmin, vmax = sampled_values.min(), sampled_values.max()
    if vmin <= 0 or vmax <= 0:
        print(f"Skipping {mol}: contains non-positive values (vmin={vmin}, vmax={vmax})")
        continue

    # Define logarithmic bins safely
    n_bins = int(np.log10(vmax / vmin) * 5)  # ~20 bins per decade, adjustable
    n_bins = max(n_bins, 10)  # ensure at least 10 bins

    bins = np.logspace(np.log10(vmin), np.log10(vmax), num=n_bins)

    plt.figure(figsize=(8, 6))
    sns.histplot(sampled_values, bins=bins, color=colors[0])
    plt.xscale('log')
    plt.xlabel(r"$r_{ij} = a_{ii}$ / $a_{ij}$")
    plt.ylabel("Frequency")
    
    # Only put major ticks (and thus grid lines) at 10^0, 10^1, 10^2, ...
    plt.gca().xaxis.set_major_locator(LogLocator(base=10.0, subs=[1.0]))

    # Remove minor ticks if you don't want them
    plt.gca().xaxis.set_minor_locator(LogLocator(base=10.0, subs=[]))

    # Draw grid only at major ticks
    plt.grid(True, which='major', ls='--', lw=0.8, alpha=0.6)

    plt.title(f"Element-wise ratio (He)")
    sns.despine()
    plt.tight_layout()
    plt.savefig(f"histo_diag_dom_{mol}_sampled.pdf")
    plt.close()

    print(f"Saved histogram for Sparse_matrix_{mol}")