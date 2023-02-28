
`timescale 1ns/1ns

module FpMultVariations
  #(
    // W_FP_THRESHHOLD = W_MANTISSA + W_EXPONENT + 1
    localparam W_FP_THRESHOLD = 16,
    // mantissa min/max boundries
    localparam MAN_MAX = W_FP_THRESHOLD-3,
    localparam MAN_MIN = 3,
    // exponent min/max boundries
    localparam EXP_MAX = W_FP_THRESHOLD-3,
    localparam EXP_MIN = 3
    )
   (
    input logic 		      clk,
    input logic 		      rstn,
    input logic [W_FP_THRESHOLD-1:0]  in_a [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN],
    input logic [W_FP_THRESHOLD-1:0]  in_b [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN],
    output logic [W_FP_THRESHOLD-1:0] out_x_reg [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN],
    output logic 		      underflow_reg [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN],
    output logic 		      overflow_reg [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN],
    output logic 		      exception_reg [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN]
    );
   
   genvar 			      exponent_i;
   genvar 			      mantissa_i;

   logic [W_FP_THRESHOLD-1:0] 	      in_a_reg  [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN];
   logic [W_FP_THRESHOLD-1:0] 	      in_b_reg  [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN];
   logic [W_FP_THRESHOLD-1:0] 	      out_x     [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN];
   logic 			      underflow [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN];
   logic 			      overflow  [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN];
   logic 			      exception [EXP_MAX:EXP_MIN][MAN_MAX:MAN_MIN];
   
   generate
      for(exponent_i=EXP_MIN; exponent_i<=EXP_MAX; exponent_i++) begin : exponent_row
	 for(mantissa_i=MAN_MIN; mantissa_i<=MAN_MAX; mantissa_i++) begin : mantissa_col

	    localparam W_EXPONENT  = exponent_i;
	    localparam W_MANTISSA  = mantissa_i;
	    localparam W_FP_NUMBER = W_MANTISSA + W_EXPONENT;  
	    
	    if(W_FP_NUMBER < W_FP_THRESHOLD) begin : fp_mult_inst_enable
	       FpMult #(.W_MANTISSA(W_MANTISSA), .W_EXPONENT(W_EXPONENT))
	       FpMult_inst
		 (
		  .in_a		(in_a_reg  [exponent_i][mantissa_i]),
		  .in_b		(in_b_reg  [exponent_i][mantissa_i]),
		  .out_x	(out_x     [exponent_i][mantissa_i]),
		  .overflow	(overflow  [exponent_i][mantissa_i]),
		  .underflow	(underflow [exponent_i][mantissa_i]),
		  .exception    (exception [exponent_i][mantissa_i])
		  );

	       always_ff @(posedge clk or negedge rstn) begin
		  if(~rstn) in_a_reg[exponent_i][mantissa_i] <= '0;
		  else      in_a_reg[exponent_i][mantissa_i] <= in_a[exponent_i][mantissa_i];
	       end

	       always_ff @(posedge clk or negedge rstn) begin
		  if(~rstn) in_b_reg[exponent_i][mantissa_i] <= '0;
		  else      in_b_reg[exponent_i][mantissa_i] <= in_b[exponent_i][mantissa_i];
	       end

	       always_ff @(posedge clk or negedge rstn) begin
		  if(~rstn) out_x_reg[exponent_i][mantissa_i] <= '0;
		  else      out_x_reg[exponent_i][mantissa_i] <= out_x[exponent_i][mantissa_i];
	       end

	       always_ff @(posedge clk or negedge rstn) begin
		  if(~rstn) underflow_reg[exponent_i][mantissa_i] <= '0;
		  else      underflow_reg[exponent_i][mantissa_i] <= underflow[exponent_i][mantissa_i];
	       end

	       always_ff @(posedge clk or negedge rstn) begin
		  if(~rstn) overflow_reg[exponent_i][mantissa_i] <= '0;
		  else      overflow_reg[exponent_i][mantissa_i] <= overflow[exponent_i][mantissa_i];
	       end

	       always_ff @(posedge clk or negedge rstn) begin
		  if(~rstn) exception_reg[exponent_i][mantissa_i] <= '0;
		  else      exception_reg[exponent_i][mantissa_i] <= exception[exponent_i][mantissa_i];
	       end	       
	    end	    
	 end
      end
   endgenerate
   
endmodule // FpMultVariations
