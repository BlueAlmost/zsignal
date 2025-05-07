const std = @import("std");
const math = std.math;
const testing = std.testing;
const print = std.debug.print;

// quadrature oscillator which only uses a trigonometric function
// during initializaton or updating the instantaneous frequency
// (i.e. not during output value generation).

pub fn QuadOscillator(comptime T: type) type {
    return struct {
        const Self = @This();

        omega: T,  // oscillator frequency (radians per sample)
        c: T,      // cosine term
        s: T,      // sine term
        p: T,      // oscillator state 1
        q: T,      //     "        "   2

        pub fn init(omega: T) Self {
            return Self{
                .omega = omega,
                .c = @cos(omega),
                .s = @sin(omega),
                .p = @cos(-omega), // state init to yield 1st output of (1,0)
                .q = @sin(-omega),
            };
        }

        pub fn get(self: *Self) struct {T, T} {
            const x: T = self.c * self.p - self.s * self.q;
            const y: T = self.s * self.p + self.c * self.q;

            self.p = x;
            self.q = y;

            return .{x, y};
        }
    };
}

// --- TESTS -----------------------------
const eps = 1.0e-6;

test "\t quad oscillator \n" {
    inline for (.{ f32, f64 }) |T| {
        print("\n", .{});

        // const quad_osc = QuadOscillator(T);
        const omega: T = math.pi/2.0;

        // = quad_osc.init(omega);
        var quad_osc = QuadOscillator(T).init(omega);

        var x: T = undefined;
        var y: T = undefined;

        x, y = quad_osc.get();
        try testing.expectApproxEqAbs( x, @cos(0.0), eps);
        try testing.expectApproxEqAbs( y, @sin(0.0), eps);

        x, y = quad_osc.get();
        try testing.expectApproxEqAbs( x, @cos(math.pi/2.0), eps);
        try testing.expectApproxEqAbs( y, @sin(math.pi/2.0), eps);

        x, y = quad_osc.get();
        try testing.expectApproxEqAbs( x, @cos(math.pi), eps);
        try testing.expectApproxEqAbs( y, @sin(math.pi), eps);
    }
}

