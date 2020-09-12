module ex_mem (wb_sel1_in, wb_sel_in, LBI_sel_in, BTR_sel_in, ex_result_in, PC_addr_in, immed_in, readData1_in,
      MemWrite_in, memen_in, createdump_in, WriteData_in,
      wb_sel1_o, wb_sel_o, LBI_sel_o, BTR_sel_o, ex_result_out, PC_addr_o, immed_o, readData1_o,
      MemWrite_o, memen_o, createdump_o, WriteData_o, JumpReg_in, JumpReg_out,
      clk, rst, w_en, err, write_from_mem_in, wreg_flag_in, reg_to_write_in, write_from_mem_o, wreg_flag_o, reg_to_write_o,
	  HaltRaw_in, HaltRaw_out, MemRead_in, MemRead_out, isBranch_in, isBranch_out);
	  
      parameter W = 16;

      // INPUTS
	  input JumpReg_in;
	  output JumpReg_out;
      // signals control this ex_mem pipeline registers
      input clk, rst, w_en;
      output err;
      // signals required by memory stage (pass into memory.v in proc.v)
      input MemWrite_in, memen_in, createdump_in, MemRead_in, isBranch_in;
      input [W-1:0] WriteData_in;
      // signals required by wb stage (pass into mem_wb pipeline in proc.v)
      // readData is not included here since it will be connected to memory.v's
      // output
      input wb_sel1_in, wb_sel_in, LBI_sel_in, BTR_sel_in, HaltRaw_in;
      input [W-1:0]  ex_result_in, PC_addr_in, immed_in, readData1_in;
      input write_from_mem_in, wreg_flag_in;
      input [2:0] reg_to_write_in;

      // OUTPUTS
      // every abve input reg needs an output reg
      output MemWrite_o, memen_o, createdump_o, HaltRaw_out, MemRead_out, isBranch_out;
      output [W-1:0] WriteData_o;
      output wb_sel1_o, wb_sel_o, LBI_sel_o, BTR_sel_o;
      output [W-1:0]  ex_result_out, PC_addr_o, immed_o, readData1_o;
      output write_from_mem_o, wreg_flag_o;
      output [2:0] reg_to_write_o;

      wire [18:0] error;

      //registers:
      register_1b MemWrite(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(MemWrite_in), .r_data(MemWrite_o), .err(error[0]));
      register_1b memen(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(memen_in), .r_data(memen_o), .err(error[1]));
      register_1b createdump(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(createdump_in), .r_data(createdump_o), .err(error[2]));
      register_1b wb_sel1(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel1_in), .r_data(wb_sel1_o), .err(error[3]));
      register_1b wb_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel_in), .r_data(wb_sel_o), .err(error[4]));
      register_1b LBI_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(LBI_sel_in), .r_data(LBI_sel_o), .err(error[5]));
      register_1b BTR_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(BTR_sel_in), .r_data(BTR_sel_o), .err(error[6]));
	  register_1b HaltRaw(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(HaltRaw_in), .r_data(HaltRaw_out), .err(error[7]));

      register_16b ex_result(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(ex_result_in), .r_data(ex_result_out), .err(error[8]));
      register_16b PC_addr(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(PC_addr_in), .r_data(PC_addr_o), .err(error[9]));
      register_16b immed(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(immed_in), .r_data(immed_o), .err(error[10]));
      register_16b readData1(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(readData1_in), .r_data(readData1_o), .err(error[11]));
	  register_16b WriteData(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(WriteData_in), .r_data(WriteData_o), .err(error[12]));

      register_3b reg_to_write(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(reg_to_write_in), .r_data(reg_to_write_o), .err(error[13]));

      register_1b write_from_mem(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(write_from_mem_in), .r_data(write_from_mem_o), .err(error[14]));
      register_1b wreg_flag(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wreg_flag_in), .r_data(wreg_flag_o), .err(error[15]));
	  register_1b JumpReg(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(JumpReg_in), .r_data(JumpReg_out), .err(error[16]));
	  register_1b MemRead(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(MemRead_in), .r_data(MemRead_out), .err(error[17]));
	  register_1b isBranch(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(isBranch_in), .r_data(isBranch_out), .err(error[18]));


      assign err = | error;
endmodule
