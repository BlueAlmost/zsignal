const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

const pi = math.pi;

pub fn triang(x: anytype) void {
    const T = @TypeOf(x);
    comptime var T_elem = ElementType(T);

    var L: usize = x.len;
    var Lf: T_elem = @intToFloat(T_elem, L);
    var tmp: T_elem = undefined;

    var M: usize = undefined;

    if (@mod(x.len, 2) == 0) {
        M = L / 2;

        var i: usize = 0;
        while (i < M) : (i += 1) {
            tmp = @intToFloat(T_elem, 2 * (i + 1) - 1) / Lf;
            x[i] = tmp;
            x[L - 1 - i] = tmp;
        }
    } else {
        M = (L + 1) / 2;

        var i: usize = 0;
        while (i < M) : (i += 1) {
            tmp = @intToFloat(T_elem, 2 * (i + 1)) / (Lf + 1);
            x[i] = tmp;
            x[L - 1 - i] = tmp;
        }
    }
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;

test "\t triang window \t even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_even);

        triang(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.166666666), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.5), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.833333333), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.833333333), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.5), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.166666666), x[5], eps);
    }
}

test "\t triang window \t odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_odd);

        triang(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.25), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.5), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.75), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.75), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.5), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.25), x[6], eps);
    }
}

