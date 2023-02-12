const std = @import("std");
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

const pi = math.pi;

pub fn blackmanharris(x: anytype) void {
    const T = @TypeOf(x);
    comptime var T_elem = ElementType(T);

    var L: usize = x.len;

    const a0: T_elem = 0.35875;
    const a1: T_elem = 0.48829;
    const a2: T_elem = 0.14128;
    const a3: T_elem = 0.01168;
    var Lm1: T_elem = @intToFloat(T_elem, L - 1);
    var tmp: T_elem = undefined;

    var i: usize = 0;
    while (i < L) : (i += 1) {
        tmp = 2 * pi * @intToFloat(T_elem, i) / Lm1;
        x[i] = a0 - a1 * @cos(tmp) + a2 * @cos(2 * tmp) - a3 * @cos(3 * tmp);
    }
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;

test "\t blackmanharris window \t  even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_even);

        blackmanharris(x);

        try std.testing.expectApproxEqAbs(@as(T, 6.0e-5), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.10301149), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.7938335), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.7938335), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.10301149), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 6.0e-5), x[5], eps);
    }
}

test "\t blackmanharris window \t  odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_odd);

        blackmanharris(x);

        try std.testing.expectApproxEqAbs(@as(T, 6.0e-5), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.055645), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.520575), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.520575), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.055645), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 6.0e-5), x[6], eps);
    }
}

