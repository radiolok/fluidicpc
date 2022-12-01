# -*- coding: utf-8 -*-

from skidl import *


def __main_py():

    #===============================================================================
    # Component templates.
    #===============================================================================

    FA_INPUT_FA_INPUT = Part('FA', 'INPUT', dest=TEMPLATE, footprint='FA:INPUT')
    setattr(FA_INPUT_FA_INPUT, 'F0', 'U')
    setattr(FA_INPUT_FA_INPUT, 'Reference', 'U')
    setattr(FA_INPUT_FA_INPUT, 'F1', 'INPUT')
    setattr(FA_INPUT_FA_INPUT, 'Value', 'INPUT')

    FA_NOR_FA_NOR = Part('FA', 'NOR', dest=TEMPLATE, footprint='FA:NOR')
    setattr(FA_NOR_FA_NOR, 'F0', 'D')
    setattr(FA_NOR_FA_NOR, 'Reference', 'D')
    setattr(FA_NOR_FA_NOR, 'F1', 'NOR')
    setattr(FA_NOR_FA_NOR, 'Value', 'NOR')

    FA_OUTPUT_FA_OUTPUT = Part('FA', 'OUTPUT', dest=TEMPLATE, footprint='FA:OUTPUT')
    setattr(FA_OUTPUT_FA_OUTPUT, 'F0', 'U')
    setattr(FA_OUTPUT_FA_OUTPUT, 'Reference', 'U')
    setattr(FA_OUTPUT_FA_OUTPUT, 'F1', 'OUTPUT')
    setattr(FA_OUTPUT_FA_OUTPUT, 'Value', 'OUTPUT')


    #===============================================================================
    # Component instantiations.
    #===============================================================================

    A = FA_INPUT_FA_INPUT(ref='A', value='INPUT')

    B = FA_INPUT_FA_INPUT(ref='B', value='INPUT')

    _09_ = FA_NOR_FA_NOR(ref='_09_', value='NOT')

    _10_ = FA_NOR_FA_NOR(ref='_10_', value='NOT')

    _11_ = FA_NOR_FA_NOR(ref='_11_', value='NOT')

    _12_ = FA_NOR_FA_NOR(ref='_12_', value='NOR')

    _13_ = FA_NOR_FA_NOR(ref='_13_', value='NOR')

    _14_ = FA_NOR_FA_NOR(ref='_14_', value='NOR')

    _15_ = FA_NOR_FA_NOR(ref='_15_', value='OR')

    _16_ = FA_NOR_FA_NOR(ref='_16_', value='NOR')

    _17_ = FA_NOR_FA_NOR(ref='_17_', value='OR')

    _18_ = FA_NOR_FA_NOR(ref='_18_', value='NOR')

    _19_ = FA_NOR_FA_NOR(ref='_19_', value='NOR')

    ci = FA_INPUT_FA_INPUT(ref='ci', value='INPUT')

    co = FA_OUTPUT_FA_OUTPUT(ref='co', value='OUTPUT')

    out = FA_OUTPUT_FA_OUTPUT(ref='out', value='OUTPUT')


    #===============================================================================
    # Net interconnections between instantiated components.
    #===============================================================================

    Net('A').connect(A['1'], _09_['4'], _13_['4'])

    Net('B').connect(B['1'], _11_['4'], _18_['4'])

    Net('_00_').connect(_13_['7'], _14_['5'], _15_['5'])

    Net('_01_').connect(_14_['7'], _18_['5'])

    Net('_02_').connect(_15_['6'], _16_['5'])

    Net('_03_').connect(_16_['7'], _17_['5'], _19_['4'])

    Net('_04_').connect(_18_['7'], _19_['5'])

    Net('_05_').connect(_09_['7'], _12_['4'])

    Net('_06_').connect(_10_['7'], _12_['5'])

    Net('_07_').connect(_11_['7'], _16_['4'])

    Net('_08_').connect(_12_['7'], _14_['4'], _15_['4'], _17_['4'])

    Net('ci').connect(_10_['4'], _13_['5'], ci['1'])

    Net('co').connect(_17_['6'], co['1'])

    Net('out').connect(_19_['7'], out['1'])


#===============================================================================
# Instantiate the circuit and generate the netlist.
#===============================================================================

if __name__ == "__main__":
    __main_py()
    generate_netlist()
