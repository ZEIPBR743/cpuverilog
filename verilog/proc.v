/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
module proc (/*AUTOARG*/
   // Outputs
   err,
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;
    // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output

   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines


   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
   parameter W = 16; // instr length

   wire err_f, err_ifid, err_d, err_idex, err_exm, err_mwb;

   wire [W-1:0] alu_result, PC_addr;
   wire [4:0] opcode;
   wire [1:0] opcode_ext;
   wire HaltAndStall;
   wire reg2_rd_sel, jump, im_sel, ALU_src, wb_sel, wb_sel1, ex_result_sel, invRs, invIn, Cin, alu_sign, MemWrite, MemRead;
   wire reg_write, mem_en, BranchEn, JumpReg, s_extend, LBI_sel, SLBI_sel, BTR_sel, STU_sel, isBranch, Read1,
		Read2, write_from_mem, wreg_flag, isJR;
   wire [1:0] Branch_op, rd_sel, wb_sel0;
   wire [2:0] ALUOp;
   wire [15:0] br_data_decoded_final, br_addr_input;

   // decode IOs extra wires
   wire   sign_extend, brj_sel;
   wire[1:0]		branch_op_sel;  // branch_op
    wire[W-1:0]    instr;     // instruction (bus)
    wire[W-1:0]  write_back_data;     // data (bus)
    wire[W-1:0]  fetch_addr;
    wire brj, reg_file_err;
    wire[W-1:0] br_data_decoded;
    wire[W-1:0] OutData1, OutData2;
	wire[W-1:0] immed;

	// execute extra wires
	wire[W-1:0] ex_result;
	// forwarding inputs
	wire [15:0] rs_input, rs_btr_ex, rs_btr_mem, rs_input_final, rtrd_input, rtrd_input_final, immed_input, PC_addr_in_input;
	wire [2:0] R_reg1_in_input, R_reg2_in_input, reg_to_write_in_input;

	// MEMORY extra wires
   wire[W-1:0] ReadData;
   
   // mem_system additional signals
   wire mem_done, mem_stall, mem_CacheHit, mem_err;
   
   wire [15:0] instr_ifid_final;
   
   assign opcode = instr_ifid_final[15:11];
   assign opcode_ext = instr_ifid_final[1:0];
   

   // data hazard signals
   wire RAW_EXM1, RAW_MWB1, RAW_EXM2, RAW_MWB2, RAW_EXM, RAW_MWB;
   wire wreg_flag_out_wb;

	// signals from ifid pipepine to decode
	wire reg2_rd_sel_out_id, jump_out_id, im_sel_out_id, ALU_src_out_id, wb_sel_out_id, wb_sel1_out_id, ex_result_sel_out_id, invRs_out_id,
		invIn_out_id, Cin_out_id, alu_sign_out_id, MemWrite_out_id, reg_write_out_id, mem_en_out_id, BranchEn_out_id, JumpReg_out_id,
		s_extend_out_id, LBI_sel_out_id, SLBI_sel_out_id, BTR_sel_out_id, STU_sel_out_id, isBranch_out_id, isJR_out_id,
		Read1_out_id, Read2_out_id, wreg_flag_out_id, write_from_memory_out_id, MemRead_out_id;
	wire [1:0] Branch_op_out_id, rd_sel_out_id, wb_sel0_out_id;
	wire [2:0] ALUOP_out_id;
	wire [15:0] instruction_out_id, fetch_addr_out_id, PC_addr_out_id;

	// decode
	wire [2:0] W_reg, R_reg1, R_reg2;

	// signals from idex pipepine to ex
	wire ALU_src_out_ex, wb_sel_out_ex, wb_sel1_out_ex, ex_result_sel_out_ex, invRs_out_ex, invIn_out_ex, Cin_out_ex, alu_sign_out_ex, MemWrite_out_ex,
			mem_en_out_ex, JumpReg_out_ex, s_extend_out_ex, LBI_sel_out_ex, SLBI_sel_out_ex, BTR_sel_out_ex, isBranch_out_ex, Read1_out_ex,
			Read2_out_ex, write_from_memory_out_ex, wreg_flag_out_ex, isJR_out_ex, MemRead_out_ex;
	wire [1:0] wb_sel0_out_ex;
	wire [2:0] ALUOP_out_ex;
	wire [2:0] R_reg1_out_ex, R_reg2_out_ex, reg_to_write_out_ex;
	wire [15:0] rs_out_ex, rtrd_out_ex, immed_out_ex, PC_addr_out_ex;

	// signals from exmem pipepine to mem
	wire MemWrite_out_mem, memen_out_mem, createdump_out_mem, MemRead_out_mem, isBranch_out_mem;
    wire [W-1:0] WriteData_out_mem;
    wire wb_sel1_out_mem, wb_sel_out_mem, LBI_sel_out_mem, BTR_sel_out_mem, JumpReg_out_mem;
    wire [W-1:0]  ex_result_out_mem, PC_addr_out_mem, immed_out_mem, readData1_out_mem;
    wire write_from_mem_out_mem, wreg_flag_out_mem;
    wire [W-1:0] fetch_addr_out_mem, reg_write_data_out_mem;
	wire [2:0] reg_to_write_out_mem;

	// memory
	wire [15:0] mem_ReadData;

	// signals from mwb pipepine to wb
	wire wb_sel1_out_wb, wb_sel_out_wb, LBI_sel_out_wb, BTR_sel_out_wb;
	wire [W-1:0]  ex_result_out_wb, PC_addr_out_wb, immed_out_wb, readData1_out_wb, ReadData_out_wb;
	wire write_from_mem_out_wb;
	wire [2:0] reg_to_write_out_wb;

	wire a1, a2, b1, b2;


	// ifid enable, idex enable, exm enable
	wire EN1, EN2, EN3;

	// idex input control signals final
	wire reg_write_idex_final, reg2_rd_sel_idex_final, im_sel_idex_final, ALU_src_idex_final, jump_idex_final, MemWrite_idex_final,
			wb_sel_idex_final, wb_sel1_idex_final, ex_result_sel_idex_final, s_extend_idex_final, invRs_idex_final, invIn_idex_final,
			Cin_idex_final, alu_sign_idex_final, mem_en_idex_final, BranchEn_idex_final, JumpReg_idex_final, LBI_sel_idex_final,
			SLBI_sel_idex_final, BTR_sel_idex_final, STU_sel_idex_final, isBranch_idex_final, Read1_idex_final, Read2_idex_final,
			write_from_mem_idex_final, wreg_flag_idex_final, isJR_idex_final, Halt_idex_final, MemRead_idex_final;
	wire [1:0] rd_sel_idex_final, wb_sel0_idex_final, Branch_op_idex_final;
	wire [2:0] ALUOP_idex_final;
	
	
	// exm stall
	wire wb_sel1_exm_final, wb_sel_exm_final, LBI_sel_exm_final, BTR_sel_exm_final, MemWrite_exm_final, memen_exm_final, createdump_exm_final,
			JumpReg_exm_final, write_from_mem_exm_final, wreg_flag_exm_final, HaltRaw_exm_final, MemRead_exm_final;
	wire [15:0] ex_result_exm_final, PC_addr_exm_final, immed_exm_final, readData1_exm_final, WriteData_exm_final;
	wire [2:0] reg_to_write_exm_final;
	
	// mwb stall
	wire wb_sel1_mwb_final, wb_sel_mwb_final, LBI_sel_mwb_final, BTR_sel_mwb_final, write_from_mem_mwb_final, wreg_flag_mwb_final, HaltRaw_mwb_final;
	wire [15:0] ex_result_mwb_final, PC_addr_mwb_final, immed_mwb_final, readData1_mwb_final;
	wire [2:0] reg_to_write_mwb_final;
	
	wire HaltRaw;
	wire HaltRaw_to_id, HaltRaw_to_ex, HaltRaw_to_mem, HaltRaw_to_wb;
	wire Branch_Resolved;
	wire JR_Resolved;
	wire pred_wrong;
	wire branch_ifid_in;
	wire update_addr;
	wire inst_stall;
	wire [15:0] addr_in;
	wire flush_in, flush_out, flush_in_final;
	wire wreg_flag_final, HaltRaw_final;
	wire [2:0] mem_state, inst_state;
	wire wait_in_mwb_final, wait_cycle, wait_out, wait_final;
	wire [15:0] fetch_addr_input;
	wire wait_cycle_inst, wait_final_inst, wait_in_final_inst, wait_out_inst;

	assign Branch_Resolved = RAW_EXM1 ? (LBI_sel_out_ex ? isBranch_out_id : (write_from_memory_out_ex ? 1'b0 : isBranch_out_id)) : (RAW_MWB1 ? ((LBI_sel_out_mem) ? isBranch_out_id : (write_from_mem_out_mem ? ~((write_from_mem_out_wb & (mem_state != 0)) | ((mem_state == 0) & wait_out) | ~EN3) : isBranch_out_id)) : isBranch_out_id);
	assign JR_Resolved = (JumpReg_out_ex) ? 1 : 0;

   sig_cntrl control_blk(.opcode(opcode),.opcode_ext(opcode_ext),.reg2_rd_sel(reg2_rd_sel),
                         .jump(jump), .im_sel(im_sel), .ALU_src(ALU_src),
                         .wb_sel(wb_sel), .wb_sel0(wb_sel0), .wb_sel1(wb_sel1),
						 .ex_result_sel(ex_result_sel), .invRs(invRs), .invIn(invIn), .Cin(Cin),
						 .ALUOP(ALUOp), .alu_sign(alu_sign), .MemWrite(MemWrite), .MemRead(MemRead),
						 .reg_write(reg_write),.Branch_op(Branch_op), .rd_sel(rd_sel),
						 .mem_en(mem_en), .BranchEn(BranchEn), .JumpReg(JumpReg), .Halt(HaltRaw),
						 .s_extend(s_extend), .LBI_sel(LBI_sel),
						 .SLBI_sel(SLBI_sel), .BTR_sel(BTR_sel), .STU_sel(STU_sel), .isBranch(isBranch),
						 .Read1(Read1), .Read2(Read2), .write_from_mem(write_from_mem), .wreg_flag(wreg_flag), .isJR(isJR));


   assign br_data_decoded_final = ((isBranch_out_id & Branch_Resolved & pred_wrong) | (jump_out_id)) ? br_data_decoded : fetch_addr;
   assign br_addr_input = (inst_state == 0) ? br_data_decoded_final : (((isBranch_out_id & Branch_Resolved & pred_wrong) | (jump_out_id)) ? br_data_decoded_final : addr_in);
   assign flush_in = ((isBranch_out_id & Branch_Resolved & pred_wrong) | jump_out_id) ? 1'b1 : 1'b0;
   assign flush_in_final = (inst_state == 0) ? flush_in : flush_out;
   
   fetch fetch(.fetch_addr(fetch_addr), .inst(instr), .addr(addr_in), .JumpReg(JR_Resolved), .PC_addr(PC_addr),
							.Halt(HaltAndStall), .clk(clk), .rst(rst), .err(err_f), .ex_result(ex_result), .stall(inst_stall), .state(inst_state));



	assign instr_ifid_final = (!EN1) ? ((!EN2) ? instruction_out_id : 16'h0800) : ((flush_out || JR_Resolved || isBranch_out_id)? 16'h0800 : instr);        // nop
	assign branch_ifid_in = (isBranch_out_id && (~Branch_Resolved || wait_final_inst)) ? isBranch_out_id : isBranch;
	assign fetch_addr_input = (isBranch_out_id) ? fetch_addr_out_id : fetch_addr;

	assign wait_cycle_inst = ((isBranch_out_id & Branch_Resolved & pred_wrong) || (inst_state != 0)) ? 1'b1 : 1'b0;
	assign wait_final_inst = ((wait_out_inst == 1) && (inst_state == 0)) ? 1'b0 : wait_out_inst;
	assign wait_in_final_inst = ((isBranch_out_id & Branch_Resolved & pred_wrong) && (inst_state == 0)) ? wait_final_inst : wait_cycle_inst;


	 if_id if_id(.reg2_rd_sel_in(reg2_rd_sel), .reg2_rd_sel_out(reg2_rd_sel_out_id), .jump_in(jump), .jump_out(jump_out_id),
				.im_sel_in(im_sel), .im_sel_out(im_sel_out_id), .ALU_src_in(ALU_src), .ALU_src_out(ALU_src_out_id), .wb_sel_in(wb_sel),
				.wb_sel_out(wb_sel_out_id), .wb_sel0_in(wb_sel0), .wb_sel0_out(wb_sel0_out_id), .wb_sel1_in(wb_sel1),
				.wb_sel1_out(wb_sel1_out_id), .ex_result_sel_in(ex_result_sel), .ex_result_sel_out(ex_result_sel_out_id), .invRs_in(invRs),
				.invRs_out(invRs_out_id), .invIn_in(invIn), .invIn_out(invIn_out_id), .Cin_in(Cin), .Cin_out(Cin_out_id), .ALUOP_in(ALUOp),
				.ALUOP_out(ALUOP_out_id), .alu_sign_in(alu_sign), .alu_sign_out(alu_sign_out_id), .MemWrite_in(MemWrite), .MemWrite_out(MemWrite_out_id),
				.reg_write_in(reg_write), .reg_write_out(reg_write_out_id), .Branch_op_in(Branch_op), .Branch_op_out(Branch_op_out_id),
				.rd_sel_in(rd_sel), .rd_sel_out(rd_sel_out_id), .mem_en_in(mem_en), .mem_en_out(mem_en_out_id), .BranchEn_in(BranchEn),
				.BranchEn_out(BranchEn_out_id), .JumpReg_in(JumpReg), .JumpReg_out(JumpReg_out_id), .HaltRaw_in(HaltRaw), .HaltRaw_out(HaltRaw_to_id),
				.s_extend_in(s_extend), .s_extend_out(s_extend_out_id), .LBI_sel_in(LBI_sel), .LBI_sel_out(LBI_sel_out_id), .SLBI_sel_in(SLBI_sel),
				.SLBI_sel_out(SLBI_sel_out_id), .BTR_sel_in(BTR_sel), .BTR_sel_out(BTR_sel_out_id), .STU_sel_in(STU_sel), .STU_sel_out(STU_sel_out_id),
				.instruction_in(instr_ifid_final), .instruction_out(instruction_out_id), .clk(clk), .rst(rst), .w_en(1'b1), .err(err_ifid), .fetch_addr_out(fetch_addr_out_id),
				.fetch_addr_in(fetch_addr_input), .isBranch_in(branch_ifid_in), .isBranch_out(isBranch_out_id), .isJR_in(isJR), .isJR_out(isJR_out_id), .Read1_in(Read1),
				.Read1_out(Read1_out_id), .Read2_in(Read2), .Read2_out(Read2_out_id), .wreg_flag_in(wreg_flag), .wreg_flag_out(wreg_flag_out_id),
				.write_from_memory_in(write_from_mem), .write_from_memory_out(write_from_memory_out_id), .PC_addr_in(PC_addr), .PC_addr_out(PC_addr_out_id),
				.MemRead_in(MemRead), .MemRead_out(MemRead_out_id), .wait_in(wait_in_final_inst), .wait_out(wait_out_inst));


   
   
   decode decode(.clk(clk), .rst(rst), .reg_write(wreg_flag_final), .reg2_rd_sel(reg2_rd_sel_out_id), .Im_sel(im_sel_out_id), .wb_sel(wb_sel_out_id),
					.sign_extend(s_extend_out_id), .rd_sel(rd_sel_out_id), .brj_sel(jump_out_id), .instr(instruction_out_id), .write_back_data(write_back_data),
					.branch_op_sel(Branch_op_out_id), .BranchEn(BranchEn_out_id), .fetch_addr(fetch_addr_out_id), .br_data_decoded(br_data_decoded), .branch_rs(rs_input_final),
					.OutData1(OutData1), .OutData2(OutData2), .reg_file_err(err_d), .immed(immed), .STU_sel(STU_sel_out_id), .W_reg(W_reg), .R_reg1(R_reg1),
					.R_reg2(R_reg2), .writein_reg(reg_to_write_out_wb), .pred_wrong(pred_wrong));


	assign ALU_src_idex_final = (!EN2) ? 1'b0 : ALU_src_out_id;
	assign MemWrite_idex_final = (!EN2) ? 1'b0 : MemWrite_out_id;
	assign wb_sel_idex_final = (!EN2) ? 1'b0 : wb_sel_out_id;
	assign wb_sel0_idex_final = (!EN2) ? 2'b00 : wb_sel0_out_id;
	assign wb_sel1_idex_final = (!EN2) ? 1'b0 : wb_sel1_out_id;
	assign ex_result_sel_idex_final = (!EN2) ? 1'b1 : ex_result_sel_out_id;
	assign s_extend_idex_final = (!EN2) ? 1 : s_extend_out_id;
	assign invRs_idex_final = (!EN2) ? 1'b0 : invRs_out_id;
	assign invIn_idex_final = (!EN2) ? 1'b0 : invIn_out_id;
	assign Cin_idex_final = (!EN2) ? 1'b0 : Cin_out_id;
	assign ALUOP_idex_final = (!EN2) ? 3'b100 : ALUOP_out_id;
	assign alu_sign_idex_final = (!EN2) ? 1'b1 : alu_sign_out_id;
	assign mem_en_idex_final = (!EN2) ? 1'b0 : mem_en_out_id;
	assign JumpReg_idex_final = (!EN2) ? 1'b0 : JumpReg_out_id;
	assign LBI_sel_idex_final = (!EN2) ? 1'b0 : LBI_sel_out_id;
	assign SLBI_sel_idex_final = (!EN2) ? 1'b0 : SLBI_sel_out_id;
	assign BTR_sel_idex_final = (!EN2) ? 1'b0 : BTR_sel_out_id ;
	assign isBranch_idex_final = (!EN2) ? 1'b0 : isBranch_out_id;
	assign Read1_idex_final = (!EN2) ? 1'b0 : Read1_out_id;
	assign Read2_idex_final = (!EN2) ? 1'b0 : Read2_out_id;
	assign write_from_mem_idex_final = (!EN2) ? 1'b0 : write_from_memory_out_id;
	assign wreg_flag_idex_final = (!EN2) ? 1'b0 : wreg_flag_out_id;
	assign isJR_idex_final = (!EN2) ? 1'b0 : isJR_out_id;
	assign Halt_idex_final = (!EN2) ? 1'b0 : HaltRaw_to_id;
	assign MemRead_idex_final = (!EN2) ? 1'b0 : MemRead_out_id;
	

	assign rs_input = RAW_MWB1 ? (RAW_EXM1 ? (LBI_sel_out_ex ? immed_out_ex : ((wb_sel_out_ex) ? ((wb_sel1_out_ex) ? mem_ReadData : ex_result) : PC_addr_out_ex)) : (LBI_sel_out_mem ? immed_out_mem : ((wb_sel_out_mem) ? (wb_sel1_out_mem ? mem_ReadData : ex_result_out_mem) : PC_addr_out_mem))) : 
						(RAW_EXM1 ? (LBI_sel_out_ex ? immed_out_ex : ((wb_sel_out_ex) ? ((wb_sel1_out_ex) ? mem_ReadData : ex_result) : PC_addr_out_ex)) : ((!EN2) ? rs_out_ex : OutData1));
	assign rtrd_input = RAW_MWB2 ? (RAW_EXM2 ? (LBI_sel_out_ex ? immed_out_ex : ((wb_sel_out_ex) ? ((wb_sel1_out_ex) ? mem_ReadData : ex_result) : PC_addr_out_ex)) : (LBI_sel_out_mem ? immed_out_mem : ((wb_sel_out_mem) ? (wb_sel1_out_mem ? mem_ReadData : ex_result_out_mem) : PC_addr_out_mem))) : 
						(RAW_EXM2 ? (LBI_sel_out_ex ? immed_out_ex : ((wb_sel_out_ex) ? ((wb_sel1_out_ex) ? mem_ReadData : ex_result) : PC_addr_out_ex)) : ((!EN2) ? rtrd_out_ex : OutData2));

	assign rs_btr_ex = {rs_out_ex[0], rs_out_ex[1], rs_out_ex[2], rs_out_ex[3], rs_out_ex[4], rs_out_ex[5], rs_out_ex[6], rs_out_ex[7], rs_out_ex[8], rs_out_ex[9], rs_out_ex[10], rs_out_ex[11], rs_out_ex[12], rs_out_ex[13], rs_out_ex[14], rs_out_ex[15]};
	assign rs_btr_mem = {readData1_out_mem[0], readData1_out_mem[1], readData1_out_mem[2], readData1_out_mem[3], readData1_out_mem[4], readData1_out_mem[5], readData1_out_mem[6], readData1_out_mem[7], readData1_out_mem[8], readData1_out_mem[9], 
						readData1_out_mem[10], readData1_out_mem[11], readData1_out_mem[12], readData1_out_mem[13], readData1_out_mem[14], readData1_out_mem[15]};
	assign rs_input_final = RAW_MWB1 ? (RAW_EXM1 ? ((BTR_sel_out_ex) ? rs_btr_ex : rs_input) : ((BTR_sel_out_mem) ? rs_btr_mem : rs_input)) : (RAW_EXM1 ? (BTR_sel_out_ex ? rs_btr_ex : rs_input) : rs_input);
	
//	assign rtrd_btr_ex = {rtrd_out_ex[0], rtrd_out_ex[1], rtrd_out_ex[2], rtrd_out_ex[3], rtrd_out_ex[4], rtrd_out_ex[5], rtrd_out_ex[6], rtrd_out_ex[7], rtrd_out_ex[8], rtrd_out_ex[9], rtrd_out_ex[10], rtrd_out_ex[11], rtrd_out_ex[12], rtrd_out_ex[13], rtrd_out_ex[14], rtrd_out_ex[15]};
//	assign rtrd_btr_mem = {readData1_out_mem[0], readData1_out_mem[1], readData1_out_mem[2], readData1_out_mem[3], readData1_out_mem[4], readData1_out_mem[5], readData1_out_mem[6], readData1_out_mem[7], readData1_out_mem[8], readData1_out_mem[9], 
//						readData1_out_mem[10], readData1_out_mem[11], readData1_out_mem[12], readData1_out_mem[13], readData1_out_mem[14], readData1_out_mem[15]};
	assign rtrd_input_final = RAW_MWB2 ? (RAW_EXM2 ? ((BTR_sel_out_ex) ? rs_btr_ex : rtrd_input) : ((BTR_sel_out_mem) ? rs_btr_mem : rtrd_input)) : (RAW_EXM2 ? (BTR_sel_out_ex ? rs_btr_ex : rtrd_input) : rtrd_input);
	assign immed_input = (!EN2) ? immed_out_ex : immed;
	assign R_reg1_in_input = (!EN2) ? R_reg1_out_ex : R_reg1;
	assign R_reg2_in_input = (!EN2) ? R_reg2_out_ex : R_reg2;
	assign reg_to_write_in_input = (!EN2) ? reg_to_write_out_ex : W_reg;
	assign PC_addr_in_input = (!EN2) ? PC_addr_out_ex : PC_addr_out_id;

  id_ex id_ex(.ALU_src_in(ALU_src_idex_final), .ALU_src_out(ALU_src_out_ex), .wb_sel_in(wb_sel_idex_final), .wb_sel_out(wb_sel_out_ex), .wb_sel0_in(wb_sel0_idex_final),
			.wb_sel0_out(wb_sel0_out_ex), .wb_sel1_in(wb_sel1_idex_final), .wb_sel1_out(wb_sel1_out_ex), .ex_result_sel_in(ex_result_sel_idex_final),
			.ex_result_sel_out(ex_result_sel_out_ex), .invRs_in(invRs_idex_final), .invRs_out(invRs_out_ex), .invIn_in(invIn_idex_final), .invIn_out(invIn_out_ex),
			.Cin_in(Cin_idex_final), .Cin_out(Cin_out_ex), .ALUOP_in(ALUOP_idex_final), .ALUOP_out(ALUOP_out_ex), .alu_sign_in(alu_sign_idex_final), .alu_sign_out(alu_sign_out_ex),
			.MemWrite_in(MemWrite_idex_final), .MemWrite_out(MemWrite_out_ex), .mem_en_in(mem_en_idex_final), .mem_en_out(mem_en_out_ex), .JumpReg_in(JumpReg_idex_final),
			.JumpReg_out(JumpReg_out_ex), .s_extend_in(s_extend_idex_final), .s_extend_out(s_extend_out_ex), .HaltRaw_in(Halt_idex_final), .HaltRaw_out(HaltRaw_to_ex),
			.LBI_sel_in(LBI_sel_idex_final), .LBI_sel_out(LBI_sel_out_ex), .SLBI_sel_in(SLBI_sel_idex_final), .SLBI_sel_out(SLBI_sel_out_ex), .BTR_sel_in(BTR_sel_idex_final),
			.BTR_sel_out(BTR_sel_out_ex), .clk(clk), .rst(rst), .w_en(1'b1), .err(err_idex), .rs_in(rs_input_final), .rtrd_in(rtrd_input_final), .immed_in(immed_input), .rs_out(rs_out_ex),
			.rtrd_out(rtrd_out_ex), .immed_out(immed_out_ex), .isBranch_in(isBranch_idex_final), .isBranch_out(isBranch_out_ex), .Read1_in(Read1_idex_final), .Read1_out(Read1_out_ex),
			.Read2_in(Read2_idex_final), .Read2_out(Read2_out_ex), .R_reg1_in(R_reg1_in_input), .R_reg1_out(R_reg1_out_ex), .R_reg2_in(R_reg2_in_input), .R_reg2_out(R_reg2_out_ex), .write_from_memory_in(write_from_mem_idex_final),
			.write_from_memory_out(write_from_memory_out_ex), .wreg_flag_in(wreg_flag_idex_final), .wreg_flag_out(wreg_flag_out_ex), .reg_to_write_in(reg_to_write_in_input),
			.reg_to_write_out(reg_to_write_out_ex), .isJR_in(isJR_idex_final), .isJR_out(isJR_out_ex), .PC_addr_in(PC_addr_in_input), .PC_addr_out(PC_addr_out_ex), .MemRead_in(MemRead_idex_final), .MemRead_out(MemRead_out_ex),
			.br_addr_in(br_addr_input), .br_addr_out(addr_in), .flush_in(flush_in_final), .flush_out(flush_out));



	execute execute(.ReadData1(rs_out_ex), .ReadData2(rtrd_out_ex), .immediate(immed_out_ex), .ALUSrc(ALU_src_out_ex), .ALUOp(ALUOP_out_ex), .sign(alu_sign_out_ex),
					.invRs(invRs_out_ex), .invIn(invIn_out_ex), .Cin(Cin_out_ex), .wb_sel0(wb_sel0_out_ex), .SLBI_sel(SLBI_sel_out_ex),
					.ex_result_sel(ex_result_sel_out_ex), .ex_result(ex_result));



	assign wb_sel1_exm_final = (!EN3) ? wb_sel1_out_mem : wb_sel1_out_ex;
	assign wb_sel_exm_final = (!EN3) ? wb_sel_out_mem : wb_sel_out_ex;
	assign LBI_sel_exm_final = (!EN3) ? LBI_sel_out_mem : LBI_sel_out_ex;
	assign BTR_sel_exm_final = (!EN3) ? BTR_sel_out_mem : BTR_sel_out_ex;
	assign ex_result_exm_final = (!EN3) ? ex_result_out_mem : ex_result;
	assign PC_addr_exm_final = (!EN3) ? PC_addr_out_mem : PC_addr_out_ex;
	assign immed_exm_final = (!EN3) ? immed_out_mem : immed_out_ex;
	assign readData1_exm_final = (!EN3) ? readData1_out_mem : rs_out_ex;
	assign MemWrite_exm_final = (!EN3) ? MemWrite_out_mem : MemWrite_out_ex;
	assign memen_exm_final = (!EN3) ? memen_out_mem : mem_en_out_ex;
	assign createdump_exm_final = (!EN3) ? createdump_out_mem : HaltRaw_to_ex;
	assign WriteData_exm_final = (!EN3) ? WriteData_out_mem : rtrd_out_ex;
	assign JumpReg_exm_final = (!EN3) ? JumpReg_out_mem : JumpReg_out_ex;
	assign write_from_mem_exm_final = (!EN3) ? write_from_mem_out_mem : write_from_memory_out_ex;
	assign wreg_flag_exm_final = (!EN3) ? wreg_flag_out_mem : wreg_flag_out_ex;
	assign reg_to_write_exm_final = (!EN3) ? reg_to_write_out_mem : reg_to_write_out_ex;
	assign HaltRaw_exm_final = (!EN3) ? HaltRaw_to_mem : HaltRaw_to_ex;
	assign MemRead_exm_final = (!EN3) ? MemRead_out_mem : MemRead_out_ex;
	assign isBranch_exm_final = (!EN3) ? isBranch_out_mem : isBranch_out_ex;
	
	
	ex_mem ex_mem (.wb_sel1_in(wb_sel1_exm_final), .wb_sel_in(wb_sel_exm_final), .LBI_sel_in(LBI_sel_exm_final), .BTR_sel_in(BTR_sel_exm_final), .ex_result_in(ex_result_exm_final),
					.PC_addr_in(PC_addr_exm_final), .immed_in(immed_exm_final), .readData1_in(readData1_exm_final), .MemWrite_in(MemWrite_exm_final), .memen_in(memen_exm_final),
					.createdump_in(createdump_exm_final), .WriteData_in(WriteData_exm_final), .wb_sel1_o(wb_sel1_out_mem), .wb_sel_o(wb_sel_out_mem), .JumpReg_in(JumpReg_exm_final), .JumpReg_out(JumpReg_out_mem),
					.LBI_sel_o(LBI_sel_out_mem), .BTR_sel_o(BTR_sel_out_mem), .ex_result_out(ex_result_out_mem), .PC_addr_o(PC_addr_out_mem), .immed_o(immed_out_mem),
					.readData1_o(readData1_out_mem), .MemWrite_o(MemWrite_out_mem), .memen_o(memen_out_mem), .createdump_o(createdump_out_mem),
					.WriteData_o(WriteData_out_mem), .clk(clk), .rst(rst), .w_en(1'b1), .err(err_exm), .write_from_mem_in(write_from_mem_exm_final),
					.wreg_flag_in(wreg_flag_exm_final), .reg_to_write_in(reg_to_write_exm_final), .write_from_mem_o(write_from_mem_out_mem), .wreg_flag_o(wreg_flag_out_mem),
					.reg_to_write_o(reg_to_write_out_mem), .HaltRaw_in(HaltRaw_exm_final), .HaltRaw_out(HaltRaw_to_mem), .MemRead_in(MemRead_exm_final), .MemRead_out(MemRead_out_mem), .isBranch_in(isBranch_exm_final), .isBranch_out(isBranch_out_mem));


	memory memory(.memen(memen_out_mem), .address(ex_result_out_mem), .WriteData(WriteData_out_mem), .clk(clk), .rst(rst), .createdump(createdump_out_mem),
					.ReadData(mem_ReadData), .Done(mem_done), .Stall(mem_stall), .CacheHit(mem_CacheHit), .err(mem_err), .Rd(MemRead_out_mem), .Wr(MemWrite_out_mem), .state(mem_state));

//	memory memory(.MemWrite(MemWrite_out_mem), .memen(memen_out_mem), .address(ex_result_out_mem), .WriteData(WriteData_out_mem), .clk(clk), .rst(rst),
//					.createdump(createdump_out_mem), .ReadData(mem_ReadData));


	assign wb_sel1_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? wb_sel1_out_wb : wb_sel1_out_mem;
	assign wb_sel_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? wb_sel_out_wb : wb_sel_out_mem;
	assign LBI_sel_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? LBI_sel_out_wb : LBI_sel_out_mem;
	assign BTR_sel_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? BTR_sel_out_wb : BTR_sel_out_mem;
	assign write_from_mem_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? write_from_mem_out_wb : write_from_mem_out_mem;
	assign wreg_flag_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? wreg_flag_out_wb : wreg_flag_out_mem;
	assign HaltRaw_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? HaltRaw_to_wb : HaltRaw_to_mem;
	assign ex_result_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? ex_result_out_wb : ex_result_out_mem;
	assign PC_addr_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? PC_addr_out_wb : PC_addr_out_mem;
	assign immed_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? immed_out_wb : immed_out_mem;
	assign readData1_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? readData1_out_wb : readData1_out_mem;
	assign reg_to_write_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? reg_to_write_out_wb : reg_to_write_out_mem;
	assign wait_in_mwb_final = (write_from_mem_out_wb & (mem_state != 0)) ? wait_final : wait_cycle;
	
	assign wait_cycle = ((write_from_mem_out_mem | MemWrite_out_mem) && (mem_state != 0)) ? 1'b1 : 1'b0;
	assign wait_final = ((wait_out == 1'b1) && (mem_state == 0)) ? 1'b0 : wait_out;
	
	assign wreg_flag_final = ((write_from_mem_out_wb & (mem_state != 0)) | ((mem_state == 0) & wait_out) | ~EN3) ? 1'b0 : wreg_flag_out_wb;
	assign HaltRaw_final = ((write_from_mem_out_wb & (mem_state != 0)) | ((mem_state == 0) & wait_out) | ~EN3) ? 1'b0 : HaltRaw_to_wb;
	
	mem_wb mem_wb(.wb_sel1_in(wb_sel1_mwb_final), .wb_sel_in(wb_sel_mwb_final), .LBI_sel_in(LBI_sel_mwb_final), .BTR_sel_in(BTR_sel_mwb_final), .ex_result_in(ex_result_mwb_final),
					.PC_addr_in(PC_addr_mwb_final), .immed_in(immed_mwb_final), .readData1_in(readData1_mwb_final), .ReadData_in(mem_ReadData), .wb_sel1_o(wb_sel1_out_wb),
					.wb_sel_o(wb_sel_out_wb), .LBI_sel_o(LBI_sel_out_wb), .BTR_sel_o(BTR_sel_out_wb), .ex_result_o(ex_result_out_wb), .PC_addr_o(PC_addr_out_wb),
					.immed_o(immed_out_wb), .readData1_o(readData1_out_wb), .ReadData_o(ReadData_out_wb), .clk(clk), .rst(rst), .w_en(1'b1), .err(err_mwb),
					.write_from_mem_in(write_from_mem_mwb_final), .wreg_flag_in(wreg_flag_mwb_final), .reg_to_write_in(reg_to_write_mwb_final), .write_from_mem_o(write_from_mem_out_wb),
					.wreg_flag_o(wreg_flag_out_wb), .reg_to_write_o(reg_to_write_out_wb), .HaltRaw_in(HaltRaw_mwb_final), .HaltRaw_out(HaltRaw_to_wb), .wait_in(wait_in_mwb_final), .wait_out(wait_out));


	assign RAW_EXM = RAW_EXM1 | RAW_EXM2;
	assign RAW_MWB = RAW_MWB1 | RAW_MWB2;

	assign EN3 = (write_from_mem_out_wb & (mem_state != 0)) ? 1'b0 : ((mem_state == 0) ? 1'b1 : ((write_from_mem_out_mem | MemWrite_out_mem) ? 1'b0 : 1'b1));  // ~(write_from_mem_out_mem & (mem_stall | mem_done));
	assign EN2 = (((RAW_EXM & write_from_memory_out_ex) | (~EN3)) || ((write_from_memory_out_ex | MemWrite_out_ex) & mem_stall) || (write_from_mem_out_mem & mem_stall)) ? 0 : 1;
	assign EN1 = ((~EN2) | (isBranch_out_id & (~Branch_Resolved)) | (JumpReg_out_id & ~JR_Resolved)) ? 0 : 1;
	assign HaltAndStall = HaltRaw_final || (~EN1) || jump || jump_out_id || (JumpReg & ~JR_Resolved) || (JumpReg_out_id & ~JR_Resolved);

	// idex.R_reg1 == exmem.W_reg
	assign a1 = (R_reg1 == reg_to_write_out_ex) ? 1 : 0;
	// idex.R_reg2 == exmem.W_reg
	assign a2 = (R_reg2 == reg_to_write_out_ex) ? 1 : 0;
	assign RAW_EXM1 = Read1_out_id & wreg_flag_out_ex & a1;
	assign RAW_EXM2 = Read2_out_id & wreg_flag_out_ex & a2;

	// idex.R_reg1 == exmem.W_reg
	assign b1 = (R_reg1 == reg_to_write_out_mem) ? 1 : 0;
	// idex.R_reg2 == exmem.W_reg
	assign b2 = (R_reg2 == reg_to_write_out_mem) ? 1 : 0;
	assign RAW_MWB1 = Read1_out_id & wreg_flag_out_mem & b1;
	assign RAW_MWB2 = Read2_out_id & wreg_flag_out_mem & b2;
	

	assign err = err_f | err_ifid | err_d | err_idex | err_exm | err_mwb | mem_err;
	
	
		wb wb(.wb_sel1(wb_sel1_out_wb), .wb_sel(wb_sel_out_wb), .ex_result(ex_result_out_wb), .ReadData(ReadData_out_wb), .PC_addr(PC_addr_out_wb),
			.wb_out(write_back_data), .LBI_sel(LBI_sel_out_wb), .readData1(readData1_out_wb), .immed(immed_out_wb), .BTR_sel(BTR_sel_out_wb));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
