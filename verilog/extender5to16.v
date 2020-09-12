module extender5to16 (in, sign_extend, out);
  
  input [4:0] in;
  input sign_extend;
  output [15:0] out;
  
  assign out = (sign_extend) ? {{11{in[4]}}, in[4:0]} : {11'b0, in[4:0]};
  
endmodule