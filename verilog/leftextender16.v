/*
16 bit extender on the left side
 input: in, input to be extended
 input: in_bit_num, amount of bits 
 input: sign_extend, 1 = sign extend, 0 = 0 bit extend
 output: out, 16 bits extended
 */
 
 module leftextender16 (in, in_bit_num, sign_extend, out);
  input[15:0] in;
  input[3:0] in_bit_num;
  input sign_extend;
  output[15:0] out;
 
 endmodule

