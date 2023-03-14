/*
 
 */

`timescale 1ns/1ns

module FpAdder
  #(
    parameter integer  W_MANTISSA = 8,
    parameter integer  W_EXPONENT = 8,
    localparam integer W_FP_NUMBER = W_MANTISSA + W_EXPONENT + 1 // 1 for sign bit 
    )
   (
    input logic [W_FP_NUMBER-1:0]  in_a,
    input logic [W_FP_NUMBER-1:0]  in_b,
    output logic [W_FP_NUMBER-1:0] out_x,
    output logic 		   overflow,
    output logic 		   underflow,
    output logic 		   exception
    );

   // sign
   logic 			   sign_of_a;
   logic 			   sign_of_b;
   logic 			   sign_of_x;
   // exponent 
   logic [W_EXPONENT-1:0] 	   exponent_of_a;
   logic [W_EXPONENT-1:0] 	   exponent_of_b;
   logic [W_EXPONENT-1:0] 	   exponent_of_x;
   logic [W_EXPONENT:0] 	   exponent_of_x_result;
   logic 			   exponent_of_a_is_zero;
   logic 			   exponent_of_b_is_zero;
   logic [W_EXPONENT-1:0] 	   exponent_bias;
   // mantissa
   logic [W_MANTISSA-1:0] 	   mantissa_of_a;
   logic [W_MANTISSA-1:0] 	   mantissa_of_b;
   logic [W_MANTISSA-1:0] 	   mantissa_of_x;
   logic [W_MANTISSA:0] 	   mantissa_of_a_extended;
   logic [W_MANTISSA:0] 	   mantissa_of_b_extended;

   // sign calculaions
   assign sign_of_a		= in_a[W_FP_NUMBER-1];
   assign sign_of_b		= in_b[W_FP_NUMBER-1];
   //assign sign_of_x		= sign_of_a ^ sign_of_b;

   // exponent calculations
   assign exponent_bias         = {1'b0, {(W_EXPONENT-1){1'b1}}};
   assign exponent_of_a		= in_a[W_MANTISSA+:W_EXPONENT];
   assign exponent_of_b		= in_b[W_MANTISSA+:W_EXPONENT];
   assign exponent_of_a_is_zero = (exponent_of_a=='0);
   assign exponent_of_b_is_zero = (exponent_of_b=='0);
   assign exception             = (exponent_of_a=='1) | (exponent_of_b=='1);



endmodule // FpAdder
