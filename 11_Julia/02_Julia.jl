struct galaxy_node
    x_cord::Int32
    y_cord::Int32
    lines_on_top::Int32
    columns_on_left::Int32
end

function main()
    if length(ARGS) < 1
        print("Usage: ", PROGRAM_FILE, " <input_file>\n")
        return
    else
        universe = Array{Array{Char}}(undef, 0)
        lines_without_gal = Array{Int32}(undef, 0)
        col_without_gal = Array{Int32}(undef, 0)
        parseFile(ARGS[1], universe, lines_without_gal, col_without_gal)

        galaxies = Array{galaxy_node}(undef, 0)

        for (i, line) in enumerate(universe)
            for (j, node) in enumerate(line)
                if node == '#'
                    column_count = 0
                    line_count = 0
                    for cwg in col_without_gal
                        if cwg < j
                            column_count += 1
                        end
                    end
                    for lwg in lines_without_gal
                        if lwg < i
                            line_count += 1
                        end
                    end
                    push!(galaxies, galaxy_node(j, i, line_count, column_count))
                end
            end
        end

        sum::Int64 = 0
        i = 1
        while i <= length(galaxies)
            j = i + 1
            while (j <= length(galaxies))
                galaxy1::galaxy_node = galaxies[i]
                galaxy2::galaxy_node = galaxies[j]
                sum += abs((galaxy1.x_cord + (galaxy1.columns_on_left * 1000000) - galaxy1.columns_on_left) - (galaxy2.x_cord + (galaxy2.columns_on_left * 1000000) - galaxy2.columns_on_left)) +
                       abs((galaxy1.y_cord + (galaxy1.lines_on_top * 1000000) - galaxy1.lines_on_top) - (galaxy2.y_cord + (galaxy2.lines_on_top * 1000000) - galaxy2.lines_on_top))
                j += 1
            end
            i += 1
        end

        print(sum, "\n")
    end
end

function parseFile(file_path::String, universe_arr::Array{Array{Char}}, lines_without_gal::Array{Int32}, columns_without_lines::Array{Int32})
    line_length::Int32 = 0
    line_count::Int32 = 0
    for (i, line) in enumerate(eachline(file_path))
        line_length = length(line)
        line_arr = Array{Char}(undef, 0)

        for c in line
            push!(line_arr, c)
        end

        push!(universe_arr, line_arr)
        line_count += 1
        if !contains(line, "#")
            push!(lines_without_gal, i)
        end
    end

    i = 1
    while i < line_length
        all_dots = true
        j = 1
        while j <= line_count
            if universe_arr[j][i] != '.'
                all_dots = false
                break
            end
            j += 1
        end
        if all_dots
            push!(columns_without_lines, i)
        end
        i += 1
    end

    for line in lines_without_gal
        print("Line ", line, " has no galaxies\n")
    end

    for col in columns_without_lines
        print("Column ", col, " has no galaxies\n")
    end

    print("line_length: ", line_length, "\n")
    print("line_count: ", line_count, "\n")
end

main()