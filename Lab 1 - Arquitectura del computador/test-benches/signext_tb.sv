module signext_tb();
	
	//Seteo variables para mi test 
	logic [31:0] errors;
	logic [31:0] testvector [5:0];
	logic [63:0] yexpected [5:0];
	 
	//Seteo los inmediatos signados o no signados
	logic [8:0] pos_inmediato_LDURSTUR = 9'b0_1110_0011;
	logic [8:0] neg_inmediato_LDURSTUR = 9'b1_1110_0011;
	logic [18:0] pos_inmediato_CBZ = 19'b001_1110_0011_1111_1010;
	logic [18:0] neg_inmediato_CBZ = 19'b101_1110_0011_1111_1010;
	
	
	//Inicializo las variables
	initial begin
		// Inicializando los testvectors
		testvector[0] = {11'b111_1100_0010, pos_inmediato_LDURSTUR, 12'b00_01001_10110};
		testvector[1] = {11'b111_1100_0010, neg_inmediato_LDURSTUR, 12'b00_01001_10110};
		testvector[2] = {11'b111_1100_0000, pos_inmediato_LDURSTUR, 12'b00_01001_10110};
		testvector[3] = {11'b111_1100_0000, neg_inmediato_LDURSTUR, 12'b00_01001_10110};
		testvector[4] = {8'b101_1010_0, pos_inmediato_CBZ, 5'b10110};
		testvector[5] = {8'b101_1010_0, neg_inmediato_CBZ, 5'b10110};
		
		// Inicializando los valores esperados
		yexpected[0] = {{55{pos_inmediato_LDURSTUR[8]}}, pos_inmediato_LDURSTUR};
		yexpected[1] = {{55{neg_inmediato_LDURSTUR[8]}}, neg_inmediato_LDURSTUR};
		yexpected[2] = {{55{pos_inmediato_LDURSTUR[8]}}, pos_inmediato_LDURSTUR};
		yexpected[3] = {{55{neg_inmediato_LDURSTUR[8]}}, neg_inmediato_LDURSTUR};
		yexpected[4] = {{45{pos_inmediato_CBZ[18]}}, pos_inmediato_CBZ};
		yexpected[5] = {{45{neg_inmediato_CBZ[18]}}, neg_inmediato_CBZ};

		errors = 0;
	end
	
	//Seteo variales para instanciar
	logic [31:0] a;
	logic [63:0] y;
	
	// Instanciar el módulo signext
    signext dut (a, y);
	
	/* 
		La idea es recorrer tanto testvectors como yexpected e ir comparando.
		Asigno cada valor de testvectors a "a", y luego comparo con yexpected.
	*/
	always begin
		for (int i=0; i<6; ++i) begin
			a = testvector[i];
			#1ns;
			
			if (y !== yexpected[i]) begin
				$display("ERROR:\n  yexpected = %d, y = %d\n  a=%b", yexpected[i], y, a);
				errors = errors + 1;
			end
			
			$display("y = %d \n", y);
			$display("yexpected = %d \n", yexpected[i]);
		end
		
		if (errors === 0) $display("All ok!"); 
		else $display("Total errors: %d", errors);
		
		$stop;
	end
	 
endmodule