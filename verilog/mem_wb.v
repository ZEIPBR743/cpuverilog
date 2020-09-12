module mem_wb(wb_sel1_in, wb_sel_in, LBI_sel_in, BTR_sel_in,
             ex_result_in, PC_addr_in, immed_in, readData1_in, ReadData_in,
             wb_sel1_o, wb_sel_o, LBI_sel_o, BTR_sel_o,
             ex_result_o, PC_addr_o, immed_o, readData1_o, ReadData_o, clk, rst, w_en, err,
             write_from_mem_in, wreg_flag_in, reg_to_write_in, write_from_mem_o, wreg_flag_o, reg_to_write_o, HaltRaw_in, HaltRaw_out, wait_in, wait_out);

  parameter W = 16;

  // INPUTS
  // signals control this ex_mem pipeline registers
  input clk, rst, w_en;
  output err;

  // signals required by wb stage
  input wb_sel1_in, wb_sel_in, LBI_sel_in, BTR_sel_in, HaltRaw_in, wait_in;
  input [W-1:0]  ex_result_in, PC_addr_in, immed_in, readData1_in, ReadData_in;
  input write_from_mem_in, wreg_flag_in;
  input [2:0] reg_to_write_in;

  // OUTPUTS
  // mirrors above
  output wb_sel1_o, wb_sel_o, LBI_sel_o, BTR_sel_o, HaltRaw_out, wait_out;
  output [W-1:0]  ex_result_o, PC_addr_o, immed_o, readData1_o, ReadData_o;
  output write_from_mem_o, wreg_flag_o;
  output [2:0] reg_to_write_o;

  wire [13:0] error;

  // REGISTERS
  register_1b write_from_mem(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(write_from_mem_in), .r_data(write_from_mem_o), .err(error[0]));
  register_1b wreg_flag(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wreg_flag_in), .r_data(wreg_flag_o), .err(error[1]));
  register_1b wb_sel1(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel1_in), .r_data(wb_sel1_o), .err(error[2]));
  register_1b wb_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel_in), .r_data(wb_sel_o), .err(error[3]));
  register_1b LBI_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(LBI_sel_in), .r_data(LBI_sel_o), .err(error[4]));
  register_1b BTR_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(BTR_sel_in), .r_data(BTR_sel_o), .err(error[5]));
  register_1b HaltRaw(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(HaltRaw_in), .r_data(HaltRaw_out), .err(error[6]));

  register_16b ex_result(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(ex_result_in), .r_data(ex_result_o), .err(error[7]));
  register_16b PC_addr(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(PC_addr_in), .r_data(PC_addr_o), .err(error[8]));
  register_16b immed(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(immed_in), .r_data(immed_o), .err(error[9]));
  register_16b ReadData(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(ReadData_in), .r_data(ReadData_o), .err(error[10]));
  register_16b readData1(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(readData1_in), .r_data(readData1_o), .err(error[11]));

  register_3b reg_to_write(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(reg_to_write_in), .r_data(reg_to_write_o), .err(error[12]));
  register_1b wait_sig(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wait_in), .r_data(wait_out), .err(error[13]));

  assign err = | error;

endmodule
