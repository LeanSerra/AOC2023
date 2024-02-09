using System.Numerics;

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
            HashSet<BigInteger[]> edgeCords = new HashSet<BigInteger[]>();

            BigInteger boundryPoints = 0;
            BigInteger interiorPoints;

            ReadFile(args[0], edgeCords, ref boundryPoints);

            BigInteger area = ShoelaceArea(edgeCords);

            //Pick's theorem
            interiorPoints = area - (boundryPoints / 2) + 1;

            System.Console.WriteLine("{0} {1} {2}", boundryPoints, interiorPoints, boundryPoints + interiorPoints);
        }
    }

    static void ReadFile(String file_name, HashSet<BigInteger[]> plan, ref BigInteger boundryPoints)
    {
        var lines = File.ReadLines(file_name);
        int row = 0;
        int column = 0;

        foreach (var line in lines)
        {
            string raw_instructions = line.Split(' ')[2].Replace("(", string.Empty).Replace(")", string.Empty).Replace("#", string.Empty);
            int number_of_meters = Convert.ToInt32(raw_instructions.Substring(0, 5), 16);
            int direction = Convert.ToInt32(raw_instructions.Substring(5, 1), 16);
            switch (direction)
            {
                //R
                case 0:
                    column += number_of_meters;
                    break;
                //L
                case 2:
                    column -= number_of_meters;
                    break;
                //U
                case 3:
                    row -= number_of_meters;
                    break;
                //D
                case 1:
                    row += number_of_meters;
                    break;
                default:
                    System.Console.WriteLine("Unknown direction {0}", direction);
                    break;
            }
            boundryPoints += number_of_meters;
            plan.Add([column, row]);
        }
    }
    static BigInteger ShoelaceArea(HashSet<BigInteger[]> edges)
    {
        BigInteger previousColumn = 0;
        BigInteger previousRow = 0;
        BigInteger doubleArea = 0;
        foreach (var coords in edges)
        {
            doubleArea += (previousColumn * coords[1]) - (previousRow * coords[0]);
            previousColumn = coords[0];
            previousRow = coords[1];
        }
        doubleArea += (previousColumn * edges.First()[1]) - (previousRow * edges.First()[0]);
        return doubleArea / 2;
    }
}

