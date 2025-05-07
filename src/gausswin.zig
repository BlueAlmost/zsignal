const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

const pi = math.pi;

pub fn gausswin(x: anytype, alpha: anytype) void {
    const T = @TypeOf(x);
    const T_elem = ElementType(T);

    if ((@TypeOf(alpha) != T_elem) and (@TypeOf(alpha) != comptime_float)) {
        @compileError("alpha type disagreement");
    }

    const N: usize = x.len;
    const Lf: T_elem = @as(T_elem, @floatFromInt(N - 1));

    var tmp: T_elem = undefined;
    var n: T_elem = undefined;

    var i: usize = 0;
    while (i < N) : (i += 1) {
        n = @as(T_elem, @floatFromInt(i)) - 0.5 * Lf;
        tmp = alpha * n / (Lf / 2);
        x[i] = @exp(-0.5 * tmp * tmp);
    }
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;

test "\t gausswin window \t  even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_even);

        gausswin(x, 2.5);

        try std.testing.expectApproxEqAbs(@as(T, 0.0439369336), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.3246524673), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.8824969025), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.8824969025), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.3246524673), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0439369336), x[5], eps);
    }
}

test "\t gausswin window \t  odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_odd);

        gausswin(x, 2.5);

        try std.testing.expectApproxEqAbs(@as(T, 0.043936933), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.249352208), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.706648277), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.706648277), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.249352208), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.043936933), x[6], eps);
    }
}
