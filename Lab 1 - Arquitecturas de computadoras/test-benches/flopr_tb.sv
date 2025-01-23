module flopr_tb ();

	//Seteo las variables para el test
	parameter N = 64;
	logic clk, reset;
	logic [N-1:0] d;
	logic [N-1:0] q;
	
	//instancio flopr con el nombre: "device under test"
	flopr #(N) dut (clk, reset, d, q);
	
	// Vector que usaré para el test, errors para contabilizar errores, vectornum para traquear índice
	logic [31:0] vectornum, errors;
	logic [N-1:0] testvectors [9:0];
	
	//Genero el clock cada 10ns
		always begin
			clk = 1; #5ns; clk = 0; #5ns;
		end
	
	//Seteo el reset y las variables en default
		initial begin
			testvectors = '{  'b000_1,
									'b001_0,
									'b010_0,
									'b011_0,
									'b100_1,
									'b101_1,
									'b110_0,
									'b111_0,
									'b111_1,
									'b001_1};
			errors = 0; vectornum = 0;
			reset = '1; #50ns; 
			reset = '0;
		end
	
	//Asigno a d los valores del testvector por cada 10 u.t
		always @(posedge clk) begin
			d = testvectors[vectornum]; 	  
			#1ns;
		end
	
	/* 
		Display resultado y errores. El chequeo lo hago al flanco negativo del clock 
		(cuando ya se asignó el valor a qexpected) 
	*/
		always @(negedge clk) begin
			
			if(reset === '1) begin 
				if(q !== 0) begin
					$display ("Error: q !== 0");
					errors = errors + 1;
				end
			end
			if(reset === '0) begin 
				if(q !== testvectors[vectornum-1]) begin
					$display ("Error: q !== testvectors[vectornum-1]");
					errors = errors + 1;
				end
			end
				
			if(d === 'x) begin //Cuando se indexa fuera del rango:
				$display("tests completed with %d errors", errors);
				if(errors === 0) begin
					$display("All ok!");
				end
				//  $finish;
				$stop;
			end
			
			vectornum = vectornum + 1;
			$display("vectornum = %d", vectornum);
		end
	
endmodule