module decoder3_8(sel, out0, out1, out2, out3, out4, out5, out6, out7, err);

	input [2:0] sel;
	output out0, out1, out2, out3, out4, out5, out6, out7, err;
	
	assign out0 = (sel == 0) ? 1 : 0;
	assign out1 = (sel == 1) ? 1 : 0;
	assign out2 = (sel == 2) ? 1 : 0;
	assign out3 = (sel == 3) ? 1 : 0;
	assign out4 = (sel == 4) ? 1 : 0;
	assign out5 = (sel == 5) ? 1 : 0;
	assign out6 = (sel == 6) ? 1 : 0;
	assign out7 = (sel == 7) ? 1 : 0;

	assign err = (sel === 3'bx) ? 1 : 0;

endmodule