const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

pub const pi = math.pi;

pub fn blackman(x: anytype) void {
    const T = @TypeOf(x);
    comptime var T_elem = ElementType(T);

    var L: usize = x.len;
    var M: usize = undefined;

    if (@mod(x.len, 2) == 0) {
        M = L / 2;
    } else {
        M = (L - 1) / 2;
        x[M] = 1.0;
    }

    var tmp1: T_elem = undefined;
    var tmp2: T_elem = undefined;

    var i: usize = 0;
    while (i < M) : (i += 1) {
        tmp1 = 2 * pi * @intToFloat(T_elem, i) / @intToFloat(T_elem, L - 1);
        tmp2 = 0.42 - 0.5 * @cos(tmp1) + 0.08 * @cos(2 * tmp1);
        x[i] = tmp2;
        x[L - 1 - i] = tmp2;
    }
    x[0] = 0.0;
    x[L - 1] = 0.0;
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;

test "\t blackman window \t  even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_even);

        blackman(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.200770143), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.849229856), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.849229856), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.200770143), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[5], eps);
    }
}

test "\t blackman window \t  odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_odd);

        blackman(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.13), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.63), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.63), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.13), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[6], eps);
    }
}
