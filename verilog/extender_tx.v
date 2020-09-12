module extender_tx();

	reg [7:0] in_8;
	reg [4:0] in_5;
	reg sign_extend;
	wire [15:0] out5_16;
	wire [15:0] out8_16;
	
	initial begin
		in_8 = 8'h13;
		in_5 = 5'h13;
		sign_extend = 0;
	end

	extender5to16 extender1(.in(in_5), .sign_extend(sign_extend), .out(out5_16));
	extender8to16 extender2(.in(in_8), .sign_extend(sign_extend), .out(out8_16));

endmodule