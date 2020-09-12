module register_3b(clk, rst, chosen, w_en, w_data, r_data, err);

	input clk, rst, chosen, w_en;
	input [2:0] w_data;
	output [2:0]r_data;
	output err;
	
	wire [2:0] in_data;
	
	assign in_data = (chosen & w_en) ? w_data : r_data;
	
	dff ff0(.d(in_data[0]), .q(r_data[0]), .clk(clk), .rst(rst));
	dff ff1(.d(in_data[1]), .q(r_data[1]), .clk(clk), .rst(rst));
	dff ff2(.d(in_data[2]), .q(r_data[2]), .clk(clk), .rst(rst));
	
	assign err = (w_en === 1'bx) ? 1 : 0;

endmodule