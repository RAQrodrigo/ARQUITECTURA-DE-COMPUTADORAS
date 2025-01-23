// ALU CONTROL DECODER

module aludec (input  logic [10:0] funct,  
					input  logic [1:0]  aluop,  
					output logic [4:0] alucontrol);  
					
	// Constantes para instrucciones				
	logic [10:0]ADD 	= 11'b100_0101_1000;
	logic [10:0]SUB 	= 11'b110_0101_1000;
	logic [10:0]AND 	= 11'b100_0101_0000;
	logic [10:0]ORR 	= 11'b101_0101_0000;
	logic [10:0]ADDS 	= 11'b101_0101_1000;
	logic [10:0]SUBS 	= 11'b111_0101_1000;
	logic [9:0]ADDI	= 10'b100_1000_100;
	logic [9:0]SUBI	= 10'b110_1000_100;
	logic [9:0]ADDIS	= 10'b101_1000_100;
	logic [9:0]SUBIS	= 10'b111_1000_100;
	
	always_comb
		if (aluop == 2'b00) alucontrol = 5'b00010;			// LDUR or STUR		
		else if (aluop == 2'b01) alucontrol = 5'b00111; 	//CBZ
		else if((aluop == 2'b10)  & (funct == ADD)) alucontrol = 5'b00010;	
		else if((aluop == 2'b10)  & (funct == SUB)) alucontrol = 5'b00110;	
		else if((aluop == 2'b10)  & (funct == AND)) alucontrol = 5'b00000;	
		else if((aluop == 2'b10)  & (funct == ORR)) alucontrol = 5'b00001;		   
		else if((aluop == 2'b10)  & (funct[10:1] == ADDI)) alucontrol = 5'b00010;	
		else if((aluop == 2'b10)  & (funct[10:1] == SUBI)) alucontrol = 5'b00110;	  	
		else if((aluop == 2'b10)  & (funct[10:1] == ADDIS)) alucontrol = 5'b10010;	
		else if((aluop == 2'b10)  & (funct[10:1] == SUBIS)) alucontrol = 5'b10010;	
		else if((aluop == 2'b10)  & (funct == ADDS)) alucontrol = 5'b10010;
		else if((aluop == 2'b10)  & (funct == SUBS)) alucontrol = 5'b10110;
		else alucontrol = 5'b00000;
endmodule