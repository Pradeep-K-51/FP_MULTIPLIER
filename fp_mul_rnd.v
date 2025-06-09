`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright: Chris Larsen 2019
// Engineer: Chris Larsen
//
// Create Date: 07/26/2019 07:05:10 PM
// Design Name: Parameterized Floating Point Multiplier
// Module Name: fp_mul
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`include "fp_class.sv"
`include "fp_mul_tb_16.v"
//`include "fp_mul_tb_16bit.v"
//`include "fp_mul_tb_32.v"
//`include "fp_mul_tb_32bit.v"
//`include "fp_mul_tb_64bit.v"
//`include "mult_20_05.v"
//`include "csd_070525.v"
`include "mul_usg_old.v"
//`include "mul_bw.v"
//`include "csd_booth.v"
module fp_mul(a, b, rnd, p, pFlags);
  parameter NEXP = 8;
  parameter NSIG = 23;
  input [NEXP+NSIG:0] a, b;
  input [2:0] rnd;
  output [NEXP+NSIG:0] p;
  `include "ieee-754-flags.v"
  output [LAST_FLAG-1:0] pFlags;
  reg [LAST_FLAG-1:0] pFlags;

  wire signed [NEXP+1:0] aExp, bExp;
  reg signed [NEXP+1:0] pExp, t1Exp, t2Exp;
  wire [NSIG:0] aSig, bSig;
  reg [NSIG:0] pSig, tSig;

  reg [NEXP+NSIG:0] pTmp;

  wire [2*NSIG+1:0] rawSignificand;

  wire [LAST_FLAG-1:0] aFlags, bFlags;

  reg pSign;

  fp_class #(NEXP,NSIG) aClass(a, aExp, aSig, aFlags);
  fp_class #(NEXP,NSIG) bClass(b, bExp, bSig, bFlags);

 // assign rawSignificand = aSig * bSig ;
 
   mul_usg#(.NEXP(NEXP),.NSIG(NSIG)) mul(
    .A(aSig),
    .B(bSig),
    .Z(rawSignificand)
  );


/*
   csd_multiply#(.NEXP(NEXP),.NSIG(NSIG)) mul(
    .A(aSig),
    .B(bSig),
    .Z(rawSignificand) 
    );
*/
    // $display("%0d\t %0d\t %0b\t %0b",A,B,aSig,bSig);
     //$display("✅ Testbench completed.");
 /*  
     booth_multiply#(.NEXP(NEXP),.NSIG(NSIG)) mul(
    .A(aSig),
    .B(bSig),
    .Z(rawSignificand) 
    );
 */ 
/*
   mantissa_multiplier_shift_fill #(.NSIG(NSIG)) mul (
        .a_mantissa(aSig),
        .b_mantissa(bSig),
        .product_mantissa(rawSignificand)
    );
*/  

  always @(*)
  begin
    // IEEE 754-2019, section 6.3 requires that "[w]hen neither the
    // inputs nor result are NaN, the sign of a product ... is the
    // exclusive OR of the operands' signs".
    pSign = a[NEXP+NSIG] ^ b[NEXP+NSIG];
    pTmp = {pSign, {NEXP{1'b1}}, 1'b0, {NSIG-1{1'b1}}};  // Initialize p to be an sNaN.
    pFlags = 6'b000000;

    if ((aFlags[SNAN] | bFlags[SNAN]) == 1'b1)
      begin
        pTmp = aFlags[SNAN] == 1'b1 ? a : b;
        pFlags[SNAN] = 1;
      end
    else if ((aFlags[QNAN] | bFlags[QNAN]) == 1'b1)
      begin
        pTmp = aFlags[QNAN] == 1'b1 ? a : b;
        pFlags[QNAN] = 1;
      end
    else if ((aFlags[INFINITY] | bFlags[INFINITY]) == 1'b1)
      begin
        if ((aFlags[ZERO] | bFlags[ZERO]) == 1'b1)
          begin
            pTmp = {pSign, {NEXP{1'b1}}, 1'b1, {NSIG-1{1'b0}}}; // qNaN
            pFlags[QNAN] = 1;
          end
        else
          begin
            pTmp = {pSign, {NEXP{1'b1}}, {NSIG{1'b0}}};
            pFlags[INFINITY] = 1;
          end
      end
    else if ((aFlags[ZERO] | bFlags[ZERO]) == 1'b1 ||
             (aFlags[SUBNORMAL] & bFlags[SUBNORMAL]) == 1'b1)
      begin
        pTmp = {pSign, {NEXP+NSIG{1'b0}}};
        pFlags[ZERO] = 1;
      end
    else // if (((aFlags[SUBNORMAL] | aFlags[NORMAL]) & (bFlags[SUBNORMAL] | bFlags[NORMAL])) == 1'b1)
      begin
        t1Exp = aExp + bExp;

  if (rnd == 3'b100)begin
        if (rawSignificand[2*NSIG+1] == 1'b1)
		if (rawSignificand[NSIG:NSIG-1] == 2'b10 || rawSignificand[NSIG:NSIG-1] == 2'b11)
          		begin
            		tSig = rawSignificand[2*NSIG+1:NSIG+1] + 1'b1;
            		t2Exp = t1Exp + 1;
          		end
		else begin
            		tSig = rawSignificand[2*NSIG+1:NSIG+1];
            		t2Exp = t1Exp + 1;
		end
			
        else
		if (rawSignificand[NSIG-1:NSIG-2] == 2'b10 || rawSignificand[NSIG-1:NSIG-2] == 2'b11)
          begin
            tSig = rawSignificand[2*NSIG:NSIG]+1'b1;
            t2Exp = t1Exp;
          end
	  	else begin
	    tSig = rawSignificand[2*NSIG:NSIG];
            t2Exp = t1Exp;
          end
  end
  else begin
	          if (rawSignificand[2*NSIG+1] == 1'b1)
          begin
            tSig = rawSignificand[2*NSIG+1:NSIG+1];
            t2Exp = t1Exp + 1;
          end
        else
          begin
            tSig = rawSignificand[2*NSIG:NSIG];
            t2Exp = t1Exp;
          end
  end

        if (t2Exp < (EMIN - NSIG))  // Too small to even be represented as
          begin                     // a subnormal; round down to zero.
            pTmp = {pSign, {NEXP+NSIG{1'b0}}};
            pFlags[ZERO] = 1;
          end
        else if (t2Exp < EMIN) // Subnormal
          begin
            pSig = tSig >> (EMIN - t2Exp);
            // Remember that we can only store NSIG bits
            pTmp = {pSign, {NEXP{1'b0}}, pSig[NSIG-1:0]};
            pFlags[SUBNORMAL] = 1;
          end
        else if (t2Exp > EMAX) // Infinity
          begin
            pTmp = {pSign, {NEXP{1'b1}}, {NSIG{1'b0}}};
            pFlags[INFINITY] = 1;
          end
        else // Normal
          begin
            pExp = t2Exp + BIAS;
            pSig = tSig;
            // Remember that for Normals we always assume the most
            // significant bit is 1 so we only store the least
            // significant NSIG bits in the significand.
            pTmp = {pSign, pExp[NEXP-1:0], pSig[NSIG-1:0]};
	    pFlags[NORMAL] = 1;
          end
      end //
  end

  assign p = pTmp;

endmodule
