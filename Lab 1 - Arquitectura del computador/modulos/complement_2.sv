module complement_2  #(parameter int N = 64) (
	input logic [N-1:0]b,
	output logic [N-1:0] result_cmp2
);
	 always_comb begin
        result_cmp2 = ~(b);
        result_cmp2 = result_cmp2 + 1;
    end 

endmodule
