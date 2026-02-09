using LinearAlgebra
using Printf

function load_matrix(filename::String, molecule::String)
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

function load_old_matrix(system::String, filename::String) 
    if system == "He"
        N = 4488
    elseif system == "hBN"
        N = 6863        
    elseif system == "Si"
        N = 6201
    else
        error("Unknown system: $system")
    end

    println("read ", filename)
    file = open(filename, "r")
    A = Array{Float64}(undef, N, N)
    for i in 1:N
        for j in 1:N
            A[i, j] = read(file, Float64)
        end
    end
    close(file)

    A = -A # for largest eigenvalues of original matrix
    return Hermitian(A)
end

function analyze_diagonal_dominance(A::AbstractMatrix{T}, output_filename::String) where T<:Number
    N = size(A, 1)
    
    # Open output file
    output_file = open(output_filename, "w")
    
    count_non_diago_dominant_rows = 0
    for i in 1:N
        diag_element = abs(A[i, i])
        off_diag_sum = sum(abs(A[i, j]) for j in 1:N if j != i)

        # Write to file
        @printf(output_file, "%.15e %.15e\n", diag_element, off_diag_sum)

        if diag_element <= off_diag_sum
            count_non_diago_dominant_rows += 1            
        end
    end
    
    close(output_file)
    
    return count_non_diago_dominant_rows
end

function analyze_sparsity(A::AbstractMatrix{T}, threshold::Float64) where T<:Number
    N = size(A, 1)
    total_elements = N * N
    
    # Count elements below threshold directly without copying
    non_zero_elements = count(x -> abs(x) >= threshold, A)
    
    sparsity = 1.0 - (non_zero_elements / total_elements)
    return sparsity
end

function define_ratio(A::AbstractMatrix{T}, output_filename::String) where T<:Number
    N = size(A, 1)
    output_file = open(output_filename, "w")
    
    for i in 1:N
        diag_element = abs(A[i, i])
        for j in 1:N
            if j != i
                off_diag = abs(A[i, j])
                ratio = diag_element / off_diag
                @printf(output_file, "%.15e \n", ratio)
            end
        end

    end
    close(output_file)
end

function main(system::String)
    output_filename = "/home/fmereto/MA_figures_official/txt_files/diagonal_analysis_" * system * ".txt"
    A = load_old_matrix(system, "../Master_arbeit/Davidson_algorithm/m_pp_" * system * ".dat")
    count = analyze_diagonal_dominance(A, output_filename)
    # for (i,s) in enumerate(systems)
    #     println("Processing system: ", s)
    #     if i > 3
    #         A_old = load_old_matrix(s, "../Master_arbeit/Davidson_algorithm/m_pp_" * s * ".dat")
    #         sparsity_old = analyze_sparsity(A_old, 1e-10)
    #         @printf("Sparsity of the OLD matrix for %s: %.9f\n", s, sparsity_old)
    #     elseif i <= 3
    #         # A = load_matrix("../MA_best/" * s *"/gamma_VASP_RNDbasis1.dat", s)
    #         # sparsity = analyze_sparsity(A, 1e-7)
    #         # @printf("Sparsity of the matrix for %s: %.9f\n", s, sparsity)
    #         continue
    #     else 
    #         break
    #     end
    # end
    # if non_dominant_count > 0
    #     println("Matrix is not diagonally dominant in $non_dominant_count rows.")
    #     println("Results written to $output_filename")
    # else
    #     println("Matrix is diagonally dominant in all rows.")
    #     println("Results written to $output_filename")
    # end
end

systems = ["H2", "formaldehyde", "uracil", "He", "hBN", "Si"] 

# main(systems)
main("He")

# A1 = load_matrix("../MA_best/uracil/gamma_VASP_RNDbasis1.dat", "uracil")
A2 = load_old_matrix("hBN", "../Master_arbeit/Davidson_algorithm/m_pp_hBN.dat")
A3 = load_old_matrix("He", "../Master_arbeit/Davidson_algorithm/m_pp_He.dat")
A4 = load_old_matrix("Si", "../Master_arbeit/Davidson_algorithm/m_pp_Si.dat")

# define_ratio(A1, "/home/fmereto/MA_figures_official/txt_files/ratio_uracil.txt")
# define_ratio(A2, "/home/fmereto/MA_figures_official/txt_files/ratio_hBN.txt")
# define_ratio(A3, "/home/fmereto/MA_figures_official/txt_files/ratio_He.txt")
# define_ratio(A4, "/home/fmereto/MA_figures_official/txt_files/ratio_Si.txt")
