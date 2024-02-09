import Foundation

func main() {
    let args = CommandLine.arguments

    if CommandLine.argc < 2 {
        print("Usage: ", args[0], " <input_file>")
        exit(1)
    } else {
        let char_matrix = load_initial_matrix(filename: args[1])

        let tilted_matrix: [[Character]] = tilt_north(char_matrix: char_matrix)

        var final_weight = 0

        for (i, char_arr) in tilted_matrix.enumerated() {
            for char in char_arr {
                print(char, terminator: "")
                if char == "O" {
                    final_weight += (i + 1)
                }
            }
            print()
        }

        print(final_weight)

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
    var transposed_tilted_matrix:[[Character]] = []

    for (i, char_arr) in transposed_matrix.enumerated() {
        transposed_tilted_matrix.append([])
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
                        transposed_tilted_matrix[i].append(".")
                    }
                }
                if boulder_count > 0 {
                    for _ in 0...boulder_count - 1 {
                        transposed_tilted_matrix[i].append("O")
                    }
                }
                transposed_tilted_matrix[i].append("#")
                boulder_count = 0
                empty_space_count = 0
            }
        }
        if empty_space_count > 0 {
            for _ in 0...empty_space_count - 1 {
                transposed_tilted_matrix[i].append(".")
            }
        }
        if boulder_count > 0 {
            for _ in 0...boulder_count - 1 {
                transposed_tilted_matrix[i].append("O")
            }
        }
    }

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

main()
