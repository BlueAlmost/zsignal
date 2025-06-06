const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

const pi = math.pi;

pub fn bohman(x: anytype) void {
    const T = @TypeOf(x);
    const T_elem = ElementType(T);

    const N: usize = x.len;
    const Lf: T_elem = @as(T_elem, @floatFromInt(N - 1));

    const pi_recip: T_elem = 1.0 / pi;

    var n: T_elem = undefined;

    x[0] = 0.0;
    x[N - 1] = 0.0;

    var i: usize = 1;
    while (i < N - 1) : (i += 1) {
        n = @abs(2.0 * (@as(T_elem, @floatFromInt(i)) / Lf) - 1.0);
        x[i] = (1 - n) * @cos(pi * n) + pi_recip * @sin(pi * n);
    }
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;

test "\t bohman window \t even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_even);

        bohman(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.1791239), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.8343114), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.8343114), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.1791239), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[5], eps);
    }
}

test "\t bohman window \t odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_odd);
        bohman(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.108997785), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.60899776), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.60899776), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.108997785), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[6], eps);
    }
}
