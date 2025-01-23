module bcondcheck (
	input logic write_flags,
	input logic[3:0]CPSR_flags,
	input logic [4:0]b_cond,
	output logic branch
);
// si se actualizaron las flags debe actualizar las flags.

//constantes para condiciones
	logic [4:0] EQ = 5'b00000;
	logic [4:0] NE = 5'b00001;
	logic [4:0] HS = 5'b00010;
	logic [4:0] LO = 5'b00011;
	logic [4:0] MI = 5'b00100;
	logic [4:0] PL = 5'b00101;
	logic [4:0] VS = 5'b00110;
	logic [4:0] VC = 5'b00111;
	logic [4:0] HI = 5'b01000;
	logic [4:0] LS = 5'b01001;
	logic [4:0] GE = 5'b01010;
	logic [4:0] LT = 5'b01011;
	logic [4:0] GT = 5'b01100;
	logic [4:0] LE = 5'b01101;

// banco para guardar flags
	logic Z_flag = 0; // zero
	logic N_flag = 0; // negative
	logic C_flag = 0; // carry
	logic V_flag = 0; // overflow
	 
	always_ff @(posedge write_flags) begin
		Z_flag <= CPSR_flags[3];
		N_flag <= CPSR_flags[2];
		C_flag <= CPSR_flags[1];
		V_flag <= CPSR_flags[0];
	end

	always_comb begin
	branch = 0;
		case(b_cond)
			EQ: branch = Z_flag == 1;
			NE: branch = Z_flag == 0;
			LT: branch = (N_flag != V_flag);
			LE: branch = !((Z_flag == 0) && (N_flag == V_flag));
			GT: branch = (Z_flag == 0) && (N_flag == V_flag);
			GE: branch = N_flag == V_flag;
			LO: branch = C_flag == 0;
			LS: branch = !(Z_flag == 0 && C_flag == 1);
			HI: branch = (Z_flag == 0 && C_flag == 1);
			HS: branch = C_flag == 1;
			MI: branch = N_flag == 1;
			PL: branch = N_flag == 0;
			VS: branch = V_flag == 1;
			VC: branch = V_flag == 0;
			default: branch = 0;
		endcase
	end

endmodule