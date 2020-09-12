/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1
    4-1 mux template
*/
module mux4_1(InA, InB, InC, InD, S, Out);
    input        InA, InB, InC, InD;
    input [1:0]  S;
    output       Out;

    // YOUR CODE HERE
	// Selecting: 00 is InA, 11 is InD
	wire out0, out1;
	mux2_1 MUX1(.InA(InB), .InB(InA), .S(S[0]), .Out(out0));
	mux2_1 MUX2(.InA(InD), .InB(InC), .S(S[0]), .Out(out1));
	mux2_1 MUX3(.InA(out1), .InB(out0), .S(S[1]), .Out(Out));

endmodule