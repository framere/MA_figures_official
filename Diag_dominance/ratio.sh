#!/bin/sh
#SBATCH -J ratio
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -p test
#SBATCH --time=1-00:00:00

JULIA=/home/fmereto/julia/bin/julia

$JULIA check_diag_dominance.jl