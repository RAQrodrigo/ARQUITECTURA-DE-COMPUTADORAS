module shift_2 #(parameter int N = 64)(
	input logic [N-1:0]a,
	output logic y
);
	assign y = a*2;
endmodule