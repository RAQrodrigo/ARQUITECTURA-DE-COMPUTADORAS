module execute #(parameter int N = 64) (
	input logic AluSrc,
	input logic [4:0]AluControl,
	input logic [63:0]PC_E,
	input logic [63:0]signImm_E,
	input logic [63:0]readData1_E,
	input logic [63:0]readData2_E,
	output logic [63:0]PCBranch_E,
	output logic [63:0]aluResult_E,
	output logic [63:0]writeData_E,
	output logic zero_E,
	output logic [3:0]CPSR_flags,
	output logic write_flags
);
	//variables
	logic [63:0]output_sl2;
	logic [63:0]output_mux2;
	
//tenemos un shift_2 que tiene como entrada: signImm_E.
	sl2 sl2_for_adder(.a(signImm_E),.y(output_sl2));
//tenemos un ADD donde las entradas son: PC_E, y la salida de shift_2.
	adder sum_shift(.a(PC_E),.b(output_sl2),.y(PCBranch_E));
//tenemos un MUX que tiene como entrada: signImm_E, readData2_E y AluSrc.
	mux2 MUX_for_ALU(.d0(readData2_E),.d1(signImm_E),.s(AluSrc),.y(output_mux2));
//tenemos un ALU que tenemos como entrada: readData1_E, la salida del MUX anterior y AluControl .
	alu ALU_for_Result(.a(readData1_E),.b(output_mux2),.ALUc(AluControl),.result(aluResult_E),.zero(zero_E),.CPSR_flags(CPSR_flags),.write_flags(write_flags));
	
	assign writeData_E = readData2_E;
		
endmodule
