module imem #(parameter int N = 32)(
	input logic [7:0]addr,
	output logic [N-1:0]q
);
	logic [N-1:0] mem [0:255];
	logic [7:0]max_mem = 8'd171;
	
	initial begin
		mem [0:170] = '{
			32'hf8000001, 32'hf8008002, 32'hf8000203,
		
			// TEST ADDI de prueba (X3 = X5 + 4) ; Guardamos el resultado de ADDI en MEM 22:0x9
			32'h910010a3, 
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80b0003,
			
			// TEST SUBI de prueba (X3 = X7 - 5) ; Guardamos el resultado de SUBI en MEM 23:0x2
			32'hd10014e3, 
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80b8003,
			
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			
			//TEST B.cond
			
			//TEST B.EQ y ADDIS
			//Si funciona: Guarda en Mem25 el valor 0xA y en Mem24 el valor 0x0
			32'hb1000003, //adds x3, x0, #0
			32'h540000a0, //b.eq
			32'h91000c63, //x3+8 si no toma el salto
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80c0003, //stur x3
			32'h8b0500a3, //add x3 = x5*2
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80c8003, //stur con x3*2

			32'h8b1f03ff, 32'h8b1f03ff, //nop
			
			//TEST B.NE y ADDS
			//Si funciona: Guarda en Mem27 el valor 0xB y en Mem26 el valor 0x0
			32'hab010003, //adds
			32'h540000a1, //b.ne
			32'h91002063, //x3+8 si no toma el salto 
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80d0003, //stur x3
			32'h8b0600a3, //add x3 = B
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80d8003, //stur x3 = B
			
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			
			//TEST B.LT y SUBS
			//Si funciona: Guarda en Mem29 el valor 0xC y en Mem28 el valor 0x0
			32'heb050023, //subs
			32'h540000ab, //b.lt
			32'h91002063, //x3+8 si no toma el salto
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80e0003, //stur x3
			32'h8b0700a3, //x3 = 5+7
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80e8003, //stur x3 = C
			
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			
			//TEST B.GT y SUBIS
			//Si funciona: Guarda en Mem31 el valor 0xD y en Mem30 el valor 0x0
			32'hf10004a3, //subis
			32'h540000ac, //b.gt
			32'h91002063, //x3+8 si no toma el salto
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80f0003, //stur x3
			32'h8b0800a3, //x3 = 5+8
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80f8003, //stur x3 = D
			
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			
			/*
			En los siguientes dos tests de branches, piso la memoria 30 y 31 en ambos ejemplos
			ya que el compilador de assembler legv8 no me deja pasar la memoria #248
			*/
			
			//TEST B.LO
			//Si funciona: Guarda en Mem31 el valor 0xE y en Mem30 el valor 0x0
			32'hf1000423, //addis
			32'h540000a3, //b.lo
			32'h91002063, //x3+8 si no toma el salto
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80f0003, //stur x3
			32'h8b0900a3, //x3 = 5+9
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80f8003, //stur x3 = D
			
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			
			//TEST B.HS
			//Si funciona: Guarda en Mem31 el valor 0xF y en Mem30 el valor 0x0
			32'hab0100a3, //adds
			32'h540000a2, //b.hs
			32'h91002063, //x3+8 si no toma el salto
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80f0003, //stur x3
			32'h8b0a00a3, //x3 = 5+10
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf80f8003, //stur x3 = D
			
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			
			32'h8b050083,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8018003, 32'hcb050083,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8020003, 32'hcb0a03e4,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8028004, 32'h8b040064, 
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8030004, 32'hcb030025,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8038005, 32'h8a1f0145, 
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8040005, 32'h8a030145,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8048005, 32'h8a140294, 
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8050014, 32'haa1f0166,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8058006, 32'haa030166, 
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8060006, 32'hf840000c,
			32'h8b1f03ff, 32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'h8b1f0187, 
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8068007, 32'hf807000c, 32'h8b0e01bf,
			32'hf807801f, 32'hb40000a0, 
			32'h8b1f03ff, 32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8080015, 32'hf8088015, 32'h8b0103e2,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hcb010042, 32'h8b0103f8,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf8090018, 32'h8b080000,
			32'hb4ffff42,
			32'h8b1f03ff, 32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf809001e, 32'h8b1e03de,
			32'h8b1f03ff,  //nop
			32'hcb1503f5, 32'h8b1403de,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf85f83d9, 32'h8b1e03de,
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'h8b1003de, 
			32'h8b1f03ff, 32'h8b1f03ff, //nop
			32'hf81f83d9, 32'hb400001f
		};
	end
	
	always_comb begin
		if (addr < max_mem) begin
			q = mem[addr];
		end else begin
			q = 'b0;
		end
	end
endmodule
