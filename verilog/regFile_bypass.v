/*
   CS/ECE 552, Spring '20
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module regFile_bypass (
                       // Outputs
                       read1Data, read2Data, err,
                       // Inputs
                       clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                       );
   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */
   wire [15:0] r_out1, r_out2;
   
   regFile registerFile(.read1Data(r_out1), .read2Data(r_out2), .err(err), .clk(clk), .rst(rst),
				.read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel),
				.writeData(writeData), .writeEn(writeEn));

   assign read1Data = (writeEn && (writeRegSel == read1RegSel)) ? writeData : r_out1;
   assign read2Data = (writeEn && (writeRegSel == read2RegSel)) ? writeData : r_out2;

endmodule
