module alu (
	input logic [63:0]a,
	input logic [63:0]b,
	input logic [4:0]ALUc,
	output logic [63:0]result,
	output logic zero,
	output logic [3:0]CPSR_flags,
	output logic write_flags
); 

		logic [64:0] op_result; // Debería ser usado SÓLO en suma ? CHEQUEAR
		logic signed [63:0] a_sign, b_sign, result_sign;
		logic update_flags;
		logic [63:0]result_cmp2 = 0;
		
		complement_2 #(64) cmp_2 (.b(b), .result_cmp2(result_cmp2)); //CHEQUEAR FUNCIONALIDAD COMP 2
		
	always_comb begin
		update_flags = ALUc[4];
		CPSR_flags = 4'b0000;
		write_flags = 0;
		zero = 0;
		result = 64'b0;
		op_result = 65'b0;
		a_sign = 64'b0; 
		b_sign = 64'b0;
		result_sign = 64'b0;
		
		case(ALUc)
			//AND
			5'b00000: result = a & b;
			
			//OR
			5'b00001: result = a | b;
			
			//ADD, ADDS, ADDIS
			5'b00010,5'b10010: begin
				op_result = a + b;
				result = op_result[63:0];
			end
			
			//SUB, SUBI, SUBIS
			5'b00110,5'b10110: begin
				op_result = a + result_cmp2;				
				result = op_result[63:0];
			end
			
			//PASS
			5'b00111: result = b;
			
			//DEFAULT
			default: result = '0;
			
		endcase;
		
		//para cbz
		zero = (result == 0);
		
		  // flags
		if (update_flags) begin
			CPSR_flags[1] = op_result[64]; // Flag de Carry - Chequear
			CPSR_flags[3] = (result == 0); // Flag de 0 - Bien
			CPSR_flags[2] = result[63]; // Flag de negativo - Bien
			a_sign = a;
         b_sign = b;
			result_sign = a_sign + b_sign;
			CPSR_flags[0] = (a_sign[63] == b_sign[63]) && 
				(a_sign[63] != result_sign[63]); // Flag de Overflow - Parece que Bien
			write_flags = 1;
		end
		
	end
endmodule