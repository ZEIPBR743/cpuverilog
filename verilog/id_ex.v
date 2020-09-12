module id_ex(ALU_src_in, ALU_src_out, wb_sel_in, wb_sel_out, wb_sel0_in, wb_sel0_out, wb_sel1_in, wb_sel1_out, ex_result_sel_in, ex_result_sel_out, invRs_in, invRs_out, invIn_in, invIn_out, Cin_in, Cin_out, ALUOP_in, ALUOP_out,
			alu_sign_in, alu_sign_out, MemWrite_in, MemWrite_out, mem_en_in, mem_en_out, JumpReg_in, JumpReg_out, s_extend_in, s_extend_out, LBI_sel_in, LBI_sel_out,
			SLBI_sel_in, SLBI_sel_out, BTR_sel_in, BTR_sel_out, clk, rst, w_en, err, rs_in, rtrd_in, immed_in, rs_out, rtrd_out, immed_out, isBranch_in, isBranch_out,Read1_in, Read1_out, Read2_in, Read2_out, R_reg1_in, R_reg1_out,
			R_reg2_in, R_reg2_out, write_from_memory_in, write_from_memory_out, wreg_flag_in, wreg_flag_out, reg_to_write_in, reg_to_write_out, isJR_in, isJR_out, PC_addr_in, PC_addr_out, HaltRaw_in, HaltRaw_out,
			MemRead_in, MemRead_out, br_addr_in, br_addr_out, flush_in, flush_out);

    input  ALU_src_in, wb_sel_in, wb_sel1_in, ex_result_sel_in, invRs_in, invIn_in, Cin_in, alu_sign_in, MemWrite_in, mem_en_in, JumpReg_in, s_extend_in, LBI_sel_in, SLBI_sel_in, BTR_sel_in,
			HaltRaw_in, isBranch_in, Read1_in, Read2_in, write_from_memory_in, wreg_flag_in, isJR_in, MemRead_in, flush_in;
	input clk, rst, w_en;
	input [1:0] wb_sel0_in;
	input [2:0] ALUOP_in;
	input [2:0] R_reg1_in, R_reg2_in, reg_to_write_in;
	input [15:0] rs_in, rtrd_in, immed_in, PC_addr_in, br_addr_in;
	output ALU_src_out, wb_sel_out, wb_sel1_out, ex_result_sel_out, invRs_out, invIn_out, Cin_out, alu_sign_out, MemWrite_out, mem_en_out, JumpReg_out, s_extend_out, LBI_sel_out, SLBI_sel_out, BTR_sel_out, HaltRaw_out,
			isBranch_out, Read1_out, Read2_out, write_from_memory_out, wreg_flag_out, isJR_out, MemRead_out, flush_out;
	output err;
	output [1:0] wb_sel0_out;
	output [2:0] ALUOP_out;
	output [2:0] R_reg1_out, R_reg2_out, reg_to_write_out;
	output [15:0] rs_out, rtrd_out, immed_out, PC_addr_out, br_addr_out;

	wire[33:0] error;

	// control signals
	register_1b ALU_src(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(ALU_src_in), .r_data(ALU_src_out), .err(error[0]));
	register_1b wb_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel_in), .r_data(wb_sel_out), .err(error[1]));
	register_1b wb_sel1(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel1_in), .r_data(wb_sel1_out), .err(error[2]));
	register_1b ex_result_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(ex_result_sel_in), .r_data(ex_result_sel_out), .err(error[3]));
	register_1b invRs(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(invRs_in), .r_data(invRs_out), .err(error[4]));
	register_1b invIn(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(invIn_in), .r_data(invIn_out), .err(error[5]));
	register_1b Cin(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(Cin_in), .r_data(Cin_out), .err(error[6]));
	register_1b alu_sign(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(alu_sign_in), .r_data(alu_sign_out), .err(error[7]));
	register_1b MemWrite(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(MemWrite_in), .r_data(MemWrite_out), .err(error[8]));
	register_1b mem_en(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(mem_en_in), .r_data(mem_en_out), .err(error[9]));
	register_1b JumpReg(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(JumpReg_in), .r_data(JumpReg_out), .err(error[10]));
	register_1b s_extend(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(s_extend_in), .r_data(s_extend_out), .err(error[11]));
	register_1b LBI_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(LBI_sel_in), .r_data(LBI_sel_out), .err(error[12]));
	register_1b SLBI_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(SLBI_sel_in), .r_data(SLBI_sel_out), .err(error[13]));
	register_1b BTR_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(BTR_sel_in), .r_data(BTR_sel_out), .err(error[14]));
	register_1b isBranch(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(isBranch_in), .r_data(isBranch_out), .err(error[15]));
	register_1b Read1(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(Read1_in), .r_data(Read1_out), .err(error[16]));
	register_1b Read2(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(Read2_in), .r_data(Read2_out), .err(error[17]));
	register_1b write_from_memory(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(write_from_memory_in), .r_data(write_from_memory_out), .err(error[18]));
	register_1b wreg_flag(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wreg_flag_in), .r_data(wreg_flag_out), .err(error[19]));
	register_1b isJR(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(isJR_in), .r_data(isJR_out), .err(error[20]));
	register_1b HaltRaw(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(HaltRaw_in), .r_data(HaltRaw_out), .err(error[21]));
	register_1b MemRead(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(MemRead_in), .r_data(MemRead_out), .err(error[22]));

	register_2b wb_sel0(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel0_in), .r_data(wb_sel0_out), .err(error[23]));

	register_3b ALUOP(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(ALUOP_in), .r_data(ALUOP_out), .err(error[24]));

	// Data
	register_3b R_reg1(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(R_reg1_in), .r_data(R_reg1_out), .err(error[25]));
	register_3b R_reg2(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(R_reg2_in), .r_data(R_reg2_out), .err(error[26]));
	register_3b reg_to_write(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(reg_to_write_in), .r_data(reg_to_write_out), .err(error[27]));
	register_16b rs(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(rs_in), .r_data(rs_out), .err(error[28]));
	register_16b rtrd(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(rtrd_in), .r_data(rtrd_out), .err(error[29]));
	register_16b immed(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(immed_in), .r_data(immed_out), .err(error[30]));
	register_16b PC_addr(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(PC_addr_in), .r_data(PC_addr_out), .err(error[31]));
	register_16b br_addr(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(br_addr_in), .r_data(br_addr_out), .err(error[32]));
	register_1b flush(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(flush_in), .r_data(flush_out), .err(error[33]));

	// err
	assign err = |error;

endmodule
