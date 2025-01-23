module alu_tb();

	//Seteo variables para mi test 
	logic [31:0] errors;
	logic [63:0] yexpected;
	logic [196:0] inputs_expectedoutputs [14:0];
	
	//Seteo todos los inputs y outputs para los casos de test
	initial begin 
		inputs_expectedoutputs = {
			//a       b         control  result    zero
			{64'd239, 64'd26  , 4'b0000, 64'd10  , 1'b0}, // &
			{64'd239, 64'd26  , 4'b0001, 64'd255 , 1'b0}, // |
			{64'd239, 64'd26  , 4'b0010, 64'd265 , 1'b0}, // +
			{64'd239, 64'd26  , 4'b0110, 64'd213 , 1'b0}, // -
			{64'd239, 64'd26  , 4'b0111, 64'd26  , 1'b0}, // pass b

			{-64'd98, -64'd407, 4'b0000, -64'd504, 1'b0}, // &
			{-64'd98, -64'd407, 4'b0001, -64'd1  , 1'b0}, // |
			{-64'd98, -64'd407, 4'b0010, -64'd505, 1'b0}, // +
			{-64'd98, -64'd407, 4'b0110, 64'd309 , 1'b0}, // -
			{-64'd98, -64'd407, 4'b0111, -64'd407, 1'b0}, // pass b

			{64'd930, -64'd33 , 4'b0000, 64'd898 , 1'b0}, // &
			{64'd930, -64'd33 , 4'b0001, -64'd1  , 1'b0}, // |
			{64'd930, -64'd33 , 4'b0010, 64'd897 , 1'b0}, // +
			{64'd930, -64'd33 , 4'b0110, 64'd963 , 1'b0}, // -
			{64'd930, -64'd33 , 4'b0111, -64'd33 , 1'b0}  // pass b
		};
		
		errors = 0;
	end
	
	//Seteo variales para instanciar
	logic [63:0] a;
	logic [63:0] b;
	logic [3:0]ALUc;
	logic [63:0] result, expected_result;
	logic zero, expected_zero;
	
	//Instancio alu
	alu dut(a, b, ALUc, result, zero);
	
	//
	always begin
	
		for (int i=0; i<15; ++i) begin
		
			/*
				Luego de una unidad de tiempo, asigno los valores de inputs_expout 
				a las variables expected para compararlas con el resultado de instanciar alu
			*/
			#1ns;
			{a, b, ALUc, expected_result, expected_zero} = inputs_expectedoutputs[i];
			#1ns;
			
			if (result !== expected_result) begin
				$display("ERROR: result: %d !== expected_result: %d, with i = %d\n", result, expected_result, i);
				errors++;
			end
			if (zero !== expected_zero) begin
				$display("ERROR: zero: %d !== expected_zero: %d, with i = %d\n", zero, expected_zero, i);
				errors++;
			end
			#1ns;
			$display("result: %d ; expected_result: %d ; with i = %d \n", result, expected_result, i);
		end
		
		if (errors === 0) $display("All ok!\n"); 
		else $display("Total errors: %d\n", errors);
		
		$stop;
		
	end
	
endmodule