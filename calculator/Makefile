# Струйный калькулятор: моделирование, сверка и подсчёт элементов.
#   make model    — тесты эталонной модели, проверка нетлиста, сверка RTL-зеркала (Python)
#   make rtl      — тестбенч высокоуровневой модели (iverilog)
#   make netlist  — тестбенч структурного нетлиста с генератором фаз (iverilog)
#   make cosim    — сверка нетлиста и высокоуровневой модели такт в такт (iverilog)
#   make stat     — подсчёт элементов по даям и блокам (yosys)
#   make regen    — перегенерировать нетлист и тестбенчи из модели
#   make all      — всё, кроме regen

IVERILOG ?= iverilog
VVP      ?= vvp
YOSYS    ?= yosys
PYTHON   ?= python3
BUILD    := build

CELLS   := netlist/cells/fluidic_cells.v
NETLIST := $(wildcard netlist/d*.v) $(wildcard netlist/b*.v) netlist/fluidic_calc_top.v
RTL     := rtl/fluidic_calc_rtl.v

.PHONY: all model rtl netlist cosim stat regen clean

all: model rtl netlist cosim stat

$(BUILD):
	mkdir -p $(BUILD)

model:
	cd model && $(PYTHON) test_model.py && $(PYTHON) check_netlist.py && $(PYTHON) rtl_model.py

rtl: | $(BUILD)
	$(IVERILOG) -g2005 -I rtl -o $(BUILD)/tb_rtl $(RTL) rtl/tb_rtl.v
	$(VVP) -n $(BUILD)/tb_rtl | tee $(BUILD)/tb_rtl.log
	grep -q "РЕЗУЛЬТАТ: OK" $(BUILD)/tb_rtl.log

netlist: | $(BUILD)
	$(IVERILOG) -g2005 -I rtl -o $(BUILD)/tb_netlist $(CELLS) $(NETLIST) netlist/tb_netlist.v
	$(VVP) -n $(BUILD)/tb_netlist | tee $(BUILD)/tb_netlist.log
	grep -q "РЕЗУЛЬТАТ: OK" $(BUILD)/tb_netlist.log

cosim: | $(BUILD)
	$(IVERILOG) -g2005 -I rtl -o $(BUILD)/tb_cosim $(CELLS) $(NETLIST) $(RTL) netlist/tb_cosim.v
	$(VVP) -n $(BUILD)/tb_cosim | tee $(BUILD)/tb_cosim.log
	grep -q "РЕЗУЛЬТАТ: OK" $(BUILD)/tb_cosim.log

stat: | $(BUILD)
	$(YOSYS) -q -p "read_verilog -DSYNTHESIS $(CELLS) $(NETLIST); hierarchy -top fluidic_calc_top; tee -o $(BUILD)/stat.txt stat"
	$(YOSYS) -q -p "read_verilog $(RTL); synth -top fluidic_calc_rtl; tee -o $(BUILD)/rtl_synth.txt stat"
	tail -n 40 $(BUILD)/stat.txt

regen:
	cd model && $(PYTHON) gen_netlist.py && $(PYTHON) gen_testbenches.py

clean:
	rm -rf $(BUILD)
