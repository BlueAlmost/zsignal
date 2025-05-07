const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

const pi = math.pi;

pub fn nuttall(x: anytype) void {
    const T = @TypeOf(x);
    const T_elem = ElementType(T);

    const L: usize = x.len;

    const a0: T_elem = 0.3635819;
    const a1: T_elem = 0.4891775;
    const a2: T_elem = 0.1365995;
    const a3: T_elem = 0.0106411;

    const Lm1: T_elem = @as(T_elem, @floatFromInt(L - 1));
    var tmp: T_elem = undefined;

    var i: usize = 0;
    while (i < L) : (i += 1) {
        tmp = 2 * pi * @as(T_elem, @floatFromInt(i)) / Lm1;
        x[i] = a0 - a1 * @cos(tmp) + a2 * @cos(2 * tmp) - a3 * @cos(3 * tmp);
    }
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;

test "\t nuttall window \t even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_even);

        nuttall(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0003638), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.11051525), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.7982581), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.7982581), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.11051525), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0003628), x[5], eps);
    }
}

test "\t nuttall window \t  odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_odd);

        nuttall(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0003628), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0613345), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.5292298), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.5292298), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0613345), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0003628), x[6], eps);
    }
}
