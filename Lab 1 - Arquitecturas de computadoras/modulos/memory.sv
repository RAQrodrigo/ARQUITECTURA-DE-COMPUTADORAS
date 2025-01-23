// Etapa: MEMORY

module memory 	(	input logic Branch_M, zero_M,write_flags, B_cond_ctrl,
						input logic [3:0]CPSR_flags,
						input logic [4:0]b_cond,
						output logic PCSrc_M);
	logic is_branch;
	logic cbz_condition;
	logic branch_cond;
	
	bcondcheck checkCond (	.write_flags(write_flags),
									.CPSR_flags(CPSR_flags),
									.b_cond(b_cond),
									.branch(is_branch));
								
	assign cbz_condition = Branch_M & zero_M;
	
	assign branch_cond = is_branch & B_cond_ctrl;
	
	assign PCSrc_M = cbz_condition | branch_cond;
	

endmodule