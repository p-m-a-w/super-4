.PHONY: tests simulation

TESTS_DIR = tests
TESTS_SRC = $(wildcard $(TESTS_DIR)/*.v)
TESTS = $(patsubst $(TESTS_DIR)/%.v,%,$(TESTS_SRC))

OUTPUT_DIR = $(shell pwd)/build
SIMULATION_DIR = simulation

tests: $(TESTS)

%: $(TESTS_DIR)/%.v
	@ mkdir -p $(OUTPUT_DIR)
	iverilog -o $(OUTPUT_DIR)/$@ $<

sim_%: %
	@ mkdir -p $(SIMULATION_DIR)
	cd $(SIMULATION_DIR) && vvp -n $(OUTPUT_DIR)/$<

SIMS = $(patsubst $(TESTS_DIR)/%.v,sim_%,$(TESTS_SRC))
simulation: tests $(SIMS)
	