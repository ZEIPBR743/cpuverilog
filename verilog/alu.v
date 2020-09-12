/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 2

    A 16-bit ALU module.  It is designed to choose
    the correct operation to perform on 2 16-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the 16-bit result
    of the operation, as well as output a Zero bit and an Overflow
    (OFL) bit.
*/
module alu (InA, InB, Cin, Op, invA, invB, sign, Out, Zero, Ofl, negative, Cout);
   
   input [15:0] InA;
   input [15:0] InB;
   input         Cin;
   input [2:0] Op;
   input         invA;
   input         invB;
   input         sign;
   output [15:0] Out;
   output         Ofl;
   output         Zero, negative, Cout;
   
   wire [1:0] Op_Code;
   wire [15:0] A, B;
   wire [15:0] out0, out1;
   wire ofl_arith;
   wire [3:0] Cnt;
   
   assign Op_Code = Op[1:0];
   
   inverter invert(.InA(InA), .InB(InB), .invA(invA), .invB(invB), .OutA(A), .OutB(B));
   arithmetics arith(.InA(A), .InB(B), .Cin(Cin), .Op_Code(Op_Code), .sign(sign), .Out(out1), .Ofl(Ofl_arith), .C_out(Cout));
   shifter shift(.In(A), .Cnt(B[3:0]), .Op(Op_Code), .Out(out0));
   
   assign Out = (Op[2] == 1) ? out1 : out0;
   assign Zero = (Out == 0) ? 1 : 0;
   assign Ofl = (Op[2] == 1) ? Ofl_arith : 0;
   
   // signed compare
   assign negative = (Ofl) ? ((A[15] == 1'b1) ? 1 : 0) : (((sign == 1) && (Out[15] == 1)) ? 1 : 0);
    
endmodule
