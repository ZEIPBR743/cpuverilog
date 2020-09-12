/*
    CS/ECE 552 Spring '20
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, rotate right, or shift right logical based
    on the Op() value that is passed in (2 bit number).  It uses these
    shifts to shift the value any number of bits between 0 and 15 bits.
 */
module shifter (In, Cnt, Op, Out);

   input [15:0]   In;
   input [3:0]   Cnt;
   input [1:0]   Op;
   output [15:0]  Out;

   /* YOUR CODE HERE */
   wire [15:0] out1, out2, out3;
   
   shift3 shift_3(.Out(out3), .In(In), .Op(Op), .shift(Cnt[3]));
   shift2 shift_2(.Out(out2), .In(out3), .Op(Op), .shift(Cnt[2]));
   shift1 shift_1(.Out(out1), .In(out2), .Op(Op), .shift(Cnt[1]));
   shift0 shift_0(.Out(Out), .In(out1), .Op(Op), .shift(Cnt[0]));
      
endmodule