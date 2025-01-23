module maindec (
	input logic [10:0]Op,
	output logic Reg2Loc,
	output logic ALUSrc,
	output logic MemtoReg,
	output logic RegWrite,
	output logic MemRead,
	output logic MemWrite,
	output logic Branch,
	output logic condBranch,
	output logic [1:0]ALUOp
);

//constantes
	logic [10:0]LDUR = 11'b111_1100_0010;
	logic [10:0]STUR = 11'b111_1100_0000;
	logic [10:0]ADD = 11'b100_0101_1000;
	logic [10:0]SUB = 11'b110_0101_1000;
	logic [10:0]AND = 11'b100_0101_0000;
	logic [10:0]ORR = 11'b101_0101_0000;
	logic [10:0]ADDS 	= 11'b101_0101_1000;
	logic [10:0]SUBS 	= 11'b111_0101_1000;
	
	
	logic [9:0]LDURdec 	= 10'b0_1_1_1_1_0_0_0_00;
	logic [9:0]STURdec 	= 10'b1_1_0_0_0_1_0_0_00;
	logic [9:0]Rtype 		= 10'b0_0_0_1_0_0_0_0_10; 
	logic [9:0]CBZdec 	= 10'b1_0_0_0_0_0_1_0_01;
	logic [9:0]Itype 		= 10'b0_1_0_1_0_0_0_0_10;
	logic [9:0]Bcondtype = 10'b0_0_0_0_0_0_0_1_01;

	always_comb begin
		casez(Op)
			ADD,SUB,AND,ORR,ADDS,SUBS:begin
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,condBranch,ALUOp} = Rtype;
			end
			LDUR: begin
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,condBranch,ALUOp} = LDURdec;
			end
			STUR: begin
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,condBranch,ALUOp} = STURdec;
			end
			11'b101_1010_0???:begin //CBZ
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,condBranch,ALUOp} = CBZdec;
			end
			11'b10_0100_0100?,11'b11_0100_0100?,11'b101_1000_100?,11'b111_1000_100?:begin //ADDI,SUBI,ADDIS,SUBIS
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,condBranch,ALUOp} = Itype; 
			end
			11'b010_1010_0???:begin //B.cond
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,condBranch,ALUOp} = Bcondtype; 
			end
			default: begin
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,condBranch,ALUOp} = 10'b0000000000;
			end
			
		endcase
	end
endmodule
