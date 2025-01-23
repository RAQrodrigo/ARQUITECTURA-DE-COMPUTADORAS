module signext(input logic [31:0] a, 
	output logic [63:0] y
);

	logic [10:0] LDUR = 11'b111_1100_0010;
	logic [10:0] STUR = 11'b111_1100_0000;
	always_comb begin
		casez(a[31:21]) //opcode
			LDUR,STUR: begin
					y = {{55{a[20]}}, a[20:12]};
					end
			11'b101_1010_0???,11'b010_1010_0???: begin // CBZ,B_COND
					y = {{45{a[23]}}, a[23:5]};
					end
			11'b10_0100_0100?,
			11'b11_0100_0100?,
			11'b10_1100_0100?,
			11'b11_1100_0100?: begin //ADDI, SUBI, SUBIS, ADDIS
					y = {{52{a[21]}}, a[21:10]}; 
					end
			default: y = 0;
		endcase
	end
endmodule
