import Foundation

func main() {
    let args = CommandLine.arguments

    if CommandLine.argc < 2 {
        print("Usage: ", args[0], " <input_file>")
        exit(1)
    } else {
        let char_matrix: [[Character]] = load_initial_matrix(filename: args[1])

        var tilted_matrix: [[Character]] = char_matrix

        var tilted_hashes: [Int] = []
        var tilted_load: [Int] = []
        var first_index_of_loop: Int = 0
        var last_index_of_loop: Int = 0

        for i in 0...1_000_000_000 {
            tilted_matrix = spin_cycle(source_matrix: tilted_matrix)
            let hash_value = tilted_matrix.hashValue
            if tilted_hashes.contains(hash_value) {
                if let first_index = tilted_hashes.firstIndex(of: hash_value) {
                    print("Found collision at ", i, " hash_value of ", hash_value)
                    print("Original happened at ", first_index)
                    first_index_of_loop = first_index
                    last_index_of_loop = i
                }
                break
            } else {
                print("Found new hash at ", i, " hash_value of ", hash_value)
                tilted_load.append(calculate_load(source_matrix: tilted_matrix))
                tilted_hashes.append(hash_value)
            }
        }

        print(
            "Load after 1000000000 cycles: ",
            tilted_load[
                (1_000_000_000 - first_index_of_loop) % (last_index_of_loop - first_index_of_loop)
                    + first_index_of_loop - 1])

    }
}

func load_initial_matrix(filename: String) -> [[Character]] {
    let contents = try! String(contentsOfFile: filename)
    let lines = contents.split(separator: "\n")

    var char_matrix: [[Character]] = []

    for (i, line) in lines.enumerated() {
        char_matrix.append([])
        for ch in line {
            char_matrix[i].append(ch)
        }
    }
    return char_matrix
}

func tilt_north(char_matrix: [[Character]]) -> [[Character]] {
    let transposed_matrix: [[Character]] = transpose_matrix(source_matrix: char_matrix)
    let transposed_tilted_matrix: [[Character]] = roll_left(source_matrix: transposed_matrix)
    return transpose_matrix(source_matrix: transposed_tilted_matrix)
}

func transpose_matrix(source_matrix: [[Character]]) -> [[Character]] {
    var transposed_matrix: [[Character]] = []
    for i in 0...source_matrix[0].count - 1 {
        var char_arr: [Character] = []
        for j in 0...source_matrix.count - 1 {
            char_arr.append(source_matrix[j][i])
        }
        transposed_matrix.append(char_arr)
    }
    return transposed_matrix
}

func rotate_180_vertical(source_matrix: [[Character]]) -> [[Character]] {
    var rotated_matrix: [[Character]] = []

    for char_arr in source_matrix.reversed() {
        rotated_matrix.append(char_arr)
    }
    return rotated_matrix
}

func show_matrix(source_matrix: [[Character]]) {
    for char_arr in source_matrix {
        for char in char_arr {
            print(char, terminator: "")
        }
        print()
    }
}

func roll_left(source_matrix: [[Character]]) -> [[Character]] {
    var result: [[Character]] = []
    for (i, char_arr) in source_matrix.enumerated() {
        result.append([])
        var boulder_count = 0
        var empty_space_count = 0
        for char in char_arr.reversed() {
            if char == "O" {
                boulder_count += 1
            }
            if char == "." {
                empty_space_count += 1
            }
            if char == "#" {
                if empty_space_count > 0 {
                    for _ in 0...empty_space_count - 1 {
                        result[i].append(".")
                    }
                }
                if boulder_count > 0 {
                    for _ in 0...boulder_count - 1 {
                        result[i].append("O")
                    }
                }
                result[i].append("#")
                boulder_count = 0
                empty_space_count = 0
            }
        }
        if empty_space_count > 0 {
            for _ in 0...empty_space_count - 1 {
                result[i].append(".")
            }
        }
        if boulder_count > 0 {
            for _ in 0...boulder_count - 1 {
                result[i].append("O")
            }
        }
    }
    return mirror_matrix(source_matrix: result)
}

func roll_right(source_matrix: [[Character]]) -> [[Character]] {
    var result: [[Character]] = []
    for (i, char_arr) in source_matrix.enumerated() {
        result.append([])
        var boulder_count = 0
        var empty_space_count = 0
        for char in char_arr {
            if char == "O" {
                boulder_count += 1
            }
            if char == "." {
                empty_space_count += 1
            }
            if char == "#" {
                if empty_space_count > 0 {
                    for _ in 0...empty_space_count - 1 {
                        result[i].append(".")
                    }
                }
                if boulder_count > 0 {
                    for _ in 0...boulder_count - 1 {
                        result[i].append("O")
                    }
                }
                result[i].append("#")
                boulder_count = 0
                empty_space_count = 0
            }
        }
        if empty_space_count > 0 {
            for _ in 0...empty_space_count - 1 {
                result[i].append(".")
            }
        }
        if boulder_count > 0 {
            for _ in 0...boulder_count - 1 {
                result[i].append("O")
            }
        }
    }
    return result
}

func mirror_matrix(source_matrix: [[Character]]) -> [[Character]] {
    var result: [[Character]] = []
    for (i, char_arr) in source_matrix.enumerated() {
        result.append([])
        for char in char_arr.reversed() {
            result[i].append(char)
        }
    }
    return result
}

func calculate_load(source_matrix: [[Character]]) -> Int {
    var final_weight = 0

    for (i, char_arr) in rotate_180_vertical(source_matrix: source_matrix).enumerated() {
        for char in char_arr {
            if char == "O" {
                final_weight += (i + 1)
            }
        }
    }
    return final_weight
}

func spin_cycle(source_matrix: [[Character]]) -> [[Character]] {
    //Tilting_north
    var tilted_matrix = tilt_north(char_matrix: source_matrix)
    //Tilting west
    tilted_matrix = roll_left(source_matrix: tilted_matrix)
    //Tilting south
    tilted_matrix = rotate_180_vertical(
        source_matrix: tilt_north(
            char_matrix: rotate_180_vertical(source_matrix: tilted_matrix)))
    // tilting east
    tilted_matrix = roll_right(source_matrix: tilted_matrix)
    return tilted_matrix
}

main()
