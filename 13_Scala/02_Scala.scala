import scala.io.Source
import scala.collection.mutable.ArrayBuffer

object AdventOfCode {
    def main(args: Array[String]): Unit = {
        if (args.length < 1)
            return
        val source = Source.fromFile(args(0))
        var char_matrix: ArrayBuffer[String] = new ArrayBuffer()
        var sum: Int = 0
        for (line <- source.getLines()) {
            if (line != "") {
                char_matrix += line
            } else {
                sum += getNewReflection(char_matrix)
                char_matrix.clear()
            }
        }
        sum += getNewReflection(char_matrix)
        println(sum)
        source.close()
    }

    def getReflectionVertical(
        matrix: ArrayBuffer[String],
        ignore: Int
    ): (Int, Int) = {
        var transposed_matrix: ArrayBuffer[String] = new ArrayBuffer()
        for (i <- 0 to matrix(0).length - 1) {
            var byte_char_array: Array[Char] = Array();
            for (j <- 0 to matrix.length - 1) {
                byte_char_array =
                    byte_char_array ++ Array(matrix(j).toCharArray()(i))
            }
            transposed_matrix += new String(byte_char_array)
        }
        return getReflectionHorizontal(transposed_matrix, 1, ignore)
    }

    def getReflectionHorizontal(
        matrix: ArrayBuffer[String],
        multiplier: Int = 100,
        ignore: Int
    ): (Int, Int) = {
        for (i <- 0 to matrix.length - 2) {
            if (matrix(i) == matrix(i + 1)) {
                var to_compare: Int =
                    Math.min(i + 1, matrix.length - i - 1)
                var all_equal: Boolean = true
                while (all_equal && to_compare > 0) {
                    all_equal = (matrix(
                      i + to_compare
                    ) == matrix(i - to_compare + 1))
                    to_compare -= 1
                }
                if (all_equal && i != ignore) {
                    println(s"Found reflexion at line/col [$i]")
                    return (multiplier * (i + 1), i)
                }
            }
        }
        return (-1, -1)
    }

    def getNewReflection(matrix: ArrayBuffer[String]): (Int) = {
        var base_value: Int = -1
        var base_row: Int = -1
        var base_column: Int = -1
        val (temp_base_value_hor, temp_row) =
            getReflectionHorizontal(matrix = matrix, ignore = -1)
        base_value = temp_base_value_hor
        base_row = temp_row
        if (base_value == -1) {
            var (temp_base_value_ver, temp_column) = getReflectionVertical(
              matrix = matrix,
              ignore = -1
            )
            base_value = temp_base_value_ver
            base_column = temp_column
        }
        println(s"base value $base_value base col $base_column base row $base_row")

        var new_value: Int = base_value
        var new_colum: Int = base_column
        var new_row: Int = base_row

        for (i <- 0 to matrix.length - 1) {
            for (j <- 0 to matrix(i).length - 1) {
                var matrix_cpy: ArrayBuffer[String] = matrix.clone()
                var original_string: String = matrix(i)
                var new_string: String = ""

                if (original_string.charAt(j) == '#') {
                    new_string = original_string.updated(j, '.')
                } else {
                    new_string = original_string.updated(j, '#')
                }

                matrix_cpy(i) = new_string
                

                var (temp_new_value_hor, temp_new_row) =
                    getReflectionHorizontal(
                      matrix = matrix_cpy,
                      ignore = base_row
                    )
                new_value = temp_new_value_hor
                if (new_value != -1) {
                    return new_value
                }

                var (temp_new_value_ver, temp_new_col) = getReflectionVertical(
                  matrix = matrix_cpy,
                  ignore = base_column
                )
                new_value = temp_new_value_ver
                if (new_value != -1) {
                    return new_value
                }
                new_value = base_value
            }
        }
        return base_value
    }
}
