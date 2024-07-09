# Multi-Cycle 32-bit RISC-V CPU

  

## About This Repository

  

The goal of this repository is to maintain a record of:

  

1. Development of a pipelined multi-cycle RISC-V core

2. Development of framework/interface to core to be used by other projects

  

## Where to Find Everything

  

- If you are interested in seeing the source files for the basic and experimental blocks, go to `RISC-V.srcs/sources_1/new/`
- If you wish to run your own program, put the 32-Bit RISC-V Instruction hex in the `/instructions.hex` file and run the `make convert` target to convert the instructions to a format that is compatible with the byte addressable ROM
- You can find a description of each block and its status, as either `verified` or `dev`, below
	
##	Instructions Supported

- **R_Type**
	-	add
	-	sub
	-	or
	-	and
	
- **I_Type**
	-	Arithmetic and Logical Instructions
			-	addi
			-	ori
			-	andi
			
	-	Memory Instructions
			-	lw
			
- **S_Type**
	-	sw
	
- **B_Type**
	-	beq

- **UJ_Type**
	-	jal

## Block Descriptions and Status

  
|                |Description                    |Status                       |
|----------------|-------------------------------|-----------------------------|
| ALU			 |Handles the arithmetic and logical computations of the core | `verified`|
| control		 |Handles multiplexing of control signals for instructions mentioned in the section above | `verified`|
|register_file   |Manages the reading and writing to 32x 32-bit wide registers|`verified`        |
|PC (Program Counter)		         |Stores the address to the current instruction and manages different possible branches of the PC|`verified`|
|data_memory     |Internal 16KB RAM used to store all data memory|`verified`|
|instruction_memory|Internal 16KB ROM Initialized with instructions from `/instructions_8.hex`|`verified`|
|immediate_generator|Extracts and routes immediate from all 32-bit RISC-V instruction types|`verified`|
|ALU_control     | Sets ALU operation based on ALU_op control signal, funct3, and the funct7 of different instructions|`verified`|