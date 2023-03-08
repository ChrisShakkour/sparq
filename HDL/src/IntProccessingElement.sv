/*
 
 */
`timescale 1ns/1ns

module IntProccessingElement
  #(
    parameter integer  W_IN_A =8,
    parameter integer  W_IN_B =16,
    localparam integer W_OUT_X =W_IN_B+W_IN_A
    )
   (
    input logic 	       clk,
    input logic 	       rstn,
    input logic 	       set_zero,
    input logic 	       set,
    input logic [W_OUT_X-1:0]  set_value,
    input logic [W_IN_A-1:0]   in_a,
    input logic [W_IN_B-1:0]   in_b,
    output logic [W_OUT_X-1:0] out_x,
    output logic 	       adder_overflow	       
    );

   logic [W_OUT_X-1:0] 	       mult_results;
   logic [W_OUT_X:0] 	       adder_result;
   logic [W_OUT_X-1:0] 	       partial_sum;

   assign out_x          = partial_sum;
   assign adder_overflow = adder_result[W_OUT_X];
   
   always_ff @(posedge clk or negedge rstn) begin
      if(~rstn)         partial_sum <= '0;
      else if(set_zero) partial_sum <= '0;
      else if(set)      partial_sum <= set_value;
      else              partial_sum <= adder_result[W_OUT_X-1:0];
   end
   
   IntMult
     #(.W_IN_A (W_IN_A),
       .W_IN_B (W_IN_B))
   Multiplier_inst
     (
      .in_a    (in_a),
      .in_b    (in_b),
      .out_x   (mult_result)
      );

   IntAdder
     #(.W_IN_A (W_OUT_X),
       .W_IN_B (W_OUT_X))
   Adder_inst
     (
      .in_a    (mult_result),
      .in_b    (partial_sum),
      .out_x   (adder_result)
      );

endmodule // IntProccessingElement
