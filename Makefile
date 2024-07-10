# Makefile
INPUT_FILE = instruction.hex
OUTPUT_FILE = instruction_8.hex
COUNT_FILE = line_count.vh
PYTHON_SCRIPT = hex32to8.py

convert:
	python $(PYTHON_SCRIPT) $(INPUT_FILE) $(OUTPUT_FILE) $(COUNT_FILE)

clean:
	rm -f $(OUTPUT_FILE) $(COUNT_FILE)