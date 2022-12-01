import re
import os
from verilog_parse import parse_verilog
from dataclasses import dataclass, field
from typing import List
from skidl import *

@dataclass
class VerilogWire():
    name: str = field(default="")


@dataclass
class VerilogInput():
    name: str = field(default="")
    module: "VerilogModule" = field(default_factory=dict)

    def create_skidl_part(self, input_name: str) -> Part:
        kicad_elements = self.module.verilog_file.kicad_convert_table.get_encode_table(
            self.module.name, "input")
        return Part(
            kicad_elements["kicad_schematic_lib"],
            kicad_elements["kicad_schematic_element"],
            dest=TEMPLATE,
            footprint=kicad_elements["kicad_footprint"],
            tag="tag")(1, ref=input_name)


@dataclass
class VerilogOutput():
    name: str = field(default="")
    module: "VerilogModule" = field(default_factory=dict)

    def create_skidl_part(self, output_name: str) -> Part:
        kicad_elements = self.module.verilog_file.kicad_convert_table.get_encode_table(
            self.module.name, "output")
        return Part(
            kicad_elements["kicad_schematic_lib"],
            kicad_elements["kicad_schematic_element"],
            dest=TEMPLATE,
            footprint=kicad_elements["kicad_footprint"],
            tag="tag")(1, ref=output_name)


@dataclass
class VerilogSymbolPin():
    name: str = field(default="")
    wire: VerilogWire = field(default=VerilogWire())
    symbol: "VerilogSymbol" = field(default=dict)

    def get_kicad_pin(self):
        kicad_pin = ""
        kicad_elements = self.symbol.module.verilog_file.kicad_convert_table.get_encode_table(
            self.symbol.module.name, self.symbol.type)
        if "number" in kicad_elements["pins"][self.name].keys():
            kicad_pin = kicad_elements["pins"][self.name]["number"]
        if "name" in kicad_elements["pins"][self.name].keys():
            kicad_pin = kicad_elements["pins"][self.name]["name"]
        return kicad_pin


@dataclass
class VerilogSymbol():
    type: str = field(default="")
    name: str = field(default="")
    pins: List[VerilogSymbolPin] = field(default_factory=list)
    module: "VerilogModule" = field(default_factory=dict)

    def create_skidl_part(self, ref: str = None, value: str = None) -> Part:
        if ref is None:
            ref = self.name
        if value is None:
            value = self.type
        kicad_elements = self.module.verilog_file.kicad_convert_table.get_encode_table(
            self.module.name, self.type)

        return Part(
            kicad_elements["kicad_schematic_lib"],
            kicad_elements["kicad_schematic_element"],
            dest=TEMPLATE,
            footprint=kicad_elements["kicad_footprint"])(1, ref=ref, value=value)


@dataclass
class VerilogModule():
    name: str = field(default="")
    wires: List[VerilogWire] = field(default_factory=list)
    inputs: List[VerilogInput] = field(default_factory=list)
    outputs: List[VerilogOutput] = field(default_factory=list)
    symbols: List[VerilogSymbol] = field(default_factory=list)
    verilog_file: "VerilogFile" = field(default_factory=dict)


@dataclass
class KicadConvertTable():
    kicad_convert_table: dict = field(default_factory=dict)
    check_inputs: dict = field(default_factory=dict)
    rules_keys = set(["verilog_type",
                      "kicad_schematic_lib",
                     "kicad_schematic_element",
                      "kicad_footprint"])
    pins_keys = set(["number", "name"])
    module_require_fields = set(["input", "output"])

    # def parse_rules_dict(self, rules_dict: dict):
    # pass

    def get_module_elements(self, module_name: str) -> List:
        """All module elements from kicad_convert_table
        """
        return self.check_inputs[module_name]

    def get_encode_table(self, module_name: str, verilog_type: str) -> List:
        """Get rules by module name and verilog_type
        """
        for item in self.kicad_convert_table[module_name]:
            if isinstance(item, dict) and \
                    item["verilog_type"] == verilog_type:
                return item

    def add_kicad_convert_table(self, kicad_convert_table: dict):
        """Add config and check is it correct
        each verilog module has it's own rules

        Example:
        {"FA": [{
            "verilog_type": "NOR",
            "kicad_schematic_lib": "FA",
            "kicad_schematic_element": "NOR",
            "kicad_footprint": "FA:NOR",
            "pins": {},
        },]}
        """
        print("Convert rules: ")
        self.check_inputs = {}
        if isinstance(kicad_convert_table, dict):
            keys = kicad_convert_table.keys()
            for key in keys:
                print("module:", key)
                self.check_inputs[key] = []
                rules_list = kicad_convert_table[key]
                for rule in rules_list:
                    if not self.rules_keys.issubset(rule.keys()):
                        raise ValueError(
                            f"Each role should have all of keys: {', '.join(self.rules_keys)}")
                    print(" •", rule["verilog_type"])
                    print(
                        "  • shematic:", f'{rule["kicad_schematic_lib"]}:{rule["kicad_schematic_element"]}')
                    print("  • footprint:", rule["kicad_footprint"])
                    self.check_inputs[key].append(rule["verilog_type"])
                    if "pins" in rule.keys():
                        if not isinstance(rule["pins"], dict):
                            raise ValueError("Pins config should be a dict")
                        for pin in rule["pins"].keys():
                            if not set(rule["pins"][pin].keys()).issubset(self.pins_keys):
                                raise ValueError(
                                    "Pins rules should have or 'number' or 'name' key")
                            print("   • verilog pin", pin)
                            if "number" in rule["pins"][pin].keys():
                                print("    • change to number",
                                      rule["pins"][pin]["number"])
                            elif "name" in rule["pins"][pin].keys():
                                print("    • change to name",
                                      rule["pins"][pin]["name"])
            for key in self.check_inputs.keys():
                if not self.module_require_fields.issubset(self.check_inputs[key]):
                    raise ValueError(
                        "Each module should make 'input' and 'output' elements")
        else:
            raise TypeError("kicad_convert_table should be a dict")
        self.kicad_convert_table = kicad_convert_table


