const std = @import("std");

const ExeTarget = enum {
    all,
    client,
    server,
};

const Executable = struct {
    name: []const u8,
    src: []const []const u8,
    include: []const u8,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const exe_target = b.option(
        ExeTarget,
        "ExeTarget",
        "executable to build, default all",
    ) orelse .all;

    const optimize = b.standardOptimizeOption(.{});

    var exes: []const Executable = undefined;
    switch (exe_target) {
        .client => {
            exes = &[_]Executable{
                .{
                    .name = "client",
                    .src = &[_][]const u8{
                        "src/client/client.c",
                    },
                    .include = "src/client",
                },
            };
        },
        .server => {
            exes = &[_]Executable{
                .{
                    .name = "server",
                    .src = &[_][]const u8{
                        "src/server/server.c",
                    },
                    .include = "src/server",
                },
            };
        },
        .all => {
            exes = &[_]Executable{
                .{
                    .name = "client",
                    .src = &[_][]const u8{
                        "src/client/client.c",
                    },
                    .include = "src/client",
                },
                .{
                    .name = "server",
                    .src = &[_][]const u8{
                        "src/server/server.c",
                    },
                    .include = "src/server",
                },
            };
        },
    }

    for (exes) |exe_obj| {
        const exe = b.addExecutable(.{
            .name = exe_obj.name,
            .target = target,
            .optimize = optimize,
        });
        exe.addIncludePath(exe_obj.include);
        exe.addCSourceFiles(
            exe_obj.src,
            &[_][]const u8{"-Wall"},
        );
        exe.linkSystemLibrary("ssl");
        exe.linkSystemLibrary("crypto");
        exe.linkSystemLibrary("pthread");
        exe.linkLibC();
        exe.install();
    }
}
