def main
    if ARGV.empty?
        puts "Usage: #{File.basename(__FILE__)} <input-file>"
        exit
    end
    raw_line = File.open(ARGV[0], 'r').read

    string_array = raw_line.split(',')

    hash_sum = 0

    string_array.each do |string|
        hash_sum += get_aoc_hash(string)
    end

    puts hash_sum
end

def get_aoc_hash(str)
    hash = 0
    str.split('').each do |char|
        hash += char.ord
        hash *= 17
        hash %= 256
    end
    hash
end

main
