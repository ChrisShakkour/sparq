/*
 
 */

`timescale 1ns/1ns

module FpProccessingElement
  #(
    parameter integer  W_MANTISSA = 8,
    parameter integer  W_EXPONENT = 8,
    localparam integer W_FP_NUMBER = W_MANTISSA + W_EXPONENT + 1 // 1 for sign bit 
    )
   (
    input logic 		   clk,
    input logic 		   rstn,
    input logic 		   set_zero,
    input logic 		   set,
    input logic [W_FP_NUMBER-1:0]  set_value,
    input logic [W_FP_NUMBER-1:0]  in_a,
    input logic [W_FP_NUMBER-1:0]  in_b,
    output logic [W_FP_NUMBER-1:0] out_x,
    output logic 		   overflow,
    output logic 		   underflow,
    output logic 		   exception
    );

   logic [W_FP_NUMBER-1:0] 	   mult_result;
   logic [W_FP_NUMBER-1:0] 	   adder_result;
   logic [W_FP_NUMBER-1:0] 	   partial_sum;

   assign out_x          = partial_sum;
   assign adder_overflow = adder_result;
   
   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn)         partial_sum <= '0;
      else if(set_zero) partial_sum <= '0;
      else if(set)      partial_sum <= set_value;
      else              partial_sum <= adder_result;
   end
   
   FpMult
     #(.W_MANTISSA (W_MANTISSA),
       .W_EXPONENT (W_EXPONENT))
   Multiplier_inst
     (
      .in_a      (in_a),
      .in_b      (in_b),
      .out_x     (mult_result),
      .overflow  (overflow),
      .underflow (underflow),
      .exception (exception)
      );

   FpAdder
     #(.W_MANTISSA (W_MANTISSA),
       .W_EXPONENT (W_EXPONENT))
   Adder_inst
     (
      .in_a    (mult_result),
      .in_b    (partial_sum),
      .out_x   (adder_result)
      );

endmodule // FpProccessingElement
