module fetch #(parameter int N = 64)(
	input logic PCSrc_F,
	input logic clk,
	input logic reset,
	input logic [63:0]PCBranch_F,
	output logic [63:0]imem_addr_F
);
	
	logic [63:0]add_q = 64'b0;
	logic [63:0]pc_q = 64'b0;
	logic [63:0]mux_q = 64'b0;
	
	
	// el mux que tiene como entrada la salida del adder y PCBranch_F.
	mux2 multiplex (add_q,PCBranch_F,PCSrc_F,mux_q);
	// el ff que tiene como entrada la salida del mux, o sea para ver si la siguiente linea es un salto o solo la siguiente.
	flopr ProxgramCounter (clk,reset,mux_q,pc_q);
	// el adder para sumar los 4 bits del pc, la salida va a la entrada del mux.
	adder add_pc(pc_q,64'b100,add_q);
	
	assign imem_addr_F = pc_q;
	
endmodule