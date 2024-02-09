import std/os
import std/strutils
import std/enumerate

type rayDirection = enum dUp, dDown, dRight, dLeft

proc cast_rays(
            matrix: seq[seq[char]], 
            casted_matrix: ref seq[ref seq[char]],
            splitted_matrix: ref seq[ref seq[int]],
            direction: rayDirection, 
            column: int,
            line: int,
            line_lenght: int, 
            line_count:int
    )

proc count_energized(matrix: ref seq[ref seq[char]]): int

proc main() =
    if paramCount() == 0:
        echo "Usage ", split(getAppFilename(), "/")[^1], " <input_file>"
        quit()
    else:

        var matrix: seq[seq[char]] = newSeq[seq[char]]()

        for line in lines paramStr(1):
            matrix.add(newSeq[char]())
            for ch in line:
                matrix[^1].add(ch)
        
        var max_energized: int = 0

        for i in 0..len matrix[0]:
            var casted_matrix_ref: ref seq[ref seq[char]] = new seq[ref seq[char]]
            var splitted_matrix_ref: ref seq[ref seq[int]] = new seq[ref seq[int]]

            for j, char_array in enumerate(matrix):
                casted_matrix_ref[].add(new seq[char])
                splitted_matrix_ref[].add(new seq[int])
                for ch in char_array:
                    casted_matrix_ref[][j][].add(ch)
                    splitted_matrix_ref[][j][].add(0)
            
            cast_rays(matrix, 
                    casted_matrix_ref, 
                    splitted_matrix_ref, 
                    rayDirection.dDown, 
                    i,
                    0, 
                    len matrix[0], 
                    len matrix)

            var curr_energized = count_energized(casted_matrix_ref)
            if curr_energized > max_energized:
                max_energized = curr_energized

        for i in 0..len matrix[0]:
            var casted_matrix_ref: ref seq[ref seq[char]] = new seq[ref seq[char]]
            var splitted_matrix_ref: ref seq[ref seq[int]] = new seq[ref seq[int]]

            for j, char_array in enumerate(matrix):
                casted_matrix_ref[].add(new seq[char])
                splitted_matrix_ref[].add(new seq[int])
                for ch in char_array:
                    casted_matrix_ref[][j][].add(ch)
                    splitted_matrix_ref[][j][].add(0)
            
            cast_rays(matrix, 
                    casted_matrix_ref, 
                    splitted_matrix_ref, 
                    rayDirection.dUp, 
                    i,
                    (len matrix) - 1, 
                    len matrix[0], 
                    len matrix)
            
            var curr_energized = count_energized(casted_matrix_ref)

            if curr_energized > max_energized:
                max_energized = curr_energized
        
        for i in 0..len matrix:
            var casted_matrix_ref: ref seq[ref seq[char]] = new seq[ref seq[char]]
            var splitted_matrix_ref: ref seq[ref seq[int]] = new seq[ref seq[int]]

            for j, char_array in enumerate(matrix):
                casted_matrix_ref[].add(new seq[char])
                splitted_matrix_ref[].add(new seq[int])
                for ch in char_array:
                    casted_matrix_ref[][j][].add(ch)
                    splitted_matrix_ref[][j][].add(0)
            
            cast_rays(matrix, 
                    casted_matrix_ref, 
                    splitted_matrix_ref, 
                    rayDirection.dRight, 
                    0,
                    i, 
                    len matrix[0], 
                    len matrix)

            var curr_energized = count_energized(casted_matrix_ref)

            if curr_energized > max_energized:
                max_energized = curr_energized
        
        for i in 0..len matrix:
            var casted_matrix_ref: ref seq[ref seq[char]] = new seq[ref seq[char]]
            var splitted_matrix_ref: ref seq[ref seq[int]] = new seq[ref seq[int]]

            for j, char_array in enumerate(matrix):
                casted_matrix_ref[].add(new seq[char])
                splitted_matrix_ref[].add(new seq[int])
                for ch in char_array:
                    casted_matrix_ref[][j][].add(ch)
                    splitted_matrix_ref[][j][].add(0)
            
            cast_rays(matrix, 
                    casted_matrix_ref, 
                    splitted_matrix_ref, 
                    rayDirection.dLeft, 
                    (len matrix[0]) - 1,
                    i, 
                    len matrix[0], 
                    len matrix)

            var curr_energized = count_energized(casted_matrix_ref)

            if curr_energized > max_energized:
                max_energized = curr_energized
        
        echo "Max energized count: ", max_energized

proc cast_rays(
            matrix: seq[seq[char]], 
            casted_matrix: ref seq[ref seq[char]],
            splitted_matrix: ref seq[ref seq[int]],
            direction: rayDirection, 
            column: int,
            line: int,
            line_lenght: int, 
            line_count:int
    ) = 
    if line >= line_count or column >= line_lenght or line < 0 or column < 0:
        return
    
    var curr_dir: rayDirection = direction
    var curr_column: int = column
    var curr_line: int = line

    while (curr_line <= line_count - 1 and curr_column <= line_lenght - 1 and curr_line >= 0 and curr_column >= 0) :
        casted_matrix[][curr_line][][curr_column] = '#'
        case matrix[curr_line][curr_column]
        of '-':
            case curr_dir
            of dRight:
                curr_column += 1
            of dLeft:
                curr_column -= 1
            of dUp, dDown:
                if splitted_matrix[][curr_line][][curr_column] == 0:
                    splitted_matrix[][curr_line][][curr_column] = 1
                    cast_rays(matrix, casted_matrix, splitted_matrix, dLeft, curr_column-1, curr_line, line_lenght, line_count)
                    cast_rays(matrix, casted_matrix, splitted_matrix, dRight, curr_column+1, curr_line, line_lenght, line_count)
                return
        of '\\':
            case curr_dir
            of dRight:
                curr_dir = dDown
                curr_line += 1
            of dLeft:
                curr_dir = dUp
                curr_line -= 1
            of dUp:
                curr_dir = dleft
                curr_column -= 1
            of dDown:
                curr_dir = dRight
                curr_column += 1
        of '|':
            case curr_dir
            of dRight, dleft:
                if splitted_matrix[][curr_line][][curr_column] == 0:
                    splitted_matrix[][curr_line][][curr_column] = 1
                    cast_rays(matrix, casted_matrix, splitted_matrix, dUp, curr_column, curr_line-1, line_lenght, line_count)
                    cast_rays(matrix, casted_matrix, splitted_matrix, dDown, curr_column, curr_line+1, line_lenght, line_count)
                return
            of dUp:
                curr_line -= 1
            of dDown:
                curr_line += 1
        of '/':
            case curr_dir
            of dRight:
                curr_line -= 1
                curr_dir = dUp
            of dLeft:
                curr_line += 1
                curr_dir = dDown
            of dUp:
                curr_column += 1
                curr_dir = dRight
            of dDown:
                curr_column -= 1
                curr_dir = dLeft
        of '.':
            case curr_dir
            of dRight:
                curr_column += 1
            of dLeft:
                curr_column -= 1
            of dUp:
                curr_line -= 1
            of dDown:
                curr_line += 1
        else:
            echo "Unknown char in matrix"
    return

proc count_energized(matrix: ref seq[ref seq[char]]): int =
    var count: int = 0
    for char_array in matrix[]:
        for ch in char_array[]:
            if ch == '#':
                count += 1
    return count

main()
