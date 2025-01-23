module execute_tb(
);

// setear variables.
	logic [31:0] errors;
	logic [63:0] yexpected [3:0];
	
	logic AluSrc;
	logic [3:0] AluControl;
	logic [63:0] PC_E;
	logic [63:0] signImm_E;
	logic [63:0] readData1_E;
	logic [63:0] readData2_E;

	logic [63:0] PCBranch_E;
	logic [63:0] aluResult_E;
	logic [63:0] writeData_E;
	logic zero_E;
	
	execute execute_tb_1(AluSrc,AluControl,PC_E,signImm_E,readData1_E,readData2_E,
	PCBranch_E,aluResult_E,writeData_E,zero_E);
	// seteo inputs y ouputs.
	initial begin
		AluSrc = 1; // Tendria que salir el valor de signImm_E
		AluControl = 4'b0111; // pass b
		PC_E = 64'b10;	// Esto entra al adder
		signImm_E = 64'b100; //Esto entra al sl2 y a mux como 1;
		readData1_E = 64'b1;
		readData2_E = 64'b101; // Esto va al mux como 0 y al writedata
		
		PCBranch_E = 64'b0;
		aluResult_E = 64'b0;
		writeData_E = 64'b0;
		zero_E = 1;
		
		yexpected[0] = 64'b10010;		//PCBranch_E
		yexpected[1] = 64'b100;			//aluResult_E
		yexpected[2] = 64'b101;			//writeData_E
		yexpected[3] =	0;					//zero_E
		
		errors = 0;
		#10ns;

		if (yexpected[0] !== PCBranch_E) begin
				$display("ERROR: PCBranch_E = %d, expected = %d", PCBranch_E, yexpected[0]);
				errors = errors + 1;
		  end
		if (yexpected[1] !== aluResult_E) begin
			$display("ERROR: aluResult_E = %d, expected = %d", aluResult_E, yexpected[1]);
			errors = errors + 1;
		end
		if (yexpected[2] !== writeData_E) begin
			$display("ERROR: writeData_E = %d, expected = %d", writeData_E, yexpected[2]);
			errors = errors + 1;
		end
		if (yexpected[3] !== zero_E) begin
			$display("ERROR: zero_E = %d, expected = %d", zero_E, yexpected[3]);
			errors = errors + 1;
		end

		if (errors === 0) begin
			$display("All's ok!");
		end else begin
			$display("Total errors: %d", errors);
		end

		$stop;
	end
endmodule