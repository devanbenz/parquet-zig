const std = @import("std");
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
    @cInclude("parquet_schema_types.h");
});

const ArrayList = std.ArrayList;
const PAR1: []const u8 = "PAR1";

pub const ParquetReaderError = error{NotParquet};

pub const ParquetReader = struct {
    _metadata: c.FileMetaData,
    pub fn init(allocator: std.mem.Allocator, path: []const u8) !ParquetReader {
        const file = try std.fs.openFileAbsolute(path, .{});
        defer file.close();

        var list = ArrayList(u8).init(allocator);
        defer list.deinit();

        var buf = [4]u8{ 0, 0, 0, 0 };

        // Get magic at top of file
        try file.seekTo(0);

        const reader = file.reader();
        const sz = try reader.readAtLeast(buf[0..], buf.len);
        try std.testing.expect(sz == buf.len);

        if (!std.mem.eql(u8, &buf, PAR1)) {
            return error.NotParquet;
        }

        return ParquetReader{
            ._metadata = undefined,
        };
    }
};
