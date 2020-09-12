/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1
    a 4-bit (quad) 4-1 Mux template
*/
module mux4_1_4b(InA, InB, InC, InD, S, Out);

    // parameter N for length of inputs and outputs (to use with larger inputs/outputs)
    parameter N = 4;

    input [N-1:0]   InA, InB, InC, InD;
    input [1:0]     S;
    output [N-1:0]  Out;

    // YOUR CODE HERE
	wire Out3, Out2, Out1, Out0;
	mux4_1 MUX1(.InA(InA[3]), .InB(InB[3]), .InC(InC[3]), .InD(InD[3]), .S(S), .Out(Out3));
	mux4_1 MUX2(.InA(InA[2]), .InB(InB[2]), .InC(InC[2]), .InD(InD[2]), .S(S), .Out(Out2));
	mux4_1 MUX3(.InA(InA[1]), .InB(InB[1]), .InC(InC[1]), .InD(InD[1]), .S(S), .Out(Out1));
	mux4_1 MUX4(.InA(InA[0]), .InB(InB[0]), .InC(InC[0]), .InD(InD[0]), .S(S), .Out(Out0));
	
	assign Out[3] = Out3;
	assign Out[2] = Out2;
	assign Out[1] = Out1;
	assign Out[0] = Out0;

endmodule