@dataclass
class VerilogFile():
    filename: str = field(default="")
    payload: str = field(default_factory=list)
    modules: List[VerilogModule] = field(default_factory=list)
    kicad_convert_table: dict = field(default_factory=dict)

    def parse(self):
        """Get list from pyparsing
        """
        f = open(self.filename, 'r')
        clean_verilog = self.clean_verilog_text(f.read())
        f.close()
        result = parse_verilog(clean_verilog)
        if len(result) > 0:
            self.payload = result
        else:
            raise ValueError("Input file is empty")

    def clean_verilog_text(self, text: str = None) -> str:
        """ Remove comment because parser cannot parse them

        Example:
        /* Generated by Yosys 0.21 (git sha1 e6d2a900a97, clang 7.0.1-8+deb10u2 -fPIC -Os) */

        (* src = "adder.v:2.1-12.10" *)
        module FA(ci, A, B, out, co);
        """

        header_comment_pattern = re.compile(r'\/\*.*\*\/')
        src_comment_pattern = re.compile(r'\(\*.*\*\)')
        text = header_comment_pattern.sub("", text)
        text = src_comment_pattern.sub("", text)
        return text

    def parse_modules(self):
        """Get objects from parsed list
        """
        self.parse()
        for module in self.payload:
            if isinstance(module, list) and module[0][0] == "module":
                module_name = module[0][1]
                m = VerilogModule()
                m.verilog_file = self
                m.name = module_name
                self.modules.append(m)
                for module_item in module[1]:
                    if isinstance(module_item, list) and len(module_item) >= 2:
                        first_el = module_item[0]
                        if first_el == "wire":
                            w = VerilogWire()
                            w.name = module_item[1][0]
                            m.wires.append(w)
                        elif first_el == "input":
                            i = VerilogInput()
                            i.module = m
                            i.name = module_item[1]
                            m.inputs.append(i)
                        elif first_el == "output":
                            o = VerilogOutput()
                            o.module = m
                            o.name = module_item[1]
                            m.outputs.append(o)
                        elif first_el in self.kicad_convert_table.get_module_elements(module_name):
                            s = VerilogSymbol()
                            s.module = m
                            s.type = module_item[0]
                            s.name = module_item[1][0][0]
                            for pin in module_item[1][1]:
                                if isinstance(pin, list):
                                    p = VerilogSymbolPin()
                                    p.symbol = s
                                    p.name = "".join(pin[0:2])
                                    wire_name = pin[3]
                                    if isinstance(wire_name, list):
                                        p.wire = pin[3][0]
                                    else:
                                        p.wire = pin[3]
                                    s.pins.append(p)
                            m.symbols.append(s)

    def create_skidle(self, output_folder="."):
        """Create netlist using skidl in output folder
        each name is a name of module in verilog file
        """
        for m in self.modules:
            if not os.path.exists(output_folder):
                os.mkdir(output_folder)
            output_filename = f'{output_folder}{os.sep}{m.name}.net'
            c = Circuit()
            c.no_files = True
            local_wires = {}
            local_inputs = {}
            local_outputs = {}
            local_symbols = {}
            for wire in m.wires:
                local_wires[wire.name] = Net(wire.name)
                c += local_wires[wire.name]
            for input in m.inputs:
                local_inputs[input.name] = input.create_skidl_part(
                    input_name=input.name)
                c += local_inputs[input.name]
                if isinstance(local_wires[input.name], Net):
                    local_wires[input.name] += local_inputs[input.name][0][1]
                else:
                    raise TypeError(f"{input.name} is not an instance of Net")
            for symbol in m.symbols:
                local_symbols[symbol.name] = symbol.create_skidl_part()
                c += local_symbols[symbol.name]
                s = local_symbols[symbol.name]
                for pin in symbol.pins:
                    kicad_pin = pin.get_kicad_pin()
                    if isinstance(local_wires[input.name], Net):
                        local_wires[pin.wire] += s[0][kicad_pin]
                    else:
                        raise TypeError(
                            f"{input.name} is not an instance of Net")
            for output in m.outputs:
                local_outputs[output.name] = output.create_skidl_part(
                    output_name=output.name)
                c += local_outputs[output.name]
                if isinstance(local_wires[input.name], Net):
                    local_wires[output.name] += local_outputs[output.name][0][1]
                else:
                    raise TypeError(f"{input.name} is not an instance of Net")

            f = open(output_filename, "w")
            print(f'save {output_filename} ')
            f.write(c.generate_netlist())
            f.close()
