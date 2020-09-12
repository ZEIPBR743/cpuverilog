/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 16-bit CLA module
*/
module cla_16b(A, B, C_in, S, sign, Ofl, C_out);

    input [15: 0] A, B;
    input          C_in, sign;
    output [15:0] S;
	output         C_out, Ofl;

    // YOUR CODE HERE
	wire C1, C1_1, C1_2, C2, C2_1, C2_2, C3,C3_1, C3_2, C_out_1, C_out_2, G0, P0, G1, P1, G2, P2, G3, P3;
	nand2 NAND1(.in1(P0), .in2(C_in), .out(C1_1));
	not1 NOTC1(.in1(G0), .out(C1_2));
	nand2 NAND2(.in1(C1_2), .in2(C1_1), .out(C1)); 
	
	nand2 NAND3(.in1(P1), .in2(C1), .out(C2_1));
	not1 NOTC2(.in1(G1), .out(C2_2));
	nand2 NAND4(.in1(C2_2), .in2(C2_1), .out(C2)); 
	
	nand2 NAND5(.in1(P2), .in2(C2), .out(C3_1));
	not1 NOTC3(.in1(G2), .out(C3_2));
	nand2 NAND6(.in1(C3_2), .in2(C3_1), .out(C3));
	
	nand2 NAND7(.in1(P3), .in2(C3), .out(C_out_1));
	not1 NOTC4(.in1(G3), .out(C_out_2));
	nand2 NAND8(.in1(C_out_2), .in2(C_out_1), .out(C_out));
	
//	assign C1 = G0 | (P0 & C_in);
//	assign C2 = G1 | (P1 & C1);
//	assign C3 = G2 | (P2 & C2);
//	assign C_out = G3 | (P3 & C3);
		
	wire Ofl_sign, Ofl_unsign;
	
	assign Ofl_sign = ((A[15] == B[15]) && (A[15] == 0)) ? ((S[15] == 1) ? 1 : 0) : 
					(((A[15] == B[15]) && (A[15] == 1)) ? ((S[15] == 0) ? 1 : 0) : 0);
	assign Ofl_unsign = (C_out == 1) ? 1 : 0;
	assign Ofl = (sign == 1) ? Ofl_sign : Ofl_unsign;
	
	cla_4b block1(.A(A[3:0]), .B(B[3:0]), .C_in(C_in), .S(S[3:0]), .P(P0), .G(G0));
	cla_4b block2(.A(A[7:4]), .B(B[7:4]), .C_in(C1), .S(S[7:4]), .P(P1), .G(G1));
	cla_4b block3(.A(A[11:8]), .B(B[11:8]), .C_in(C2), .S(S[11:8]), .P(P2), .G(G2));
	cla_4b block4(.A(A[15:12]), .B(B[15:12]), .C_in(C3), .S(S[15:12]), .P(P3), .G(G3));
	
endmodule