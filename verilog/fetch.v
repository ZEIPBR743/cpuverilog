/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch(fetch_addr, inst, addr, JumpReg, Halt, clk, rst, err, ex_result, PC_addr, stall, state);

	output [15:0] fetch_addr, inst, PC_addr;
	output err, stall;
	output [2:0] state;
	input [15:0] addr;
	input [15:0] ex_result;
	input JumpReg, Halt;
	input clk, rst;
	
	wire [15:0] curr_PC, next_PC, next_addr;
	wire Ofl, C_out;
	wire pc_err, inst_err;
	wire cache_hit, done;
	wire [15:0] inst_inter;
	
	cla_16b adder(.A(curr_PC), .B(16'h0002), .C_in(1'b0), .S(PC_addr), .sign(1'b0), .Ofl(Ofl), .C_out(C_out));
	
	assign fetch_addr = (JumpReg) ? ex_result : PC_addr;
	assign next_addr = (JumpReg) ? fetch_addr : addr;
	assign next_PC = (Halt | stall) ? curr_PC : next_addr;
	
	register_16b PC(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(1'b1), .w_data(next_PC), .r_data(curr_PC), .err(pc_err));
   
	inst_mem instruction_mem(.DataOut(inst_inter), .DataIn(16'h0000), .Addr(curr_PC), .Rd(1'b1), .Wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst),
						.err(inst_err), .CacheHit(cache_hit), .Stall(stall), .Done(done), .state(state));
						
	assign err = pc_err | inst_err;
	assign inst = stall ? 16'h0800 : inst_inter;
   
endmodule
