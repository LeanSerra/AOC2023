struct planPart
{
    public Boolean trench;
    public String color;

    public planPart(Boolean t, String color)
    {
        this.trench = t;
        this.color = color;
    }
}

class AdventOfCode
{
    static void Main(String[] args)
    {
        if (args.Length < 1)
        {
            System.Console.WriteLine("Usage: {0} <input-file>", System.AppDomain.CurrentDomain.FriendlyName);
            return;
        }
        else
        {
            Dictionary<Tuple<int, int>, planPart> digPlan = new Dictionary<Tuple<int, int>, planPart>();
            int maxColumn = 0;
            int minColumn = 0;
            int maxRow = 0;
            int minRow = 0;
            ReadFile(args[0], digPlan, ref maxColumn, ref minColumn, ref maxRow, ref minRow);
            System.Console.WriteLine("MaxColumn {0} MinColumn {1} MaxRow {2} MinRow {3}", maxColumn, minColumn, maxRow, minRow);
            for (int i = minColumn; i < maxColumn; i++)
            {
                for (int j = minRow; j < maxRow; j++)
                {
                    if (!digPlan.ContainsKey(new Tuple<int, int>(i, j)))
                    {
                        digPlan.Add(new Tuple<int, int>(i, j), new planPart(false, ""));
                    }
                }
            }

            for (int i = minColumn; i < maxColumn; i++) {
                if(digPlan[new Tuple<int,int>(i, minRow)].trench) {
                    System.Console.WriteLine("Flood fill from {0},{1}", i+1, minRow+1);
                    dig_interior(digPlan, i+1, minRow+1, maxColumn, minColumn, maxRow, minRow);
                    break;
                }
            }

            for (int i = minRow; i < maxRow; i++)
            {
                for (int j = minColumn; j < maxColumn; j++)
                {
                    if(digPlan[new Tuple<int, int>(j, i)].trench) {
                        System.Console.Write("#");
                    }
                    else {
                        System.Console.Write(".");
                    }
                }
                System.Console.WriteLine("");
            }

            int count = 0;
            foreach( var pPart in digPlan.Values) {
                if (pPart.trench) {
                    count+=1;
                }
            }
            System.Console.WriteLine("Count: {0}", count);
        }

    }

    static void ReadFile(String file_name, Dictionary<Tuple<int, int>, planPart> plan, ref int maxColumn, ref int minColumn, ref int maxRow, ref int minRow)
    {
        var lines = File.ReadLines(file_name);
        int row = 0;
        int column = 0;
        maxColumn = 0;
        minColumn = int.MaxValue;
        maxRow = 0;
        minRow = int.MaxValue;


        foreach (var line in lines)
        {
            char direction = line.Split(' ')[0][0];
            int number_of_meters = int.Parse(line.Split(' ')[1]);
            string color = line.Split(' ')[2].Replace("(", string.Empty).Replace(")", string.Empty);
            switch (direction)
            {
                case 'R':
                    while (number_of_meters > 0)
                    {
                        plan.Add(new Tuple<int, int>(column, row), new planPart(true, color));
                        number_of_meters -= 1;
                        column += 1;
                        if (column > maxColumn)
                        {
                            maxColumn = column;
                        }
                    }
                    break;
                case 'L':
                    while (number_of_meters > 0)
                    {
                        plan.Add(new Tuple<int, int>(column, row), new planPart(true, color));
                        number_of_meters -= 1;
                        column -= 1;
                        if (column < minColumn)
                        {
                            minColumn = column;
                        }
                    }
                    break;
                case 'U':
                    while (number_of_meters > 0)
                    {
                        plan.Add(new Tuple<int, int>(column, row), new planPart(true, color));
                        number_of_meters -= 1;
                        row -= 1;
                        if (row < minRow)
                        {
                            minRow = row;
                        }
                    }
                    break;
                case 'D':
                    while (number_of_meters > 0)
                    {
                        plan.Add(new Tuple<int, int>(column, row), new planPart(true, color));
                        number_of_meters -= 1;
                        row += 1;
                        if (row > maxRow)
                        {
                            maxRow = row;
                        }
                    }
                    break;
                default:
                    System.Console.WriteLine("Unknown direction {0}", direction);
                    break;
            }
        }
    }

    static void dig_interior(Dictionary<Tuple<int, int>, planPart> plan, int column, int row, int maxColumn, int minColumn, int maxRow, int minRow)
    {
        if (column >= maxColumn || column <= minColumn || row >= maxRow || row <= minRow) {
            return;
        }

        if (plan[new Tuple<int, int>(column, row)].trench) {
            return;
        }
        plan[new Tuple<int, int>(column, row)] = new planPart(true, "");
        dig_interior(plan, column+1,row, maxColumn, minColumn, maxRow, minRow);
        dig_interior(plan, column-1,row, maxColumn, minColumn, maxRow, minRow);
        dig_interior(plan, column,row+1, maxColumn, minColumn, maxRow, minRow);
        dig_interior(plan, column,row-1, maxColumn, minColumn, maxRow, minRow);
    }
}