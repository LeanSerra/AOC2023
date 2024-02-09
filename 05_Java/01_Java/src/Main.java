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
        InputFile.readFile("input", seeds, seed_to_soil, soil_to_fertilizer, fertilizer_to_water, water_to_light,
                light_to_temperature, temperature_to_humidity, humidity_to_location);
        LinkedList<Long> mappings = new LinkedList<Long>();

        for (long seed : seeds) {
            long mapping = seed;
            //System.out.printf("Seed: %d\n", mapping);
            mapping = Map.mapSourceToDestination(seed_to_soil, mapping);
            //System.out.printf("Seed to Soil: %d\n", mapping);
            mapping = Map.mapSourceToDestination(soil_to_fertilizer, mapping);
            //System.out.printf("Soil to Fert: %d\n", mapping);
            mapping = Map.mapSourceToDestination(fertilizer_to_water, mapping);
            //System.out.printf("Fert to Water: %d\n", mapping);
            mapping = Map.mapSourceToDestination(water_to_light, mapping);
            //System.out.printf("Water to Light: %d\n", mapping);
            mapping = Map.mapSourceToDestination(light_to_temperature, mapping);
            //System.out.printf("Light to Temp: %d\n", mapping);
            mapping = Map.mapSourceToDestination(temperature_to_humidity, mapping);
            //System.out.printf("Temp to Hum: %d\n", mapping);
            mapping = Map.mapSourceToDestination(humidity_to_location, mapping);
            //System.out.printf("Hum to Location: %d\n", mapping);
            mappings.add(mapping);
        }

        long lowest_location = Long.MAX_VALUE;
        for (long mapping : mappings) {
            if (mapping < lowest_location) {
                lowest_location = mapping;
            }
        }
        System.out.println(lowest_location);
    }
}
