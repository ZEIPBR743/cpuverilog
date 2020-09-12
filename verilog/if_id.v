module if_id(reg2_rd_sel_in, reg2_rd_sel_out, jump_in, jump_out, im_sel_in, im_sel_out, ALU_src_in, ALU_src_out, wb_sel_in, wb_sel_out, wb_sel0_in, wb_sel0_out, wb_sel1_in, wb_sel1_out, ex_result_sel_in, ex_result_sel_out, invRs_in, invRs_out, invIn_in, invIn_out, Cin_in, Cin_out, ALUOP_in, ALUOP_out,
			alu_sign_in, alu_sign_out, MemWrite_in, MemWrite_out, reg_write_in, reg_write_out, Branch_op_in, Branch_op_out, rd_sel_in, rd_sel_out, mem_en_in, mem_en_out, BranchEn_in, BranchEn_out, JumpReg_in, JumpReg_out, s_extend_in, s_extend_out, LBI_sel_in, LBI_sel_out,
			SLBI_sel_in, SLBI_sel_out, BTR_sel_in, BTR_sel_out, STU_sel_in, STU_sel_out, instruction_in, instruction_out, clk, rst, w_en, err,fetch_addr_out,fetch_addr_in, isBranch_in, isBranch_out, isJR_in, isJR_out, Read1_in, Read1_out, Read2_in, Read2_out, wreg_flag_in, wreg_flag_out,
			write_from_memory_in, write_from_memory_out, PC_addr_in, PC_addr_out, HaltRaw_in, HaltRaw_out, MemRead_in, MemRead_out, wait_in, wait_out);

    input reg2_rd_sel_in, jump_in, im_sel_in, ALU_src_in, wb_sel_in, wb_sel1_in, ex_result_sel_in, invRs_in, invIn_in, Cin_in, alu_sign_in, MemWrite_in, reg_write_in, mem_en_in, BranchEn_in, JumpReg_in, s_extend_in, LBI_sel_in, SLBI_sel_in, BTR_sel_in, STU_sel_in, HaltRaw_in, isBranch_in, isJR_in,
			Read1_in, Read2_in, wreg_flag_in, write_from_memory_in, MemRead_in, wait_in;
	input clk, rst, w_en;
	input [1:0] Branch_op_in, rd_sel_in, wb_sel0_in;
	input [2:0] ALUOP_in;
	input [15:0] instruction_in, fetch_addr_in, PC_addr_in;
	output reg2_rd_sel_out, jump_out, im_sel_out, ALU_src_out, wb_sel_out, wb_sel1_out, ex_result_sel_out, invRs_out, invIn_out, Cin_out, alu_sign_out, MemWrite_out, reg_write_out, mem_en_out, BranchEn_out, JumpReg_out, s_extend_out, LBI_sel_out, SLBI_sel_out, BTR_sel_out,
			STU_sel_out, HaltRaw_out, isBranch_out, isJR_out, Read1_out, Read2_out, wreg_flag_out, write_from_memory_out, MemRead_out, wait_out;
	output err;
	output [1:0] Branch_op_out, rd_sel_out, wb_sel0_out;
	output [2:0] ALUOP_out;
	output [15:0] instruction_out, fetch_addr_out, PC_addr_out;

	wire [36:0] error;

	// control signals
	register_1b reg2_rd_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(reg2_rd_sel_in), .r_data(reg2_rd_sel_out), .err(error[0]));
	register_1b jump(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(jump_in), .r_data(jump_out), .err(error[1]));
	register_1b im_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(im_sel_in), .r_data(im_sel_out), .err(error[2]));
	register_1b ALU_src(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(ALU_src_in), .r_data(ALU_src_out), .err(error[3]));
	register_1b wb_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel_in), .r_data(wb_sel_out), .err(error[4]));
	register_1b wb_sel1(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel1_in), .r_data(wb_sel1_out), .err(error[5]));
	register_1b ex_result_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(ex_result_sel_in), .r_data(ex_result_sel_out), .err(error[6]));
	register_1b invRs(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(invRs_in), .r_data(invRs_out), .err(error[7]));
	register_1b invIn(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(invIn_in), .r_data(invIn_out), .err(error[8]));
	register_1b Cin(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(Cin_in), .r_data(Cin_out), .err(error[9]));
	register_1b alu_sign(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(alu_sign_in), .r_data(alu_sign_out), .err(error[10]));
	register_1b MemWrite(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(MemWrite_in), .r_data(MemWrite_out), .err(error[11]));
	register_1b reg_write(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(reg_write_in), .r_data(reg_write_out), .err(error[12]));
	register_1b mem_en(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(mem_en_in), .r_data(mem_en_out), .err(error[13]));
	register_1b BranchEn(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(BranchEn_in), .r_data(BranchEn_out), .err(error[14]));
	register_1b JumpReg(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(JumpReg_in), .r_data(JumpReg_out), .err(error[15]));
	register_1b s_extend(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(s_extend_in), .r_data(s_extend_out), .err(error[16]));
	register_1b LBI_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(LBI_sel_in), .r_data(LBI_sel_out), .err(error[17]));
	register_1b SLBI_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(SLBI_sel_in), .r_data(SLBI_sel_out), .err(error[18]));
	register_1b BTR_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(BTR_sel_in), .r_data(BTR_sel_out), .err(error[19]));
	register_1b STU_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(STU_sel_in), .r_data(STU_sel_out), .err(error[20]));
	register_1b isBranch(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(isBranch_in), .r_data(isBranch_out), .err(error[21]));
	register_1b isJR(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(isJR_in), .r_data(isJR_out), .err(error[22]));
	register_1b Read1(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(Read1_in), .r_data(Read1_out), .err(error[23]));
	register_1b Read2(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(Read2_in), .r_data(Read2_out), .err(error[24]));
	register_1b wreg_flag(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wreg_flag_in), .r_data(wreg_flag_out), .err(error[25]));
	register_1b write_from_memory(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(write_from_memory_in), .r_data(write_from_memory_out), .err(error[26]));
	register_1b HaltRaw(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(HaltRaw_in), .r_data(HaltRaw_out), .err(error[27]));
	register_1b MemRead(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(MemRead_in), .r_data(MemRead_out), .err(error[28]));
	register_1b wait_sig(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wait_in), .r_data(wait_out), .err(error[29]));

	register_2b Branch_op(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(Branch_op_in), .r_data(Branch_op_out), .err(error[30]));
	register_2b rd_sel(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(rd_sel_in), .r_data(rd_sel_out), .err(error[31]));
	register_2b wb_sel0(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(wb_sel0_in), .r_data(wb_sel0_out), .err(error[32]));

	register_3b ALUOP(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(ALUOP_in), .r_data(ALUOP_out), .err(error[33]));

	// Data
	register_16b instruction(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(instruction_in), .r_data(instruction_out), .err(error[34]));
	register_16b fetch_addr(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(fetch_addr_in), .r_data(fetch_addr_out), .err(error[35]));
	register_16b PC_addr(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(w_en), .w_data(PC_addr_in), .r_data(PC_addr_out), .err(error[36]));

	// err
	assign err = |error;

endmodule
