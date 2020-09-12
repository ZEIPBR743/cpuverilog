module register_1b(clk, rst, chosen, w_en, w_data, r_data, err);

	input clk, rst, chosen, w_en;
	input w_data;
	output r_data;
	output err;
	
	wire in_data;
	
	assign in_data = (chosen & w_en) ? w_data : r_data;
	
	dff ff0(.d(in_data), .q(r_data), .clk(clk), .rst(rst));
	
	assign err = (w_en === 1'bx) ? 1 : 0;

endmodule