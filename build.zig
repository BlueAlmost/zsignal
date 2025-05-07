const std = @import("std");

pub fn build(b: *std.Build) void {

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zsignal = b.addModule("zsignal_import_name", .{
        .root_source_file = b.path("./zsignal.zig"),
    });

    const zsignal_tests = b.addTest(.{
        .root_source_file = b.path("./zsignal_test.zig"),
        .target = target,
        .optimize = optimize,
    });

    zsignal_tests.root_module.addImport("zsignal_import_name", zsignal);

    const run_zsignal_tests = b.addRunArtifact(zsignal_tests);

    const test_step = b.step("test", "Run module tests");

    test_step.dependOn(&run_zsignal_tests.step);


    // unit_tests.addAnonymousModule("zsignal", .{
    //     .source_file = .{.path = "./zsignal.zig"},
    // });

    // const unit_tests_step = b.step("test", "Run unit tests");
    // unit_tests_step.dependOn(&unit_tests.step);
}
