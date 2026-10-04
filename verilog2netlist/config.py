kicad_convert_table = {"FA": [{
    "verilog_type": "input",
    "kicad_schematic_lib": "FA",
    "kicad_schematic_element": "INPUT",
    "kicad_footprint": "FA:INPUT",
    "pins": {},
},
    {
    "verilog_type": "output",
        "kicad_schematic_lib": "FA",
        "kicad_schematic_element": "OUTPUT",
        "kicad_footprint": "FA:OUTPUT",
        "pins": {},
},
    {
    "verilog_type": "NOR",
        "kicad_schematic_lib": "FA",
        "kicad_schematic_element": "NOR",
        "kicad_footprint": "FA:NOR",
        "pins": {
            ".A": {
                "number": "4"
            },
            ".B": {
                "number": "5"
            },
            ".Y": {
                "number": "7"
            }},

}, {
        "verilog_type": "NOT",
        "kicad_schematic_lib": "FA",
        "kicad_schematic_element": "NOR",
        "kicad_footprint": "FA:NOR",
        "pins": {
            ".A": {
                "number": "4"
            },
            ".Y": {
                "number": "7"
            }},

}, {
        "verilog_type": "OR",
        "kicad_schematic_lib": "FA",
        "kicad_schematic_element": "NOR",
        "kicad_footprint": "FA:NOR",
        "pins": {
            ".A": {
                "number": "4"
            },
            ".B": {
                "number": "5"
            },
            ".Y": {
                "number": "6"
            }},

}, ], "adder": [{
    "verilog_type": "FA",
    "kicad_schematic_lib": "FA",
    "kicad_schematic_element": "genblk1.fa",
    "kicad_footprint": "FA:genblk1.fa",
    "pins": {
        ".A": {
            "name": "A"
                },
        ".B": {
            "name": "B"
        },
        ".ci": {
            "name": "ci"
        },
        ".co": {
            "name": "co"
        },
        ".out": {
            "name": "out"
        }},

}, {
    "verilog_type": "input",
    "kicad_schematic_lib": "FA",
    "kicad_schematic_element": "INPUT",
    "kicad_footprint": "FA:INPUT",
    "pins": {},
},
    {
        "verilog_type": "output",
        "kicad_schematic_lib": "FA",
        "kicad_schematic_element": "OUTPUT",
        "kicad_footprint": "FA:OUTPUT",
        "pins": {},
}, ]}

# ---------------------------------------------------------------------------
# Струйный калькулятор (calculator/netlist): правила для восьми даёв.
# NOR, NOT и OR — это один и тот же элемент FA:NOR (выход 6 — ИЛИ, выход 7 — ИЛИ-НЕ).
# Для AND, XOR, RS (ячейка памяти), KEY (ключ трубочки) и OSC (генератор) символов и
# футпринтов в KiCad пока нет; элементы без правила в netlist не попадают —
# допишите правила сюда, когда появятся библиотеки.
# ---------------------------------------------------------------------------
_calc_rules = [
    {"verilog_type": "input", "kicad_schematic_lib": "FA", "kicad_schematic_element": "INPUT",
     "kicad_footprint": "FA:INPUT", "pins": {}},
    {"verilog_type": "output", "kicad_schematic_lib": "FA", "kicad_schematic_element": "OUTPUT",
     "kicad_footprint": "FA:OUTPUT", "pins": {}},
    {"verilog_type": "NOR", "kicad_schematic_lib": "FA", "kicad_schematic_element": "NOR",
     "kicad_footprint": "FA:NOR",
     "pins": {".A": {"number": "4"}, ".B": {"number": "5"}, ".Y": {"number": "7"}}},
    {"verilog_type": "NOT", "kicad_schematic_lib": "FA", "kicad_schematic_element": "NOR",
     "kicad_footprint": "FA:NOR",
     "pins": {".A": {"number": "4"}, ".Y": {"number": "7"}}},
    {"verilog_type": "OR", "kicad_schematic_lib": "FA", "kicad_schematic_element": "NOR",
     "kicad_footprint": "FA:NOR",
     "pins": {".A": {"number": "4"}, ".B": {"number": "5"}, ".Y": {"number": "6"}}},
]
for _die in ("d1_retina_a", "d2_retina_b", "d3_ctrl_a", "d4_ctrl_b",
             "d5_alu_a", "d6_alu_b", "d7_disp_a", "d8_disp_b"):
    kicad_convert_table[_die] = _calc_rules
