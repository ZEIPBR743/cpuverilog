module arithmetics(InA, InB, Cin, Op_Code, sign, Out, Ofl, C_out);
	
	input [15:0] InA, InB;
	input [1:0] Op_Code;
	input Cin, sign;
	output [15:0] Out;
	output Ofl;
	output C_out;
	
	wire [15:0] out0, out1, out2, out3;
	wire Ofl_adder;
	
	assign out1 = InA & InB;
	assign out2 = InA | InB;
	assign out3 = InA ^ InB;
	
	cla_16b adder(.A(InA), .B(InB), .C_in(Cin), .S(out0), .sign(sign), .Ofl(Ofl_adder), .C_out(C_out));
	
	assign Out = (Op_Code == 0) ? out0 : ((Op_Code == 1) ? out1 : ((Op_Code == 2) ? out2 : ((Op_Code == 3) ? out3 : 16'hffff)));
	assign Ofl = (Op_Code == 0) ? Ofl_adder : 0;

endmodule