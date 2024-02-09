const std = @import("std");

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut();

pub fn main() !void {
    const args = try std.process.argsAlloc(allocator);

    if (args.len != 2) {
        try stdout.writer().print("Usage {s} <inputfile>\n", .{args[0]});
        return;
    }

    var list = std.ArrayList([]i32).init(allocator);
    try readParseFile(args[1], &list);
    var sumOfExtrapolated: i64 = 0;

    for (list.items) |value| {
        sumOfExtrapolated += try calculateSumOfExtrapolatedArray(value);
    }
    try stdout.writer().print("{d}\n", .{sumOfExtrapolated});
}

fn readParseFile(file_path: []const u8, list: *std.ArrayList([]i32)) !void {
    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close(); // This willl execute last
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.split(u8, line, " ");
        var numArray: []i32 = try allocator.alloc(i32, 1);
        var i: u8 = 0;
        while (it.next()) |num| {
            i += 1;
            numArray = try allocator.realloc(numArray, i);
            const numInt = try std.fmt.parseInt(i32, num, 10);
            numArray[i - 1] = numInt;
        }
        try list.append(numArray);
    }
}

fn calculateSumOfExtrapolatedArray(initial_arr: []i32) !i32 {
    var sequences = std.ArrayList([]i32).init(allocator);
    var all_zeroes: bool = false;
    var current_sequence: []i32 = initial_arr;
    try sequences.append(current_sequence);
    while (!all_zeroes) {
        all_zeroes = true;
        var sequence: []i32 = try allocator.alloc(i32, (current_sequence.len - 1));
        for (0..current_sequence.len - 1) |j| {
            sequence[j] = current_sequence[j + 1] - current_sequence[j];
            if (current_sequence[j + 1] - current_sequence[j] != 0) {
                all_zeroes = all_zeroes and false;
            }
        }
        try sequences.append(sequence);
        current_sequence = sequence;
    }

    _ = sequences.popOrNull();
    var last_result: i32 = 0;

    while (sequences.popOrNull()) |seq| {
        last_result = seq[0] - last_result;
    }
    return last_result;
}
