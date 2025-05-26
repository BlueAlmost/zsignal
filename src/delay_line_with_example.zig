//
// An efficient delay line useful for various filtering and audio processing
// applications.
//

const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

pub fn roundPow2(comptime T: type, val: T) T {
    // round to the next highest power of two

    // The function roundPow2 is based on a function found in:
    // https://graphics.stanford.edu/~seander/bithacks.html
    // which is released under public domain.
    //
    // Also inspired by https//github.com/cyptocode/bithacks collection
    // for zig which is also released under public domain.
    //
    // This version has enhancements for comptime code generation 
    // and is similarly releaseed under public domain.
    
    comptime assert(@typeInfo(T) == .int);    
    comptime assert(@typeInfo(T).int.signedness == .unsigned );    

    const n_bits = @bitSizeOf(T);

    var v = val-%1;
    comptime var pw: T = 1;

    inline for (0..n_bits)|_| {
        v |= v >> pw;
        pw = pw*2;
        if(pw == n_bits/2){
            break;
        }
    }
    v +%= 1;
    // For consistency with 'roundToPow2ByFloat', 0 => 1
    v +%= @intFromBool(v==0);
    return v;
}

pub fn DelayLine(comptime T: type) type {
    return struct {
        const Self = @This();
        len:    usize,
        mask:   usize,
        head:   usize,
        line:   []T,

        pub fn init(allocator: Allocator, min_len: usize) !Self {

            const len = roundPow2(usize, min_len);
            const mask = len-1;
            const line = try allocator.alloc(T, len);

            for(line) |*item| {
                item.* = 0;
            }

            return Self{
                .len = len,
                .mask = mask,
                .head = len-1,
                .line = line,
            };
        }

        pub fn write(self: *Self, val: T) void {

            // print("head: on entry: {d}\t", .{self.head});
            self.head +=1;
            self.head = self.head & self.mask;
            // print(", on write: {d}\n", .{self.head});
            self.line[self.head] = val;
        }

        pub fn read(self: *Self, delay: usize) T {
            return self.line[(self.head-%delay) & self.mask];
        }
    };
}

pub fn main() !void {

    const T = i64;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var D = try DelayLine(T).init(allocator, 12);

    var i: T = 1;
    print("D.line: {any}\n", .{D.line});
    print("----------------------------------------------\n", .{});

    while(i<20):(i+=1) {
        D.write(i);
        print("\ni: {d}, D.line: {any}\n", .{i, D.line});
        print("delay 0: {d}\n", .{D.read(0)});
        print("delay 1: {d}\n", .{D.read(1)});
        print("delay 32: {d}\n", .{D.read(7)});
    }
}

