/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 1
    2-1 mux template
*/
module mux2_1(InA, InB, S, Out);
    input   InA, InB;
    input   S;
    output  Out;

    // YOUR CODE HERE
	// Selecting: 1 is A, 0 is B
	wire InA_n, InB_n, S_n,
		a1, a2, a3, a4, b1, b2, c1, c2, d;
	
	not1 NOT1(.in1(InA), .out(InA_n));
	not1 NOT2(.in1(InB), .out(InB_n));
	not1 NOT3(.in1(S), .out(S_n));
	
	nor3 NOR1(.in1(InA), .in2(InB_n), .in3(S), .out(a1));
	nor3 NOR2(.in1(InA_n), .in2(InB), .in3(S_n), .out(a2));
	nor3 NOR3(.in1(InA_n), .in2(InB_n), .in3(S), .out(a3));
	nor3 NOR4(.in1(InA_n), .in2(InB_n), .in3(S_n), .out(a4));
	
	nor2 NOR5(.in1(a1), .in2(a2), .out(b1));
	nor2 NOR6(.in1(a3), .in2(a4), .out(b2));
	not1 NOT4(.in1(b1), .out(c1));
	not1 NOT5(.in1(b2), .out(c2));
	
	nor2 NOR7(.in1(c1), .in2(c2), .out(d));
	not1 NOT6(.in1(d), .out(Out));
	

endmodule