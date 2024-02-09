import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.LinkedList;
import java.util.Scanner;

public abstract class InputFile {
    public static void readFile(String file_name, LinkedList<Long> seeds, LinkedList<long[]> seed_to_soil,
            LinkedList<long[]> soil_to_fertilizer, LinkedList<long[]> fertilizer_to_water,
            LinkedList<long[]> water_to_light, LinkedList<long[]> light_to_temperature,
            LinkedList<long[]> temperature_to_humidity, LinkedList<long[]> humidity_to_location) throws IOException {

        File file = new File(file_name);
        Scanner scanner = new Scanner(file, StandardCharsets.UTF_8);

        int mode = 0;

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();

            if (line != "") {
                if (!line.contains(":")) {
                    switch (mode) {
                        case 1:
                            parseNumberLine(line, seed_to_soil);
                            break;
                        case 2:
                            parseNumberLine(line, soil_to_fertilizer);
                            break;
                        case 3:
                            parseNumberLine(line, fertilizer_to_water);
                            break;
                        case 4:
                            parseNumberLine(line, water_to_light);
                            break;
                        case 5:
                            parseNumberLine(line, light_to_temperature);
                            break;
                        case 6:
                            parseNumberLine(line, temperature_to_humidity);
                            break;
                        case 7:
                            parseNumberLine(line, humidity_to_location);
                            break;
                        default:
                            break;
                    }
                } else if (mode == 0) {
                    parseSeeds(line, seeds);
                }
            } else {
                mode += 1;
            }

        }
        scanner.close();
    }

    private static void parseNumberLine(String line, LinkedList<long[]> ll) {
        line = line.strip();
        long[] numbers = new long[3];
        int i = 0;
        for (String num : line.split(" ")) {
            numbers[i] = Long.parseLong(num.strip());
            i++;
        }
        ll.add(numbers);
    }

    private static void parseSeeds(String line, LinkedList<Long> ll) {
        line = line.replace("seeds: ", "");
        for (String num : line.split(" ")) {
            ll.add(Long.parseLong(num.strip()));
        }
    }
}
