module cache_ctrl(DataIn, addr_i, hit0, hit1, dirty0, dirty1, valid0, valid1, c_err0, c_err1, m_err, stall, c_data0, c_data1, m_data, busy, tag_i0, tag_i1, clk, rst, Rd, way_sel,
					Wr, enable0, enable1, offset, comp, wr, tag_o, c_data_in, c_valid_in, index, addr_o, m_data_in, m_wr, m_rd, done, err, req, is_hit, new_req, cache_data, state);
					
	input [15:0] DataIn, addr_i, c_data0, c_data1, m_data;
	input [4:0] tag_i0, tag_i1;
	input [3:0] busy;
	input hit0, hit1, dirty0, dirty1, valid0, valid1, c_err0, c_err1, m_err, stall, clk, rst, Rd, Wr, way_sel;
	
	output err;
	output reg done, req, new_req;
	output reg enable0, enable1, comp, wr, c_valid_in, m_wr, m_rd, is_hit;
	output reg [4:0] tag_o;
	output reg [2:0] offset;
	output reg [7:0] index;
	output reg [15:0] c_data_in, addr_o, m_data_in, cache_data;

	reg from_idle, cache_sel;
	
	reg [1:0] optype, next_AR, next_AW, next_WD;
	wire [1:0] ARcount, AWcount, WDcount;
	
	output [2:0] state;
	reg [15:0] data, address;
	
	parameter 	IDLE = 3'b000, 
				COMP_WRITE = 3'b001,
				COMP_READ = 3'b010,
				ACCESS_READ = 3'b011,
				ACCESS_WRITE = 3'b100,
				WAIT_DATA = 3'b101;

	wire [3:0] sm_err;
	reg [2:0] next_state;
	assign err = m_err|c_err0|c_err1|(|sm_err);
	register_3b state_machine(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(1'b1), .w_data(next_state), .r_data(state), .err(sm_err[0]));
	register_2b wd_counter(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(1'b1), .w_data(next_WD), .r_data(WDcount), .err(sm_err[1]));
	register_2b ar_counter(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(1'b1), .w_data(next_AR), .r_data(ARcount), .err(sm_err[2]));
	register_2b aw_counter(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(1'b1), .w_data(next_AW), .r_data(AWcount), .err(sm_err[3]));
	
	always @(*) begin
		case(state)
			IDLE: begin
				enable0 = 1'b0;
				enable1 = 1'b0;
				m_wr = 1'b0;
				m_rd = 1'b0;
				optype = {Wr, Rd};
				data = DataIn;
				address = addr_i;
				done = 1'b0;
				next_AR = 2'b00;
				next_AW = 2'b00;
				next_WD = 2'b00;
				req = ((optype == 2'b01) || (optype == 2'b10)) ? 1'b1: 1'b0;
				new_req = ((optype == 2'b01) || (optype == 2'b10)) ? 1'b1: 1'b0;
				is_hit = 1'b0;
				from_idle = 1'b1;
				next_state = (optype == 2'b01) ? COMP_READ: ((optype == 2'b10) ? COMP_WRITE : IDLE);
			end
			COMP_READ: begin
				new_req = 1'b0;
				enable0 = 1'b1;
				enable1 = 1'b1;
				comp = 1'b1;
				wr = 1'b0;
				m_wr = 1'b0;
				m_rd = 1'b0;
				tag_o = address[15:11];
				index = address[10:3];
				offset = address[2:0];
				is_hit = ((from_idle&&(hit0&valid0))||(from_idle&&(hit1&valid1))) ? 1'b1 : 1'b0;
				cache_data = (hit0&valid0) ? c_data0 : ((hit1&valid1) ? c_data1 : 0);
				cache_sel = ((~valid0)&&(~valid1)) ? 1'b0 : ((~valid0) ? 1'b0 : ((~valid1) ? 1'b1 : way_sel));
				next_state = ((hit0&valid0)||(hit1&valid1)) ? IDLE : ((((~cache_sel)&(~hit0)&valid0&dirty0) || (cache_sel&(~hit1)&valid1&dirty1)) ? ACCESS_READ : WAIT_DATA);
				done = ((hit0&valid0)||(hit1&valid1)) ? 1'b1 : 1'b0;
				req = ((hit0&valid0)||(hit1&valid1)) ? 1'b0 : req;	
			end
			ACCESS_READ: begin
				enable0 = (cache_sel == 1'b0) ? 1'b1 : 1'b0;
				enable1 = (cache_sel == 1'b1) ? 1'b1 : 1'b0;
				comp = 1'b0;
				wr = 1'b0;
				index = address[10:3];
				offset = {{ARcount[1:0]}, {1'b0}};
				addr_o = (cache_sel) ? {tag_i1, index, offset} : {tag_i0, index, offset};
				m_data_in = (cache_sel) ? c_data1 : c_data0;
				m_wr = 1'b1;
				m_rd = 1'b0;
				done = 1'b0;
				from_idle = 1'b0;
				next_state = (&ARcount) ? WAIT_DATA : ACCESS_READ;
				next_AR = (&ARcount) ? 2'b00 : (ARcount + 1);
			end
			WAIT_DATA: begin
				enable0 = 1'b0;
				enable1 = 1'b0;
				comp = 1'b0;
				wr = 1'b0;
				addr_o = {{address[15:3]}, {WDcount[1:0]}, {1'b0}};
				m_wr = 1'b0;
				m_rd = 1'b1;
				done = 1'b0;
				from_idle = 1'b0;
				next_state = (WDcount >= 1) ? ACCESS_WRITE : WAIT_DATA;
				next_WD = WDcount + 1;
			end
			ACCESS_WRITE: begin
				enable0 = (cache_sel == 1'b0) ? 1'b1 : 1'b0;
				enable1 = (cache_sel == 1'b1) ? 1'b1 : 1'b0;
				addr_o = {{address[15:3]}, {WDcount[1:0]}, {1'b0}};
				m_wr = 1'b0;
				m_rd = ((WDcount<=3)&&(WDcount>=2)) ? 1'b1 : 1'b0;
				comp = 1'b0;
				wr = 1'b1;
				tag_o = address[15:11];
				index = address[10:3];
				offset = {{AWcount[1:0]}, {1'b0}};
				c_data_in = m_data;
				c_valid_in = 1'b1;
				done = 1'b0;
				from_idle = 1'b0;
				next_state = (&AWcount) ? ((optype==1) ? COMP_READ : COMP_WRITE) : ACCESS_WRITE;
				next_WD = (&WDcount) ? 2'b0 : (WDcount+1);
				next_AW = (&AWcount) ? 2'b0 : (AWcount+1);
			end
			COMP_WRITE: begin
				new_req = 1'b0;
				enable0 = 1'b1;
				enable1 = 1'b1;
				comp = 1'b1;
				wr = 1'b1;
				m_wr = 1'b0;
				m_rd = 1'b0;
				index = address[10:3];
				offset = address[2:0];
				tag_o = address[15:11];
				c_data_in = data;
				is_hit = ((from_idle&&(hit0&valid0))||(from_idle&&(hit1&valid1)))? 1'b1 : 1'b0;
				cache_sel = ((~valid0)&&(~valid1)) ? 1'b0 : ((~valid0) ? 1'b0 : ((~valid1) ? 1'b1 : way_sel));
				next_state = ((hit0&valid0)||(hit1&valid1)) ? IDLE : ((((~cache_sel)&(~hit0)&valid0&dirty0) || (cache_sel&(~hit1)&valid1&dirty1)) ? ACCESS_READ : WAIT_DATA);
				done = ((hit0&valid0)||(hit1&valid1)) ? 1'b1 : 1'b0;
				req = ((hit0&valid0)||(hit1&valid1)) ? 1'b0 : req;	
			end
			default: begin
				next_state = IDLE;
				new_req = 1'b0;
				req = 1'b0;
				enable0 = 1'b0;
				enable1 = 1'b0;
				m_wr = 1'b0;
				m_rd = 1'b0;
				done = 1'b0;
				from_idle = 1'b0;
				is_hit = 1'b0;
				from_idle = 1'b0;
			end
		endcase
		

		
	end
	
	
endmodule