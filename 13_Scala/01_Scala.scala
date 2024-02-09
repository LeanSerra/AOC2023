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
                sum += getReflexion(char_matrix)
                char_matrix.clear()
            }
        }
        sum += getReflexion(char_matrix)
        println(sum)
        source.close()
    }

    def getReflexion(matrix: ArrayBuffer[String]): Int = {
        var row_sum: Int = 0
        var column_sum: Int = 0
        for (i <- 0 to matrix.length - 2) {
            if (matrix(i) == matrix(i + 1)) {
                var to_compare: Int = Math.min(i + 1, matrix.length - i - 1)
                var all_equal: Boolean = true
                while (all_equal && to_compare > 0) {
                    all_equal =
                        (matrix(i + to_compare) == matrix(i - to_compare + 1))
                    to_compare -= 1
                }
                if (all_equal) {
                    row_sum += 100 * (i + 1)
                }
            }
        }

        var transposed_matrix: ArrayBuffer[String] = new ArrayBuffer()

        for (i <- 0 to matrix(0).length - 1) {
            var byte_char_array: Array[Char] = Array();
            for (j <- 0 to matrix.length - 1) {
                byte_char_array =
                    byte_char_array ++ Array(matrix(j).toCharArray()(i))
            }
            transposed_matrix += new String(byte_char_array)
        }

        for (i <- 0 to transposed_matrix.length - 2) {
            if (transposed_matrix(i) == transposed_matrix(i + 1)) {
                var to_compare: Int =
                    Math.min(i + 1, transposed_matrix.length - i - 1)
                var all_equal: Boolean = true
                while (all_equal && to_compare > 0) {
                    all_equal = (transposed_matrix(
                      i + to_compare
                    ) == transposed_matrix(i - to_compare + 1))
                    to_compare -= 1
                }
                if (all_equal) {
                    row_sum += (i + 1)
                }
            }
        }
        return row_sum + column_sum
    }
}
