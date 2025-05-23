const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

const pi = math.pi;

pub fn hamming(x: anytype) void {
    const T = @TypeOf(x);
    const T_elem = ElementType(T);

    const L: usize = x.len;
    const Nf: T_elem = @as(T_elem, @floatFromInt(L - 1));

    var i: usize = 0;
    while (i < L) : (i += 1) {
        x[i] = 0.54 - 0.46 * @cos(2 * pi * @as(T_elem, @floatFromInt(i)) / Nf);
    }
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;

test "\t hamming window \t  even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_even);

        hamming(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.08), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.3978521825), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.9121478141), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.9121478141), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.3978521825), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.08), x[5], eps);
    }
}

test "\t hamming window \t  odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_odd);

        hamming(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.08), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.31), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.77), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.77), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.31), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.08), x[6], eps);
    }
}
