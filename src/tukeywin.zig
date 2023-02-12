const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;

pub const pi = math.pi;

pub fn tukeywin(x: anytype, r: anytype) void {
    const T = @TypeOf(x);
    comptime var T_elem = ElementType(T);

    if ((@TypeOf(r) != T_elem) and (@TypeOf(r) != comptime_float)) {
        @compileError("r type disagreement");
    }

    var N: usize = x.len;
    var z: T_elem = undefined;
    var z_inc: T_elem = 1.0 / @intToFloat(T_elem, N - 1);

    var i: usize = 0;
    while (i < N) : (i += 1) {
        z = @intToFloat(T_elem, i) * z_inc;

        if (z < 0.5 * r) {
            x[i] = 0.5 * (1.0 + @cos((2 * pi / r) * (z - 0.5 * r)));
            x[N - 1 - i] = x[i];
        } else if (z <= 0.5) {
            x[i] = 1.0;
            x[N - 1 - i] = 1.0;
        }
    }
}

const eps = 1.0e-5;
const n_even = 6;
const n_odd = 7;
const r_test = 0.7;

test "\t tukeywin window \t  even length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_even);

        tukeywin(x, r_test);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.611260466), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.611260466), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[5], eps);
    }
}

test "\t tukeywin window \t  odd length array\n" {
    inline for (.{ f32, f64 }) |T| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(T, n_odd);

        tukeywin(x, r_test);

        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.4626349532), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.9944154131), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.9944154131), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.4626349532), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[6], eps);
    }
}

