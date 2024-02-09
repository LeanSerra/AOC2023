import java.util.LinkedList;

public class Main {
    private static LinkedList<Long> seeds = new LinkedList<Long>();
    private static LinkedList<long[]> seed_to_soil = new LinkedList<long[]>();
    private static LinkedList<long[]> soil_to_fertilizer = new LinkedList<long[]>();
    private static LinkedList<long[]> fertilizer_to_water = new LinkedList<long[]>();
    private static LinkedList<long[]> water_to_light = new LinkedList<long[]>();
    private static LinkedList<long[]> light_to_temperature = new LinkedList<long[]>();
    private static LinkedList<long[]> temperature_to_humidity = new LinkedList<long[]>();
    private static LinkedList<long[]> humidity_to_location = new LinkedList<long[]>();

    public static void main(String[] args) throws Exception {
        InputFile.readFile(args[0], seeds, seed_to_soil, soil_to_fertilizer, fertilizer_to_water, water_to_light,
                light_to_temperature, temperature_to_humidity, humidity_to_location);

        long lowest_location = Long.MAX_VALUE;
        for (int i = 0; i < seeds.size(); i += 2) {
            for (long j = seeds.get(i); j < seeds.get(i) + seeds.get(i + 1); j++) {
                long mapping = j;
                mapping = Map.mapSourceToDestination(seed_to_soil, mapping);
                mapping = Map.mapSourceToDestination(soil_to_fertilizer, mapping);
                mapping = Map.mapSourceToDestination(fertilizer_to_water, mapping);
                mapping = Map.mapSourceToDestination(water_to_light, mapping);
                mapping = Map.mapSourceToDestination(light_to_temperature, mapping);
                mapping = Map.mapSourceToDestination(temperature_to_humidity, mapping);
                mapping = Map.mapSourceToDestination(humidity_to_location, mapping);
                System.out.println(String.format("location; %d", mapping));
                if (mapping < lowest_location) {
                    lowest_location = mapping;
                }
            }
            System.out.println(String.format("Handled range %d %d", seeds.get(i), seeds.get(i+1)));
        }
        System.out.println(lowest_location);
    }
}
