#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>

#define INIT_CAP 5

typedef struct
{
    char n;
    int row;
    int column;
} number_pos;

typedef struct
{
    number_pos **numbers;
    size_t count;
    size_t capacity;
} str_number;

void append_num(str_number *str_num, number_pos *num);
void show_number(str_number str_num);
int str_number_to_int(str_number str_num);
bool valid_char(char c);
bool valid_str_number(str_number num, char **lines, size_t line_count, size_t line_length);

int main(int argc, char const *argv[])
{
    if (argc < 2)
    {
        printf("Usage: %s <input file>\n", argv[0]);
        return -1;
    }

    FILE *input_file = fopen(argv[1], "r");

    if (input_file == NULL)
    {
        return -1;
    }

    char *line = (char *)malloc(150 * sizeof(char));
    char **lines = (char **)malloc(140 * sizeof(char *));

    int count = 0;
    while (fscanf(input_file, "%s", line) == 1)
    {
        lines[count] = malloc((strlen(line) + 1) * sizeof(char));
        strcpy(lines[count], line);
        count++;
    }

    unsigned int final_count = 0;

    for (int i = 0; i < count; i++)
    {
        size_t line_length = strlen(lines[i]);
        str_number number = {NULL, 0, 0};
        for (int j = 0; j < line_length; j++)
        {
            if ((char)lines[i][j] >= '0' && (char)lines[i][j] <= '9')
            {
                number_pos *num = malloc(sizeof(number_pos));
                num->n = lines[i][j];
                num->row = i;
                num->column = j;
                append_num(&number, num);
            }
            if (j + 1 < line_length && number.count > 0)
            {
                if ((char)lines[i][j + 1] < '0' || (char)lines[i][j + 1] > '9')
                {
                    if (valid_str_number(number, lines, count, line_length))
                    {
                        final_count += str_number_to_int(number);
                    }
                    
                    str_number n = {NULL, 0, 0};
                    number = n;
                }
            }
            else if (j + 1 == line_length && number.count > 0)
            {
                if (valid_str_number(number, lines, count, line_length))
                {
                    final_count += str_number_to_int(number);
                }
                str_number n = {NULL, 0, 0};
                number = n;
            }
        }
    }
    printf("%d\n", final_count);
    fclose(input_file);
}

void append_num(str_number *str_num, number_pos *num)
{
    if (str_num->count >= str_num->capacity)
    {
        str_num->capacity = str_num->capacity == 0 ? INIT_CAP : str_num->capacity * 2;
        str_num->numbers = realloc(str_num->numbers, str_num->capacity * sizeof(*str_num->numbers));
        assert(str_num->numbers != NULL && "Not enough memory");
    }
    str_num->numbers[str_num->count++] = num;
}

void show_number(str_number str_num)
{
    for (int i = 0; i < str_num.count; i++)
    {
        printf("%c", (int)str_num.numbers[i]->n);
    }
    printf("\t");
}

int str_number_to_int(str_number str_num)
{
    char *int_str = malloc((str_num.count + 1) * sizeof(char));
    int i;
    for (i = 0; i < str_num.count; i++)
    {
        int_str[i] = str_num.numbers[i]->n;
    }
    int_str[i + 1] = '\0';
    return atoi(int_str);
}

bool valid_str_number(str_number num, char **lines, size_t line_count, size_t line_length)
{
    bool valid = false;
    for (int i = 0; i < num.count; i++)
    {
        number_pos *digit = num.numbers[i];

        if (i == 0)
        {
            // #..
            // #1.
            // #..
            if (digit->column - 1 >= 0)
            {
                if (digit->row - 1 >= 0)
                {
                    char top_left_char = lines[digit->row - 1][digit->column - 1];
                    if (valid_char(top_left_char))
                    {
                        valid = true;
                        break;
                    }
                }
                if (digit->row + 1 < line_count)
                {
                    char bottom_left_char = lines[digit->row + 1][digit->column - 1];
                    if (valid_char(bottom_left_char))
                    {
                        valid = true;
                        break;
                    }
                }
                char left_char = lines[digit->row][digit->column - 1];
                valid = valid_char(left_char);
                if (valid_char(left_char))
                {
                    valid = true;
                    break;
                }
            }
        }
        if (i == num.count - 1)
        {
            //..#
            //.1#
            //..#
            if (digit->column + 1 < line_length)
            {
                if (digit->row - 1 >= 0)
                {
                    char top_right_char = lines[digit->row - 1][digit->column + 1];
                    if (valid_char(top_right_char))
                    {
                        valid = true;
                        break;
                    }
                }
                if (digit->row + 1 < line_count)
                {
                    char bottom_right_char = lines[digit->row + 1][digit->column + 1];
                    if (valid_char(bottom_right_char))
                    {
                        valid = true;
                        break;
                    }
                }
                char right_char = lines[digit->row][digit->column + 1];
                if (valid_char(right_char))
                {
                    valid = true;
                    break;
                }
            }
        }
        //.#.
        //.1.
        //.#.
        if (digit->row - 1 >= 0)
        {
            char top_char = lines[digit->row - 1][digit->column];
            if (valid_char(top_char))
            {
                valid = true;
                break;
            }
        }
        if (digit->row + 1 < line_count)
        {
            char bottom_char = lines[digit->row + 1][digit->column];
            if (valid_char(bottom_char))
            {
                valid = true;
                break;
            }
        }
    }
    return valid;
}

bool valid_char(char c)
{
    return (c != '.' && (c < '0' || c > '9'));
}