/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
module execute (ReadData1, ReadData2, immediate, ALUSrc, ALUOp, sign, invRs, invIn, Cin, wb_sel0, SLBI_sel, ex_result_sel, ex_result);

   // TODO: Your code here
   input [15:0] ReadData1, ReadData2;
   input [15:0] immediate;
   input [2:0] ALUOp;
   input ALUSrc, sign, invRs, invIn, Cin, SLBI_sel, ex_result_sel;
   input [1:0] wb_sel0;
   output [15:0] ex_result;
   
   wire [15:0] In, A_final, A_out;
   wire [15:0] result, WriteDataConditional;
   wire zero, negative, Cout;
   wire le; // less than or equal to
   wire Ofl;
   assign In = (ALUSrc == 0) ? immediate : ReadData2;
   
   shift3 shifter(.In(ReadData1), .Op(2'b01), .shift(1'b1), .Out(A_out));
   assign A_final = (SLBI_sel == 1) ? A_out : ReadData1;
   
   alu ALU(.InA(A_final), .InB(In), .Cin(Cin), .Op(ALUOp), .invA(invRs), .invB(invIn), .sign(sign), .Out(result), .Zero(zero), .Ofl(Ofl), .negative(negative), .Cout(Cout));
   assign le = zero | negative;
   assign WriteDataConditional = (wb_sel0 == 3) ? {15'b0, Cout} :
                                  ((wb_sel0 == 2) ? {15'b0, zero} :
								  ((wb_sel0 == 1) ? {15'b0, le} : {15'b0, negative}));
   assign ex_result = ex_result_sel ? result : WriteDataConditional;								  
endmodule
