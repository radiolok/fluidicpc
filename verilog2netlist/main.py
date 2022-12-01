import argparse
import os

from config import kicad_convert_table
from skidl import KICAD, lib_search_paths
from verilog_classes import KicadConvertTable, VerilogFile

if __name__ == "__main__":
    # Path to verilog file
    input_filename = os.path.join("verilog_inputs", "adder_synth.v")
    output_folder = "netlists_outputs"
    project_kicad_symbol_lib = "FA"

    # Project elements only for this project
    lib_search_paths[KICAD].append(project_kicad_symbol_lib)

    parser = argparse.ArgumentParser(description="Convert verilog file to netlist")
    parser.add_argument("-i", "--input", nargs="?",
                        help=f"Input verilog file. default is {input_filename}")
    parser.add_argument("-l", "--lib", action="append", nargs="?",
                        help=f"Add kicad library path. Multiple path is allowed. \
                            default is {project_kicad_symbol_lib}")
    parser.add_argument("-o", "--output", nargs="?",
                        help=f"Output folder. default is {output_folder}")
    # parser.print_usage()
    args = parser.parse_args()

    if args.input is not None:
        input_filename = args.input

    if args.lib is not None:
        for lib in args.lib:
            lib_search_paths[KICAD].append(lib)

    if args.output is not None:
        output_folder = args.output

    # Rules are created to replace verilog notations
    # to Kicad element both schematic and footprint
    k = KicadConvertTable()
    k.add_kicad_convert_table(kicad_convert_table)

    # Netlist are created for each module in verilog file in output folder.
    # Each verilog module will have its own netlist file with *.net extension
    v = VerilogFile(filename=input_filename,
                    kicad_convert_table=k)
    v.parse_modules()
    v.create_skidle(output_folder=output_folder)
