module imem_tb();

	//Seteo variables para mi test
	parameter N = 32;
	logic [31:0] errors;
	logic [31:0] testvector [0:46];
	
	//Inicializo mi testvector:
	initial begin
		testvector = '{
			32'hf8000001,
			32'hf8008002,
			32'hf8000203,
			32'h8b050083,
			32'hf8018003,
			32'hcb050083,
			32'hf8020003,
			32'hcb0a03e4,
			32'hf8028004,
			32'h8b040064,
			32'hf8030004,
			32'hcb030025,
			32'hf8038005,
			32'h8a1f0145,
			32'hf8040005,
			32'h8a030145,
			32'hf8048005,
			32'h8a140294,
			32'hf8050014,
			32'haa1f0166,
			32'hf8058006,
			32'haa030166,
			32'hf8060006,
			32'hf840000c,
			32'h8b1f0187,
			32'hf8068007,
			32'hf807000c,
			32'h8b0e01bf,
			32'hf807801f,
			32'hb4000040,
			32'hf8080015,
			32'hf8088015,
			32'h8b0103e2,
			32'hcb010042,
			32'h8b0103f8,
			32'hf8090018,
			32'h8b080000,
			32'hb4ffff82,
			32'hf809001e,
			32'h8b1e03de,
			32'hcb1503f5,
			32'h8b1403de,
			32'hf85f83d9,
			32'h8b1e03de,
			32'h8b1003de,
			32'hf81f83d9,
			32'hb400001f
		};
		errors = 0;
	end
	
	//Inicializo las variables para instanciar
	logic [5:0] addr;
	logic [N-1:0] q;

	//Instancio imem
	imem #(N) dut (addr,q);
	
	always begin
	
		for (logic [5:0] i = '0; i<64; i++) begin

			addr = i;
			#1;

			if (i < 47) begin
				if(q !== testvector[i]) begin
					$display("ERROR: q=%d, testvector=%d, i = %d\n", q, testvector[i], i);
					errors = errors + 1;
				end
			end else begin
				if(q !== 0) begin
					$display("ERROR: q !== 0, i = %d\n", q, i);
					errors = errors + 1;
				end
			end

			$display("q=%d, testvector=%d, i = %d\n", q, testvector[i], i);
			#1;

			if (i==63) begin
				if (errors === 0) $display("All ok!\n"); 
				else $display("Total errors: %d\n", errors);
				$stop;
			end
		end
	end
	
endmodule