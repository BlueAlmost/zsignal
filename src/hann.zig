const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

const pi = math.pi;

pub fn hann(x: anytype) void {
    const T = @TypeOf(x);
    comptime var T_elem = ElementType(T);

    var L: usize = x.len;
    var Nf: T_elem = @intToFloat(T_elem, L - 1);

    var i: usize = 0;
    while (i < L) : (i += 1) {
        x[i] = 0.5 * (1.0 - @cos(2 * pi * @intToFloat(T_elem, i) / Nf));
    }
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;

test "\t hann window \t  even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_even);

        hann(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.3454915028), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.9045085972), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.9045085972), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.3454915028), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[5], eps);
    }
}

test "\t hann window \t  odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_odd);

        hann(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.25), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.75), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.75), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.25), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[6], eps);
    }
}
