using LinearAlgebra
using JLD2
using Printf

function load_matrix_large(filename::String, molecule::String)
    if molecule == "H2"
        N = 11994
    elseif molecule == "formaldehyde"
        N = 27643
    elseif molecule == "uracil"
        N = 32416
    else
        error("Unknown molecule: $molecule")
    end
    # println("read ", filename)
    file = open(filename, "r")
    A = Array{Float64}(undef, N * N)
    read!(file, A)
    close(file)

    A = reshape(A, N, N)
    return Hermitian(A)
end

function load_matrix_small(filename::String, molecule::String)
    if molecule == "He"
        N = 4488
    elseif molecule == "hBN"
        N = 6863
    elseif molecule == "Si"
        N = 6201
    else
        error("Unknown molecule: $molecule")
    end
    file = open(filename, "r")
    A = Array{Float64}(undef, N * N)
    read!(file, A)
    close(file)

    A = reshape(A, N, N)
    A = -A
    return Hermitian(A)
end


function sparsity_ratio(A::AbstractMatrix, δ::Real)
    total_elements = length(A)                     # total number of elements
    nnz_delta = count(abs(x) >= δ for x in A)      # elements not set to zero
    return nnz_delta / total_elements
end


molecules_large = ["H2", "formaldehyde", "uracil"]
molecules_small = ["He", "hBN", "Si"]

for molecule in molecules_large
    filename = "../../MA_best/" * molecule *"/gamma_VASP_RNDbasis1.dat"
    A = load_matrix_large(filename, molecule)
    δ = 1e-4
    ratio = sparsity_ratio(A, δ)
    @printf("Molecule: %s, δ: %.0e, Sparsity Ratio: %.6f\n", molecule, δ, ratio)
end

for molecule in molecules_small
    filename = "../../Master_arbeit/Davidson_algorithm/m_pp_" * molecule * ".dat"
    A = load_matrix_small(filename, molecule)
    δ = 1e-7
    ratio = sparsity_ratio(A, δ)
    @printf("Molecule: %s, δ: %.0e, Sparsity Ratio: %.6f\n", molecule, δ, ratio)
end