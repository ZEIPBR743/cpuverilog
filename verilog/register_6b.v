module register_6b(clk, rst, chosen, w_en, w_data, r_data, err);

	input clk, rst, chosen, w_en;
	input [5:0] w_data;
	output [5:0]r_data;
	output err;
	
	wire [5:0] in_data;
	
	assign in_data = (chosen & w_en) ? w_data : r_data;
	
	dff ff0(.d(in_data[0]), .q(r_data[0]), .clk(clk), .rst(rst));
	dff ff1(.d(in_data[1]), .q(r_data[1]), .clk(clk), .rst(rst));
	dff ff2(.d(in_data[2]), .q(r_data[2]), .clk(clk), .rst(rst));
	dff ff3(.d(in_data[3]), .q(r_data[3]), .clk(clk), .rst(rst));
	dff ff4(.d(in_data[4]), .q(r_data[4]), .clk(clk), .rst(rst));
	dff ff5(.d(in_data[5]), .q(r_data[5]), .clk(clk), .rst(rst));
	
	assign err = ((w_en === 1'bx) || (w_data === 6'bx)) ? 1 : 0;

endmodule