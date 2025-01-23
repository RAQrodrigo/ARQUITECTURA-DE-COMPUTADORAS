module maindec_tb();

	logic [10:0] opcode;

	logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
	logic [1:0] ALUOp;

	maindec dut(
		.Op(opcode),
		.Reg2Loc(Reg2Loc), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
		.MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .ALUOp(ALUOp)
	);

	logic expected_Reg2Loc, expected_ALUSrc, expected_MemtoReg, expected_RegWrite, expected_MemRead, expected_MemWrite, expected_Branch;
	logic [1:0] expected_ALUOp;


	logic [19:0] inputs_and_expected_outputs [0:6] = '{
		{11'b111_1100_0010, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00}, // LDUR
		{11'b111_1100_0000, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00}, // STUR
		{11'b101_1010_0000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 2'b01}, // CBZ
		{11'b100_0101_1000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}, // ADD
		{11'b110_0101_1000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}, // SUB
		{11'b100_0101_0000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}, // AND
		{11'b101_0101_0000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}  // ORR
	};

		int errors;
		initial begin
		errors = 0;

		for (int i = 0; i < 7; ++i) begin
			#1ns;
			{opcode, expected_Reg2Loc, expected_ALUSrc, expected_MemtoReg, expected_RegWrite, expected_MemRead, expected_MemWrite, expected_Branch, expected_ALUOp} =
				inputs_and_expected_outputs[i];
			
			#1ns;

			// Comparación individual de cada señal
			if (Reg2Loc !== expected_Reg2Loc) begin
				errors++;
				$display("ERROR: i = %d, Reg2Loc esperado = %b, obtenido = %b", i, expected_Reg2Loc, Reg2Loc);
			end

			if (ALUSrc !== expected_ALUSrc) begin
				errors++;
				$display("ERROR: i = %d, ALUSrc esperado = %b, obtenido = %b", i, expected_ALUSrc, ALUSrc);
			end

			if (MemtoReg !== expected_MemtoReg) begin
				errors++;
				$display("ERROR: i = %d, MemtoReg esperado = %b, obtenido = %b", i, expected_MemtoReg, MemtoReg);
			end

			if (RegWrite !== expected_RegWrite) begin
				errors++;
				$display("ERROR: i = %d, RegWrite esperado = %b, obtenido = %b", i, expected_RegWrite, RegWrite);
			end

			if (MemRead !== expected_MemRead) begin
				errors++;
				$display("ERROR: i = %d, MemRead esperado = %b, obtenido = %b", i, expected_MemRead, MemRead);
			end

			if (MemWrite !== expected_MemWrite) begin
				errors++;
				$display("ERROR: i = %d, MemWrite esperado = %b, obtenido = %b", i, expected_MemWrite, MemWrite);
			end

			if (Branch !== expected_Branch) begin
				errors++;
				$display("ERROR: i = %d, Branch esperado = %b, obtenido = %b", i, expected_Branch, Branch);
			end

			if (ALUOp !== expected_ALUOp) begin
				errors++;
				$display("ERROR: i = %d, ALUOp esperado = %b, obtenido = %b", i, expected_ALUOp, ALUOp);
			end
		end

		$display("Total errors = %d", errors);
	end

endmodule