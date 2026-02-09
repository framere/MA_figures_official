using LinearAlgebra

systems = ["He", "hBN", "Si"]
folder = "/home/fmereto/Master_arbeit/Davidson_algorithm"

function load_matrix(system::String)
    if system == "He"
        N = 4488
    elseif system == "hBN"
        N = 6863        
    elseif system == "Si"
        N = 6201
    else
        error("Unknown system: $system")
    end

    # read the matrix
    filename = "/home/fmereto/Master_arbeit/Davidson_algorithm/m_pp_" * system * ".dat"
    println("read ", filename)
    file = open(filename, "r")
    A = Array{Float64}(undef, N * N)
    read!(file, A)
    close(file)

    A = reshape(A, N, N)
    A = -A  # for largest eigenvalues of original matrix
    return Hermitian(A)
end


function compute_save_EV(system::String, outputfile::String)
    A = load_matrix(system)
    println("compute eigenvalues for $system")
    @time Σexact, Uexact = eigen(A) 
    EV = Σexact
    
    println("save eigenvalues to ", outputfile)
    open(outputfile, "w") do file
        for val in EV
            write(file, string(val), "\n")  
        end
    end  # Added missing 'end' for the do block
    
    println("Eigenvalues saved successfully!")
    return EV
end

for system in systems
    outputfile = "eigenvalues_" * system * ".txt"
    compute_save_EV(system, outputfile)
end