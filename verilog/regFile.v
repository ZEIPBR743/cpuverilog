/*
   CS/ECE 552, Spring '20
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

	/* the width */
	parameter W = 16;

	input        clk, rst;
	input [2:0]  read1RegSel;
	input [2:0]  read2RegSel;
	input [2:0]  writeRegSel;
	input [W-1:0] writeData;
	input        writeEn;

	output [W-1:0] read1Data;
	output [W-1:0] read2Data;
	output        err;

	/* YOUR CODE HERE */
	wire [7:0] chosen;
	wire [W-1:0] readData0, readData1, readData2, readData3, readData4, readData5, readData6, readData7;
	wire [8:0] error;
	
	decoder3_8 writedec(.sel(writeRegSel), .out0(chosen[0]), .out1(chosen[1]),
		.out2(chosen[2]), .out3(chosen[3]), .out4(chosen[4]), .out5(chosen[5]), .out6(chosen[6]), .out7(chosen[7]), .err(error[8]));
	
	register_16b reg0(.clk(clk), .rst(rst), .chosen(chosen[0]), .w_en(writeEn), .w_data(writeData), .r_data(readData0), .err(error[7]));
	register_16b reg1(.clk(clk), .rst(rst), .chosen(chosen[1]), .w_en(writeEn), .w_data(writeData), .r_data(readData1), .err(error[6]));
	register_16b reg2(.clk(clk), .rst(rst), .chosen(chosen[2]), .w_en(writeEn), .w_data(writeData), .r_data(readData2), .err(error[5]));
	register_16b reg3(.clk(clk), .rst(rst), .chosen(chosen[3]), .w_en(writeEn), .w_data(writeData), .r_data(readData3), .err(error[4]));
	register_16b reg4(.clk(clk), .rst(rst), .chosen(chosen[4]), .w_en(writeEn), .w_data(writeData), .r_data(readData4), .err(error[3]));
	register_16b reg5(.clk(clk), .rst(rst), .chosen(chosen[5]), .w_en(writeEn), .w_data(writeData), .r_data(readData5), .err(error[2]));
	register_16b reg6(.clk(clk), .rst(rst), .chosen(chosen[6]), .w_en(writeEn), .w_data(writeData), .r_data(readData6), .err(error[1]));
	register_16b reg7(.clk(clk), .rst(rst), .chosen(chosen[7]), .w_en(writeEn), .w_data(writeData), .r_data(readData7), .err(error[0]));
	
	assign read1Data = (read1RegSel == 0) ? readData0 : 
						( (read1RegSel == 1) ? readData1 :
						( (read1RegSel == 2) ? readData2 :
						( (read1RegSel == 3) ? readData3 :
						( (read1RegSel == 4) ? readData4 :
						( (read1RegSel == 5) ? readData5 :
						( (read1RegSel == 6) ? readData6 :
						( (read1RegSel == 7) ? readData7 : 0)))))));

	assign read2Data = (read2RegSel == 0) ? readData0 : 
						( (read2RegSel == 1) ? readData1 :
						( (read2RegSel == 2) ? readData2 :
						( (read2RegSel == 3) ? readData3 :
						( (read2RegSel == 4) ? readData4 :
						( (read2RegSel == 5) ? readData5 :
						( (read2RegSel == 6) ? readData6 :
						( (read2RegSel == 7) ? readData7 : 0)))))));

	assign err = |error;

endmodule
