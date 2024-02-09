import java.util.LinkedList;

public abstract class Map {
    public static long mapSourceToDestination(LinkedList<long[]> ll, long source) {
        for(long[] ranges : ll) {
            long dest_start = ranges[0];
            long source_start = ranges[1];
            long range_length = ranges[2];
            if(source >= source_start && source < source_start + range_length) {
                return dest_start + source - source_start;
            }
        }
        return source;
    }
}
