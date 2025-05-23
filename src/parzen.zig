const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

const pi = math.pi;

pub fn parzen(x: anytype) void {
    const T = @TypeOf(x);
    const T_elem = ElementType(T);

    const N: usize = x.len;
    const Nf: T_elem = @as(T_elem, @floatFromInt(N));
    const Lf: T_elem = @as(T_elem, @floatFromInt(N - 1));
    var n: T_elem = undefined;
    var tmp: T_elem = undefined;

    var i: usize = 0;
    while (i < N) : (i += 1) {
        n = @as(T_elem, @floatFromInt(i)) - 0.5 * Lf;
        tmp = @abs(n) / (0.5 * Nf);

        if (@abs(n) <= Nf / 4) {
            x[i] = 1 - 6 * (tmp * tmp) + 6 * (tmp * tmp * tmp);
        } else {
            tmp = 1 - tmp;
            x[i] = 2 * tmp * tmp * tmp;
        }
    }
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;

test "\t parzen window \t  even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_even);

        parzen(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.009259259), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.25), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.861111111), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.861111111), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.25), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.009259259), x[5], eps);
    }
}

test "\t parzen window \t  odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n_odd);

        parzen(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.005830904), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.1574344), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.65014577), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.65014577), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.1574344), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.005830904), x[6], eps);
    }
}
