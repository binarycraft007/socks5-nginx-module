const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const client = b.addExecutable(.{
        .name = "client",
        .target = target,
        .optimize = optimize,
    });
    client.addIncludePath("src/client");
    client.addCSourceFiles(
        &[_][]const u8{
            "src/client/client.c",
        },
        &[_][]const u8{"-Wall"},
    );
    client.linkSystemLibrary("ssl");
    client.linkSystemLibrary("crypto");
    client.linkSystemLibrary("pthread");
    client.linkLibC();
    client.install();

    const server = b.addSharedLibrary(.{
        .name = "ngx_http_socks5_module",
        .target = target,
        .optimize = optimize,
    });

    server.addIncludePath("src/server");
    server.addIncludePath("src/server/core");
    server.addIncludePath("src/server/event");
    server.addIncludePath("src/server/event/modules");
    server.addIncludePath("src/server/os/unix");
    server.addIncludePath("src/server/http");
    server.addIncludePath("src/server/http/modules");
    server.addCSourceFiles(
        &[_][]const u8{
            "src/server/server.c",
            "src/server/module.c",
        },
        &[_][]const u8{
            "-W",
            "-Wall",
            "-Wpointer-arith",
            "-Wno-unused-parameter",
            "-Werror",
        },
    );
    server.linkSystemLibrary("ssl");
    server.linkSystemLibrary("crypto");
    server.linkSystemLibrary("pthread");
    server.linkLibC();
    server.install();
}
