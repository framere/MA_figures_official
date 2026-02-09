#!/bin/sh
#SBATCH -J diag_dom
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -p andoria
#SBATCH --time=1-00:00:00

PYTHON=/home/fmereto/anaconda3/bin/python3

$PYTHON Hist_mole.py