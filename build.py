import os
import subprocess

NAME = "byte"

LIB_MODULES = ["heap", "obj", "exec", "types/bint"]
LIB_MAIN = "byte.d"

MODULES = []
MAIN = "byte.d"

subprocess.run(
    [
        "ldc2",
        "-shared",
        "-release",
        "-static",
        "-flto=full",
        "-O3",
        "-disable-red-zone",
        "-betterC",
        "-I.",
        *[os.path.join("lib", mod) for mod in LIB_MODULES],
        os.path.join("lib", LIB_MAIN),
        f"-of{NAME}.dll",
    ]
)

subprocess.run(
    [
        "ldc2",
        "-release",
        "-static",
        "-flto=full",
        "-O3",
        "-disable-red-zone",
        "-betterC",
        *[os.path.join("main", mod) for mod in MODULES],
        os.path.join("main", MAIN),
        f"-of{NAME}.exe",
    ]
)
