import subprocess

FILE = "byte.d"

subprocess.run(
    [
        "ldc2",
        "-release",
        "-static",
        "-flto=full",
        "-O3",
        "-disable-red-zone",
        "-betterC",
        FILE,
    ]
)
