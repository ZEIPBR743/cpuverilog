/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2
    
    a 4-bit CLA module
*/
module cla_4b(A, B, C_in, S, P, G);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    input [N-1: 0] A, B;
    input          C_in;
    output [N-1:0] S;
	output P, G;

    // YOUR CODE HERE
	wire c1, c1_1, c1_2, c2, c2_1, c2_2, c3, c3_1, c3_2, g0, p0, g1, p1, g2, p2, g3, p3,
		P_r, P_l, G_B, G_B_r, G_C, G_C_r, G_D, G_D_R, G_D_L, G_r, G_l;
	
	nand2 NAND1(.in1(p0), .in2(C_in), .out(c1_1));
	not1 NOTC1(.in1(g0), .out(c1_2));
	nand2 NAND2(.in1(c1_2), .in2(c1_1), .out(c1)); 
	
	nand2 NAND3(.in1(p1), .in2(c1), .out(c2_1));
	not1 NOTC2(.in1(g1), .out(c2_2));
	nand2 NAND4(.in1(c2_2), .in2(c2_1), .out(c2)); 
	
	nand2 NAND5(.in1(p2), .in2(c2), .out(c3_1));
	not1 NOTC3(.in1(g2), .out(c3_2));
	nand2 NAND6(.in1(c3_2), .in2(c3_1), .out(c3)); 
	
	nand2 NAND7(.in1(p3), .in2(p2), .out(P_l));
	nand2 NAND8(.in1(p1), .in2(p0), .out(P_r));
	nor2 NOR1(.in1(P_l), .in2(P_r), .out(P));
	
	nand2 NAND9(.in1(p3), .in2(g2), .out(G_B_r));
	not1 NOT1(.in1(G_B_r), .out(G_B));
	
	nand3 NAND10(.in1(p3), .in2(p2), .in3(g1), .out(G_C_r));
	not1 NOT2(.in1(G_C_r), .out(G_C));

	nand2 NAND11(.in1(p3), .in2(p2), .out(G_D_L));
	nand2 NAND12(.in1(p1), .in2(g0), .out(G_D_R));
	nor2 NOR2(.in1(G_D_L), .in2(G_D_R), .out(G_D));
	
	nor2 NOR3(.in1(g3), .in2(G_B), .out(G_l));
	nor2 NOR4(.in1(G_C), .in2(G_D), .out(G_r));
	nand2 NAND13(.in1(G_l), .in2(G_r), .out(G));
	
//	assign c1 = g0 | (p0 & C_in);
//	assign c2 = g1 | (p1 & c1);
//	assign c3 = g2 | (p2 & c2);
//	assign P = p3 & p2 & p1 & p0;
//	assign G = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
	
	fullAdder_1b adder1(.A(A[0]), .B(B[0]), .C_in(C_in), .S(S[0]), .p(p0), .g(g0));
	fullAdder_1b adder2(.A(A[1]), .B(B[1]), .C_in(c1), .S(S[1]), .p(p1), .g(g1));
	fullAdder_1b adder3(.A(A[2]), .B(B[2]), .C_in(c2), .S(S[2]), .p(p2), .g(g2));
	fullAdder_1b adder4(.A(A[3]), .B(B[3]), .C_in(c3), .S(S[3]), .p(p3), .g(g3));

endmodule