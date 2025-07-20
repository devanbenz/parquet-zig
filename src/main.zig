const std = @import("std");
const parquet_zig = @import("parquet_zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const reader = try parquet_zig.ParquetReader.init(allocator, "/Users/devan/Documents/Projects/parquet-zig/mtcars.parquet");
    _ = reader;
}
