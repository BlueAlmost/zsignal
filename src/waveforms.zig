const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.Complex;

const ElementType = @import("./helpers.zig").ElementType;
const ValueType = @import("./helpers.zig").ValueType;

pub fn sin_wave(x: anytype, freq: anytype, phase: anytype) void {
    const T = @TypeOf(x);
    const T_elem = ElementType(T);

    if ((@TypeOf(freq) != T_elem) or (@TypeOf(phase) != T_elem)) {
        @compileError("freq/phase type disagreements");
    }

    for (x, 0..) |_, i| {
        x[i] = @sin(@as(T_elem, @floatFromInt(i)) * freq + phase);
    }
}

pub fn cos_wave(x: anytype, freq: anytype, phase: anytype) void {
    const T = @TypeOf(x);
    const T_elem = ElementType(T);

    if ((@TypeOf(freq) != T_elem) or (@TypeOf(phase) != T_elem)) {
        @compileError("freq/phase type disagreements");
    }

    for (x, 0..) |_, i| {
        x[i] = @cos(@as(T_elem, @floatFromInt(i)) * freq + phase);
    }
}

pub fn exp_wave(x: anytype, freq: anytype, phase: anytype) void {
    const T = @TypeOf(x);
    const R = ValueType(T);

    if ((@TypeOf(freq) != R) or (@TypeOf(phase) != R)) {
        @compileError("freq/phase type disagreements");
    }

    for (x, 0..) |_, i| {
        x[i].re = @cos(@as(R, @floatFromInt(i)) * freq + phase);
        x[i].im = @sin(@as(R, @floatFromInt(i)) * freq + phase);
    }
}

// --- TESTS -----------------------------
const eps = 1.0e-5;

test "\t sin_wave \t  array\n" {
    inline for (.{ f32, f64 }) |T| {
        const n = 8;

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n);
        const freq: T = math.pi / 4.0;
        const phase: T = math.pi / 4.0;

        sin_wave(x, freq, phase);

        try std.testing.expectApproxEqAbs(@as(T, math.sqrt1_2), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, math.sqrt1_2), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, -math.sqrt1_2), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, -1.0), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, -math.sqrt1_2), x[6], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[7], eps);
    }
}

test "\t cos_wave \t  array\n" {
    inline for (.{ f32, f64 }) |T| {
        const n = 8;

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(T, n);
        const freq: T = math.pi / 4.0;
        const phase: T = math.pi / 4.0;

        cos_wave(x, freq, phase);

        try std.testing.expectApproxEqAbs(@as(T, math.sqrt1_2), x[0], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[1], eps);
        try std.testing.expectApproxEqAbs(@as(T, -math.sqrt1_2), x[2], eps);
        try std.testing.expectApproxEqAbs(@as(T, -1.0), x[3], eps);
        try std.testing.expectApproxEqAbs(@as(T, -math.sqrt1_2), x[4], eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[5], eps);
        try std.testing.expectApproxEqAbs(@as(T, math.sqrt1_2), x[6], eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[7], eps);
    }
}

test "\t exp_wave \t  array\n" {
    inline for (.{ f32, f64 }) |T| {
        const C: type = Complex(T);

        const n = 8;

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        const x = try allocator.alloc(C, n);
        const freq: T = math.pi / 4.0;
        const phase: T = math.pi / 4.0;

        exp_wave(x, freq, phase);

        try std.testing.expectApproxEqAbs(@as(T, math.sqrt1_2), x[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(T, -math.sqrt1_2), x[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(T, -1.0), x[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(T, -math.sqrt1_2), x[4].re, eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[5].re, eps);
        try std.testing.expectApproxEqAbs(@as(T, math.sqrt1_2), x[6].re, eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[7].re, eps);

        try std.testing.expectApproxEqAbs(@as(T, math.sqrt1_2), x[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(T, 1.0), x[1].im, eps);
        try std.testing.expectApproxEqAbs(@as(T, math.sqrt1_2), x[2].im, eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[3].im, eps);
        try std.testing.expectApproxEqAbs(@as(T, -math.sqrt1_2), x[4].im, eps);
        try std.testing.expectApproxEqAbs(@as(T, -1.0), x[5].im, eps);
        try std.testing.expectApproxEqAbs(@as(T, -math.sqrt1_2), x[6].im, eps);
        try std.testing.expectApproxEqAbs(@as(T, 0.0), x[7].im, eps);
    }
}
