/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
module fullAdder_1b(A, B, C_in, S, p, g);
    input  A, B;
    input  C_in;
    output S;
	output p, g;
	
	wire gRaw, pRaw;

    // YOUR CODE HERE
	xor3 ADD1(.in1(A), .in2(B), .in3(C_in), .out(S));
	
	nand2 NAND1(.in1(A), .in2(B), .out(gRaw));
	not1 NOT1(.in1(gRaw), .out(g));
	
	nor2 NOR1(.in1(A), .in2(B), .out(pRaw));
	not1 NOT2(.in1(pRaw), .out(p));
	
endmodule