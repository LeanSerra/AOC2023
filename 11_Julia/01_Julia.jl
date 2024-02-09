

struct galaxy_node
    x_cord::Int32
    y_cord::Int32
end

function main()
    if length(ARGS) < 1
        print("Usage: ", PROGRAM_FILE, " <input_file>\n")
        return
    else
        universe = Array{Array{Char}}(undef, 0)
        parseFile(ARGS[1], universe)

        galaxies = Array{galaxy_node}(undef, 0)

        for (i, line) in enumerate(universe)
            for (j, node) in enumerate(line)
                if node == '#'
                    push!(galaxies, galaxy_node(j, i))
                end
            end
        end


        sum::Int32 = 0

        i = 1
        while i <= length(galaxies)
            j = i + 1
            while (j <= length(galaxies))
                galaxy1::galaxy_node = galaxies[i]
                galaxy2::galaxy_node = galaxies[j]

                print(galaxy1.x_cord, ",", galaxy1.y_cord, "\t", galaxy2.x_cord, ",", galaxy2.y_cord, "\n")

                sum += abs(galaxy1.x_cord - galaxy2.x_cord) + abs(galaxy1.y_cord - galaxy2.y_cord)
                j += 1
            end
            i+=1
        end

        print(sum, "\n")
    end
end

function parseFile(file_path, universe_arr)
    line_length::Int32 = 0
    line_count::Int32 = 0
    for line in eachline(file_path)
        line_length = length(line)
        line_arr = Array{Char}(undef, 0)

        for c in line
            push!(line_arr, c)
        end

        push!(universe_arr, line_arr)
        line_count += 1

        if !contains(line, "#")
            line_arr = []

            k = 0

            while k < line_length
                push!(line_arr, '.')
                k += 1
            end

            push!(universe_arr, line_arr)
            line_count += 1
        end
    end

    i = 1
    while i < line_length
        all_dots = true
        for j = 1:line_count
            if universe_arr[j][i] != '.'
                all_dots = all_dots & false
            end
        end
        if all_dots
            for k = 1:line_count
                insert!(universe_arr[k], i, '.')
            end
            line_length += 1
            i += 1
        end
        i += 1
    end

    print("line_length: ", line_length, "\n")
    print("line_count: ", line_count, "\n")
end

main()