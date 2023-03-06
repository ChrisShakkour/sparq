
`timescale 1ns/1ns

module FpMultVariations
  #(
    // W_FP_THRESHHOLD = W_MANTISSA + W_EXPONENT + 1
    localparam W_INT  = 32,
    localparam W_JUMP = 8, 
    // mantissa min/max boundries
    localparam OP_A_MAX = W_INT/W_JUMP,
    localparam OP_A_MIN = 1,
    // exponent min/max boundries
    localparam OP_B_MAX = W_INT/W_JUMP,
    localparam OP_B_MIN = 1,
    localparam W_OP_OUT = 2*W_INT; 
    )
   (
    input logic 	     clk,
    input logic 	     rstn,
    input logic [W_INT-1:0]  in_a [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN],
    input logic [W_INT-1:0]  in_b [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN],
    output logic [W_OP_OUT-1:0] out_x_reg [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN]
    );
   
   genvar 			      op_a_i;
   genvar 			      op_b_i;

   logic [W_INT-1:0] 		      in_a_reg  [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];
   logic [W_INT-1:0] 		      in_b_reg  [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];
   logic [W_OP_OUT-1:0] 	      out_x     [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];
   
   generate
      for(op_a_i=OP_B_MIN; op_a_i<=OP_B_MAX; op_a_i++) begin : operand_b
	 for(op_b_i=OP_A_MIN; op_b_i<=OP_A_MAX; op_b_i++) begin : operand_a

	    localparam W_IN_A  = op_a_i * W_JUMP;
	    localparam W_IN_B  = op_b_i * W_JUMP;
	    localparam W_OUT_X = W_IN_B + W_IN_A;  

	    
	    IntMult #(.W_IN_A(W_IN_A), .W_IN_B(W_IN_B))
	    IntMult_inst
	      (
	       .in_a	(in_a_reg  [op_a_i][op_b_i]),
	       .in_b	(in_b_reg  [op_a_i][op_b_i]),
	       .out_x	(out_x     [op_a_i][op_b_i])
	       );

	    always_ff @(posedge clk or negedge rstn) begin
	       if(~rstn) in_a_reg[op_a_i][op_b_i] <= '0;
	       else      in_a_reg[op_a_i][op_b_i] <= in_a[op_a_i][op_b_i];
	    end

	    always_ff @(posedge clk or negedge rstn) begin
	       if(~rstn) in_b_reg[op_a_i][op_b_i] <= '0;
	       else      in_b_reg[op_a_i][op_b_i] <= in_b[op_a_i][op_b_i];
	    end

	    always_ff @(posedge clk or negedge rstn) begin
	       if(~rstn) out_x_reg[op_a_i][op_b_i] <= '0;
	       else      out_x_reg[op_a_i][op_b_i] <= out_x[op_a_i][op_b_i];
	    end
	 end
      end
   endgenerate
   
endmodule // FpMultVariations
