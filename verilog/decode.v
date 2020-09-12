/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (clk, rst, reg_write, reg2_rd_sel, Im_sel, wb_sel, sign_extend, rd_sel, brj_sel, instr, write_back_data, branch_op_sel,
		BranchEn, fetch_addr, br_data_decoded, OutData1, OutData2, reg_file_err, immed, STU_sel, W_reg, R_reg1, R_reg2, writein_reg, branch_rs, pred_wrong);

    parameter W = 16; // instr length

    input    clk, rst;
    // these are control signals (note:
	/*
	reg_write is write_en into the register_file
	brj sel is the jump signal in global)
	*/
    input    reg_write, reg2_rd_sel, Im_sel, wb_sel, sign_extend, brj_sel, BranchEn, STU_sel; 
	input[1:0]		branch_op_sel, rd_sel;  // branch_op 
    input[W-1:0]    instr;     // instruction (bus)
    input[W-1:0]  write_back_data;     // data (bus)
	input[W-1:0]  fetch_addr;
	input[W-1:0] branch_rs;
	input [2:0] writein_reg;

    output reg_file_err, pred_wrong;
    output[W-1:0] br_data_decoded;
    output[W-1:0] OutData1, OutData2, immed;
	output [2:0] W_reg, R_reg1, R_reg2;


    wire addr1_ofl, addr1_c_out; 
	wire[2:0] rd_addr, WrR, readReg1, readReg2; //3 bit reg dests
	wire[4:0] opcode;
	wire[W-1:0]  j_dest, immed_i1, immed_i2, branch_out, brj; //16 bit buses
	
	
	assign j_dest = {{8{instr[10]}}, instr[10:0]}; // always sign extend for j
	assign readReg1 = instr[10:8];
	assign opcode = instr[15:11];
	assign WrR = (STU_sel) ? instr[10:8] : rd_addr;

    //declare sub modules
	regFile_bypass register_file(.read1Data(OutData1), .read2Data(OutData2),. err(reg_file_err),
									.clk(clk), .rst(rst), .read1RegSel(readReg1), .read2RegSel(readReg2),
									.writeRegSel(writein_reg), .writeData(write_back_data), .writeEn(reg_write));
	
	
	extender5to16 i1_extend(.in(instr[4:0]), .sign_extend(sign_extend), .out(immed_i1));
	extender8to16 i2_extend(.in(instr[7:0]), .sign_extend(sign_extend), .out(immed_i2));
	branch br_cntr(.op(branch_op_sel), .en(BranchEn), .out(branch_out), .rs(branch_rs), .imm(immed), .pred_wrong(pred_wrong));
	cla_16b       addr1(.A(fetch_addr), .B(brj), .C_in(1'b0), .S(br_data_decoded), .sign(1'b1), .Ofl(addr1_ofl), .C_out(addr1_c_out));
	
	// other 2 to 1 muxes
	assign readReg2 = reg2_rd_sel? rd_addr : instr[7:5];
	assign rd_addr = rd_sel[1] ?  rd_sel[0] ? 3'b111 : instr[10:8] : rd_sel[0] ? instr[7:5] : instr[4:2];
	assign brj = brj_sel ? j_dest : branch_out;
	assign immed = Im_sel ? immed_i2 :immed_i1;
	
	assign W_reg = WrR;
	assign R_reg1 = readReg1;
	assign R_reg2 = readReg2;
	
   
endmodule
