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

    FA_OUTPUT_FA_OUTPUT = Part('FA', 'OUTPUT', dest=TEMPLATE, footprint='FA:OUTPUT')
    setattr(FA_OUTPUT_FA_OUTPUT, 'F0', 'U')
    setattr(FA_OUTPUT_FA_OUTPUT, 'Reference', 'U')
    setattr(FA_OUTPUT_FA_OUTPUT, 'F1', 'OUTPUT')
    setattr(FA_OUTPUT_FA_OUTPUT, 'Value', 'OUTPUT')

    FA_genblk1_fa_FA_genblk1_fa = Part('FA', 'genblk1.fa', dest=TEMPLATE, footprint='FA:genblk1.fa')
    setattr(FA_genblk1_fa_FA_genblk1_fa, 'F0', 'U')
    setattr(FA_genblk1_fa_FA_genblk1_fa, 'Reference', 'U')
    setattr(FA_genblk1_fa_FA_genblk1_fa, 'F1', 'genblk1.fa')
    setattr(FA_genblk1_fa_FA_genblk1_fa, 'Value', 'genblk1.fa')


    #===============================================================================
    # Component instantiations.
    #===============================================================================

    A_0_ = FA_INPUT_FA_INPUT(ref='A[0]', value='INPUT')

    A_1_ = FA_INPUT_FA_INPUT(ref='A[1]', value='INPUT')

    A_2_ = FA_INPUT_FA_INPUT(ref='A[2]', value='INPUT')

    A_3_ = FA_INPUT_FA_INPUT(ref='A[3]', value='INPUT')

    Add_0__genblk1_fa = FA_genblk1_fa_FA_genblk1_fa(ref='Add[0].genblk1.fa', value='FA')

    Add_1__genblk1_fa = FA_genblk1_fa_FA_genblk1_fa(ref='Add[1].genblk1.fa', value='FA')

    Add_2__genblk1_fa = FA_genblk1_fa_FA_genblk1_fa(ref='Add[2].genblk1.fa', value='FA')

    Add_3__genblk1_fa = FA_genblk1_fa_FA_genblk1_fa(ref='Add[3].genblk1.fa', value='FA')

    B_0_ = FA_INPUT_FA_INPUT(ref='B[0]', value='INPUT')

    B_1_ = FA_INPUT_FA_INPUT(ref='B[1]', value='INPUT')

    B_2_ = FA_INPUT_FA_INPUT(ref='B[2]', value='INPUT')

    B_3_ = FA_INPUT_FA_INPUT(ref='B[3]', value='INPUT')

    ci = FA_INPUT_FA_INPUT(ref='ci', value='INPUT')

    co = FA_OUTPUT_FA_OUTPUT(ref='co', value='OUTPUT')

    out_0_ = FA_OUTPUT_FA_OUTPUT(ref='out[0]', value='OUTPUT')

    out_1_ = FA_OUTPUT_FA_OUTPUT(ref='out[1]', value='OUTPUT')

    out_2_ = FA_OUTPUT_FA_OUTPUT(ref='out[2]', value='OUTPUT')

    out_3_ = FA_OUTPUT_FA_OUTPUT(ref='out[3]', value='OUTPUT')


    #===============================================================================
    # Net interconnections between instantiated components.
    #===============================================================================

    Net('A[0]').connect(A_0_['1'], Add_0__genblk1_fa['2'])

    Net('A[1]').connect(A_1_['1'], Add_1__genblk1_fa['2'])

    Net('A[2]').connect(A_2_['1'], Add_2__genblk1_fa['2'])

    Net('A[3]').connect(A_3_['1'], Add_3__genblk1_fa['2'])

    Net('Add[0].c_out').connect(Add_0__genblk1_fa['5'], Add_1__genblk1_fa['1'])

    Net('Add[1].c_out').connect(Add_1__genblk1_fa['5'], Add_2__genblk1_fa['1'])

    Net('Add[2].c_out').connect(Add_2__genblk1_fa['5'], Add_3__genblk1_fa['1'])

    Net('Add[3].c_out').connect(Add_3__genblk1_fa['5'])

    Net('B[0]').connect(Add_0__genblk1_fa['3'], B_0_['1'])

    Net('B[1]').connect(Add_1__genblk1_fa['3'], B_1_['1'])

    Net('B[2]').connect(Add_2__genblk1_fa['3'], B_2_['1'])

    Net('B[3]').connect(Add_3__genblk1_fa['3'], B_3_['1'])

    Net('ci').connect(Add_0__genblk1_fa['1'], ci['1'])

    Net('co').connect(co['1'])

    Net('out[0]').connect(Add_0__genblk1_fa['4'], out_0_['1'])

    Net('out[1]').connect(Add_1__genblk1_fa['4'], out_1_['1'])

    Net('out[2]').connect(Add_2__genblk1_fa['4'], out_2_['1'])

    Net('out[3]').connect(Add_3__genblk1_fa['4'], out_3_['1'])


#===============================================================================
# Instantiate the circuit and generate the netlist.
#===============================================================================

if __name__ == "__main__":
    __main_py()
    generate_netlist()
