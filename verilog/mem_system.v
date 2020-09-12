/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err, state,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;
   output [2:0] state;
   
   wire hit0, hit1, dirty0, dirty1, valid0, valid1, c_err0, c_err1, cache_en0, cache_en1,
		comp, write, c_valid_in, m_wr, m_rd, m_err, m_stall, req, new_req, is_hit, way_sel;
   wire [7:0] index;
   wire [2:0] offset;
   wire [3:0] busy;
   wire [4:0] tag_out0, tag_out1, tag;
   wire [15:0] c_data0, c_data1, c_data_in, addr, m_data_in, m_data, cache_data;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out0),
                          .data_out             (c_data0),
                          .hit                  (hit0),
                          .dirty                (dirty0),
                          .valid                (valid0),
                          .err                  (c_err0),
                          // Inputs
                          .enable               (cache_en0),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (c_data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (c_valid_in));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (tag_out1),
                          .data_out             (c_data1),
                          .hit                  (hit1),
                          .dirty                (dirty1),
                          .valid                (valid1),
                          .err                  (c_err1),
                          // Inputs
                          .enable               (cache_en1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (c_data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (c_valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (m_data),
                     .stall             (m_stall),
                     .busy              (busy),
                     .err               (m_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (addr),
                     .data_in           (m_data_in),
                     .wr                (m_wr),
                     .rd                (m_rd));
   
   // your code here
	wire cc_err, new_way, way_err;
	assign new_way = new_req ? ~way_sel : way_sel;
	register_1b way(.clk(clk), .rst(rst), .chosen(1'b1), .w_en(1'b1), .w_data(new_way), .r_data(way_sel), .err(way_err));
	assign DataOut = (cache_en0 || cache_en1) ? cache_data : DataOut;
	assign CacheHit = is_hit;
	assign Stall = req;
	assign err = cc_err|way_err;

	cache_ctrl cache_controller(.DataIn(DataIn), .addr_i(Addr), .hit0(hit0), .hit1(hit1), .dirty0(dirty0), .dirty1(dirty1),
								.valid0(valid0), .valid1(valid1), .c_err0(c_err0), .c_err1(c_err1), .m_err(m_err), .stall(m_stall),
								.c_data0(c_data0), .c_data1(c_data1), .m_data(m_data), .busy(busy), .tag_i0(tag_out0), .tag_i1(tag_out1),
								.clk(clk), .rst(rst), .Rd(Rd), .way_sel(way_sel), .Wr(Wr), .enable0(cache_en0), .enable1(cache_en1),
								.offset(offset), .comp(comp), .wr(write), .tag_o(tag), .c_data_in(c_data_in), .c_valid_in(c_valid_in),
								.index(index), .addr_o(addr), .m_data_in(m_data_in), .m_wr(m_wr), .m_rd(m_rd), .done(Done), .err(cc_err),
								.req(req), .is_hit(is_hit), .new_req(new_req), .cache_data(cache_data), .state(state));

   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
