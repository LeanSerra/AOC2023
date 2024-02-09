class Box
    attr_reader :hash_map, :box_id

    def initialize(box_id)
        @box_id = box_id
        @hash_map = {}
    end

    def add_lens(key, value)
        @hash_map[key] = value
    end

    def substract_lens(key)
        @hash_map.delete(key)
    end

    def calculate_box_focusing_power
        focusing_sum = 0
        @hash_map.each_with_index do |(_key, value), index|
            focusing_sum += (@box_id + 1) * (index + 1) * value
        end
        focusing_sum
    end
end

def main
    if ARGV.empty?
        puts "Usage: #{File.basename(__FILE__)} <input-file>"
        exit
    end
    raw_line = File.open(ARGV[0], 'r').read

    string_array = raw_line.split(',')

    final_focusing_sum = 0

    box_arr = []

    256.times do |i|
        box_arr.append(Box.new(i))
    end

    string_array.each do |string|
        box_initialization(string, box_arr)
    end

    box_arr.each do |box|
        final_focusing_sum += box.calculate_box_focusing_power
    end

    puts final_focusing_sum
end

def box_initialization(str, box_array)
    hash = 0
    equals_flag = false
    lens_number = nil
    str.split('').each do |char|
        break if ['-'].include?(char)

        lens_number = Integer(char) if equals_flag
        equals_flag = true if char == '='
        next if equals_flag

        hash += char.ord
        hash *= 17
        hash %= 256
    end
    if equals_flag
        puts "Box #{hash} adding lens_name #{str.split('=')[0]} lens_number #{lens_number} "
        box_array[hash].add_lens(str.split('=')[0], lens_number)
    else
        puts "Box #{hash} removing lens_name #{str.split('-')[0]}"
        box_array[hash].substract_lens(str.split('-')[0])
    end
end

main
