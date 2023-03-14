
`timescale 1ns/1ns

module IntVariations
  #(
    // W_FP_THRESHHOLD = W_MANTISSA + W_EXPONENT + 1
    localparam W_INT  = 16,
    localparam W_JUMP = 1, 
    // op A min/max boundries
    localparam OP_A_MAX = W_INT,
    localparam OP_A_MIN = 8,
    // op B min/max boundries
    localparam OP_B_MAX = W_INT,
    localparam OP_B_MIN = 8,
    localparam W_OP_OUT = 2*W_INT 
    )
   (
    input logic 		clk,
    input logic 		rstn,
    input logic 		set_zero [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN],
    input logic 		set [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN],
    input logic [W_INT-1:0] 	set_value [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN],
    input logic [W_INT-1:0] 	in_a [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN],
    input logic [W_INT-1:0] 	in_b [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN],
    output logic [W_OP_OUT-1:0] out_x_reg [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN],
    output logic [W_OP_OUT-1:0] overflow_reg [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN]
    );
  
  genvar                       op_a_i;
  //genvar                       op_b_i;

   logic 		       set_zero_reg  [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];
   logic 		       set_reg       [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];
   logic [W_INT-1:0] 	       set_value_reg [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];  
   logic [W_INT-1:0] 	       in_a_reg      [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];
   logic [W_INT-1:0] 	       in_b_reg      [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];
   logic [W_OP_OUT-1:0]        out_x         [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];
   logic 		       overflow      [OP_B_MAX:OP_B_MIN][OP_A_MAX:OP_A_MIN];
      
  generate
    for(op_a_i=OP_A_MIN; op_a_i<=OP_A_MAX; op_a_i++) begin : operand_a
      //for(op_b_i=OP_A_MIN; op_b_i<=OP_A_MAX; op_b_i++) begin : operand_a

      localparam W_IN_A  = op_a_i;
      localparam W_IN_B  = op_a_i;
      localparam W_OUT_X = W_IN_B + W_IN_A;  

      
       IntProccessingElement #(.W_IN_A(W_IN_A), .W_IN_B(W_IN_B))
       IntProccessingElement_inst
         (
	  .clk		(clk),
	  .rstn		(rstn),
	  .set_zero	(set_zero_reg	[op_a_i][op_a_i]),
	  .set		(set_reg	[op_a_i][op_a_i]),
	  .set_value	(set_value_reg	[op_a_i][op_a_i]),
          .in_a		(in_a_reg	[op_a_i][op_a_i]),
          .in_b		(in_b_reg	[op_a_i][op_a_i]),
          .out_x	(out_x		[op_a_i][op_a_i]),
	  .overflow	(overflow	[op_a_i][op_a_i])
          );

       always_ff @(posedge clk or negedge rstn) begin
          if(~rstn) set_zero_reg[op_a_i][op_a_i] <= '0;
          else      set_zero_reg[op_a_i][op_a_i] <= set_zero[op_a_i][op_a_i];
       end

       always_ff @(posedge clk or negedge rstn) begin
          if(~rstn) set_reg[op_a_i][op_a_i] <= '0;
          else      set_reg[op_a_i][op_a_i] <= set[op_a_i][op_a_i];
       end

       always_ff @(posedge clk or negedge rstn) begin
          if(~rstn) set_value_reg[op_a_i][op_a_i] <= '0;
          else      set_value_reg[op_a_i][op_a_i] <= set_value[op_a_i][op_a_i];
       end
       
      always_ff @(posedge clk or negedge rstn) begin
        if(~rstn) in_a_reg[op_a_i][op_a_i] <= '0;
        else      in_a_reg[op_a_i][op_a_i] <= in_a[op_a_i][op_a_i];
      end

      always_ff @(posedge clk or negedge rstn) begin
        if(~rstn) in_b_reg[op_a_i][op_a_i] <= '0;
        else      in_b_reg[op_a_i][op_a_i] <= in_b[op_a_i][op_a_i];
      end

      always_ff @(posedge clk or negedge rstn) begin
        if(~rstn) out_x_reg[op_a_i][op_a_i] <= '0;
        else      out_x_reg[op_a_i][op_a_i] <= out_x[op_a_i][op_a_i];
      end

       always_ff @(posedge clk or negedge rstn) begin
          if(~rstn) overflow_reg[op_a_i][op_a_i] <= '0;
          else      overflow_reg[op_a_i][op_a_i] <= overflow[op_a_i][op_a_i];
       end

    end
    //  end
  endgenerate
  
endmodule // FpMultVariations
