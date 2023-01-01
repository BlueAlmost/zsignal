const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

pub const zsignal = @import("zsignal");

const ElementType = @import("./helpers.zig").ElementType;

const pi = math.pi;

pub fn bartlett(x: anytype) void {
    const T = @TypeOf(x);
    comptime var T_elem = ElementType(T);

    var L: usize = x.len;
    var tmp: T_elem = undefined;

    if (@mod(x.len, 2) == 0) {
        var L2: usize = L / 2;

        var i: usize = 0;
        while (i < L2) : (i += 1) {
            tmp = @intToFloat(T_elem, 2 * i) / @intToFloat(T_elem, L - 1);
            x[i] = tmp;
            x[L - 1 - i] = tmp;
        }
    } else {
        var M: usize = (L - 1) / 2;
        var i: usize = 0;
        while (i < M) : (i += 1) {
            tmp = @intToFloat(T_elem, i) / @intToFloat(T_elem, M);
            x[i] = tmp;
            x[L - 1 - i] = tmp;
        }
        x[M] = 1.0;
    }
}

const n_even = 6;
const n_odd = 7;
const eps = 1.0e-5;

test "\t bartlett window \t  even length array\n" {

    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_even);

        zsignal.bartlett(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.4), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.8), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.8), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.4), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[5], eps);
    }
}

test "\t bartlett window \t  odd length array\n" {
    
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_odd);

        zsignal.bartlett(x);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.3333333333), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.6666666666), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.6666666666), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.3333333333), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[6], eps);
    }
}
