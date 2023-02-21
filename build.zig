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
    //const headers_h = b.addConfigHeader(
    //    .{
    //        .style = .autoconf,
    //        .include_path = "src/server/ngx_auto_headers.h",
    //    },
    //    .{
    //        .NGX_HAVE_UNISTD_H = 1,
    //        .NGX_HAVE_INTTYPES_H = 1,
    //        .NGX_HAVE_LIMITS_H = 1,
    //        .NGX_HAVE_SYS_PARAM_H = 1,
    //        .NGX_HAVE_SYS_MOUNT_H = 1,
    //        .NGX_HAVE_SYS_STATVFS_H = 1,
    //        .NGX_HAVE_CRYPT_H = 1,
    //        .NGX_LINUX = 1,
    //        .NGX_HAVE_SYS_PRCTL_H = 1,
    //        .NGX_HAVE_SYS_VFS_H = 1,
    //    },
    //);
    //server.addConfigHeader(headers_h);
    //server.installConfigHeader(headers_h, .{});
    server.linkSystemLibrary("ssl");
    server.linkSystemLibrary("crypto");
    server.linkSystemLibrary("pthread");
    server.linkLibC();
    server.install();
}
