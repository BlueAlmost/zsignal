const std = @import("std");
const Builder = std.build.Builder;
const Pkg = std.build.Pkg;

const pkgs = struct {
    const zsignal = Pkg{
        .name = "zsignal",
        .source = .{ .path = "./zsignal.zig" },
        .dependencies = &[_]Pkg{ },
    };
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe_tests = b.addTest("./main_test.zig");
    exe_tests.addPackage(pkgs.zsignal);
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
