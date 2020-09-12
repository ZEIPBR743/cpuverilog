module branch (out, imm, rs, en, op, pred_wrong);

	output [15:0] out;
	output pred_wrong;
	input [15:0] imm, rs;
	input [1:0] op;
	input en;

	wire [15:0] out0, out1, out2, out3, function_out;

	assign out0 = ~|rs ? imm : 0; // equals to zero?
	assign out1 = |rs  ? imm : 0; //not equal to zero?
	assign out2 = rs[15] ? imm : 0; // less than zero?
	assign out3 = ~rs[15] ? imm : 0; // greater or equal to zero?

	assign function_out = (op == 0) ? out0 : ((op == 1) ? out1 : ((op == 2) ? out2 : out3));
	assign out = (en == 1) ? function_out : 0;
	
	assign pred_wrong = (op == 0) ? ((~|rs) ? 1'b1 : 1'b0) : ((op == 1) ? ((|rs) ? 1'b1 : 1'b0) : ((op == 2) ? ((rs[15]) ? 1'b1 : 1'b0) : ((~rs[15]) ? 1'b1 : 1'b0)));

endmodule
