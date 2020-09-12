/*
* zeroth shifting mux, shift only one bit, input connections:
* in, 16 bits number for shiting
* sel, 2 bit selection connected to the opcode for
* 	op[00] Rotate left
* 	op[01] Shift left
* 	op[10] rotate right
* 	op[11] Shift right logical
* shift, determine whether to shift or not
* out, output
*/
module shift0(In, Op, shift, Out);

input [1:0] Op;
input shift;
input [15:0] In;
output[15:0]Out;


assign Out = shift ? Op[1] ? Op[0] ? {1'b0, In[15:1]}: // op[11]
             {In[0], In[15:1]} : // op[10]
             Op[0] ? {In[14:0], 1'b0}: // op[01]
             {In[14:0], In[15]}: // op[00]
             In; // no shift in this shifter

endmodule
