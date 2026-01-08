import os
import subprocess
import time

NAME = "byte"

LIB_MODULES = ["heap", "obj", "exec", "types/bint", "types/bbool", "types/bstr"]
LIB_MAIN = "byte.d"

MODULES = ["header"]
MAIN = "byte.d"

COMPILER_MODULES = ["ast", "packer", "structs", "tokens", "basm"]
COMPILER = "main.d"

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

subprocess.run(
    [
        "ldc2",
        "-release",
        "-static",
        "-flto=full",
        "-O3",
        "-disable-red-zone",
        *[os.path.join(NAME + "c", mod) for mod in COMPILER_MODULES],
        os.path.join(NAME + "c", COMPILER),
        f"-of{NAME}c.exe",
    ]
)

time.sleep(0.5)

try:
    os.remove("bytec.obj")
    os.remove("byte.obj")
except Exception as e:
    print(e)
