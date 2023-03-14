/*

  
 */

`timescale 1ns/1ns

module IntAdder
  #(
    parameter integer  W_IN_A =8,
    parameter integer  W_IN_B =16,
    localparam integer W_MAX_OP = ((W_IN_A > W_IN_B) ? W_IN_A : W_IN_B),
    localparam integer W_OUT_X = W_MAX_OP + 1
    )
  (
   input logic [W_IN_A-1:0]   in_a, //signed
   input logic [W_IN_B-1:0]   in_b, //signed
   output logic [W_OUT_X-1:0] out_x
   );
  
  logic                       sign_of_a;
  logic [W_MAX_OP-1:0]        a_extended;
  logic [W_MAX_OP-1:0]        a_pre_adder;

  logic                       sign_of_b;
  logic [W_MAX_OP-1:0]        b_extended;
  logic [W_MAX_OP-1:0]        b_pre_adder;

  // operand a sign extension and handeling
  assign sign_of_a = in_a[W_IN_A-1];
  assign a_extended = (W_MAX_OP==W_IN_A) ? in_a : signed'(in_a);
  assign a_pre_adder = (sign_of_a ? -a_extended : a_extended);
  
  // operand b sign extension and handeling
  assign sign_of_b = in_b[W_IN_B-1];  
  assign b_extended = (W_MAX_OP==W_IN_B) ? in_b : signed'(in_b);
  assign b_pre_adder = (sign_of_b ? -b_extended : b_extended);

  // result
  assign out_x = a_pre_adder + b_pre_adder;
  
endmodule // IntAdder
