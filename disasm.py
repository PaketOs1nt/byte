import os
import sys
from dataclasses import dataclass

opcodes = [
    "nop",
    "pos_add",
    "pos_sub",
    "pop_top",
    "flag",
    "push_obj",
    "push_const",
    "use_op",
    "to",
]

use_ops = ["add"]
types = ["none", "int", "bool", "str"]

size_t = 8 if sys.maxsize > 2**32 else 4
max_opcode_size = len(max(opcodes, key=len))
max_type_size = len(max(types, key=len))


@dataclass
class Const:
    type: str
    data: str

    def __str__(self):
        return f"{self.type.ljust(max_type_size)} {self.data}"


@dataclass
class Instr:
    op: str
    arg: str
    help: str = ""

    def __str__(self):
        if self.help:
            return (
                f"{self.op.ljust(max_opcode_size)} {self.arg}"
                + f"# {self.help}".rjust(max_opcode_size + 8)
            )
        else:
            return f"{self.op.ljust(max_opcode_size)} {self.arg}"


def get_const_data(const_type: str, const_raw: bytes) -> str:
    if const_type == "int":
        return str(int.from_bytes(const_raw, "little"))

    elif const_type == "bool":
        return str(bool(const_raw[0]))

    elif const_type == "str":
        return const_raw.decode("utf-8")

    elif const_type == "none":
        return "none"
    else:
        raise ValueError(f"unknown const type: {const_type} [{const_raw}]")


class Code:
    def __init__(self, raw: bytes) -> None:
        self.ptr = 0
        self.raw = raw
        self.consts: list[Const] = []
        self.code: list[Instr] = []

        self.load_consts()
        self.load_code()

    def load_consts(self):
        consts_len = self.raw[self.ptr]
        self.ptr += 1

        for _ in range(consts_len):
            const_type = types[self.raw[self.ptr]]
            self.ptr += 1

            const_size = int.from_bytes(
                self.raw[self.ptr : self.ptr + size_t], byteorder="little", signed=False
            )

            self.ptr += size_t

            const_raw = self.raw[self.ptr : self.ptr + const_size]
            self.ptr += const_size

            const_data = get_const_data(const_type, const_raw)
            assert const_data  # failed load constant data

            const = Const(const_type, const_data)
            self.consts.append(const)

    def load_code(self):
        size = len(self.raw) - self.ptr
        assert size

        for i in range(self.ptr, self.ptr + size, 2):
            op = opcodes[self.raw[i]]
            help = ""

            arg_raw = self.raw[i + 1]
            if op in ("push_obj", "to"):
                arg = types[arg_raw]
            elif op == "use_op":
                arg = use_ops[arg_raw]
            else:
                arg = str(arg_raw)

            if op == "push_const":
                help = str(self.consts[arg_raw])

            instr = Instr(op, arg, help)
            self.code.append(instr)

    def decompile(self, indent=4, clean=False) -> str:
        if not self.code and not self.consts:
            return ""

        ind = " " * indent
        result = ""

        if self.consts:
            result += ".consts:\n"
            for const in self.consts:
                result += ind + f"{const}\n"

            result += "\n"

        if self.code:
            jmps = list()

            if not clean:
                instr_moves_table = {a: 0 for a in range(len(self.code))}

                for i, instr in enumerate(self.code):
                    if instr.op == "pos_add":
                        instr_moves_table[i] += 1
                        instr_moves_table[i + int(instr.arg)] += 1
                        jmps.append((i, i + int(instr.arg)))

                    if instr.op == "pos_sub":
                        instr_moves_table[i] += 1
                        instr_moves_table[i - int(instr.arg)] += 1
                        jmps.append((i, i - int(instr.arg)))

                help_indent = max(instr_moves_table.values())
                jmp_indent = help_indent * 4
            else:
                jmp_indent = 0
                help_indent = 0

            result += ".code:\n"

            for i, instr in enumerate(self.code):
                cols = []

                for src, dst in jmps:
                    start = min(src, dst)
                    end = max(src, dst)

                    if i == src:
                        cols.append("+-- ")
                    elif i == dst:
                        cols.append("+-> ")
                    elif start < i < end:
                        cols.append("|   ")
                    else:
                        cols.append("    ")

                jmp_helper = "".join(cols)
                cind = jmp_helper.rjust(jmp_indent) if help_indent else ind
                result += cind + f"{instr}\n"

            result += "\n"

        return result.strip()


def main(args: list[str]):
    if len(args) > 1:
        path = args[-1]
        if os.path.exists(path) and os.path.isfile(path):
            with open(path, "rb") as f:
                raw = f.read()
                code = Code(raw)
                print(code.decompile(clean="-clean" in args))
        else:
            print(f"{path} is not exists or is not file")

    else:
        print("no input file")


if __name__ == "__main__":
    main(sys.argv)
