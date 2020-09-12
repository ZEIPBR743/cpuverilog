module inverter(InA, InB, invA, invB, OutA, OutB);

	input [15:0] InA, InB;
	input invA, invB;
	output [15:0] OutA, OutB;
	
	assign OutA = (invA == 1) ? ~InA : InA;
	assign OutB = (invB == 1) ? ~InB : InB;

endmodule