/*
   CS/ECE 552 Spring '20

   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the
                     processor.
*/
module memory (memen, address, WriteData, clk, rst, createdump, ReadData, Done, Stall, CacheHit, err, Rd, Wr, state);

   input Rd, Wr, memen, createdump;
   input [15:0] address, WriteData;
   input clk, rst;
   output Done, Stall, CacheHit, err;
   output [15:0] ReadData;
   output [2:0] state;

   mem_system mem_system(/*AUTOARG*/
      // Outputs
      .DataOut(ReadData), .Done(Done), .Stall(Stall), .CacheHit(CacheHit), .err(err), .state(state),
      // Inputs
      .Addr(address), .DataIn(WriteData), .Rd(Rd), .Wr(Wr), .createdump(createdump), .clk(clk), .rst(rst)
      );


endmodule
