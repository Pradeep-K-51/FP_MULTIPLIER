`timescale 1ns / 1ps

module fp_mul_tb_16;
  parameter NEXP = 5;
  parameter NSIG = 10;
  reg [NEXP+NSIG:0] a, b;
  reg [2:0]  rnd;
  wire [NEXP+NSIG:0] p;
  `include "ieee-754-flags.v"
  wire [LAST_FLAG-1:0] flags;

  integer i, j, k, l, m, n, outfile;

initial begin
        // Open file for writing
        outfile = $fopen("16_bit_test_results.txt", "w");
        if (outfile == 0) begin
           $fwrite(outfile,"Failed to open output file!");
            $stop;
        end
end
  initial
  begin
   $fwrite(outfile,"Test multiply circuit for binary%d:\n\n", NEXP+NSIG+1);
     assign rnd = 3'b100;
    // For these tests a is always a signalling NaN.
   $fwrite(outfile,"sNaN * {sNaN, qNaN, infinity, zero, subnormal, normal}:");
    #0  assign a = {1'b0, {NEXP{1'b1}}, 1'b0, ({NSIG-1{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b1}}, 1'b0, ({NSIG-1{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    // For these tests b is always a signalling NaN.
    #10$fwrite(outfile,"\n{qNaN, infinity, zero, subnormal, normal} * sNaN:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, 1'b0, ({NSIG-1{1'b0}} | 4'hB)};
        assign a = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    // For these tests a is always a quiet NaN.
    #10$fwrite(outfile,"\nqNaN * {qNaN, infinity, zero, subnormal, normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    // For these tests b is always a quiet NaN.
    #10$fwrite(outfile,"\n{infinity, zero, subnormal, normal} * qNaN:");
    #10  assign b = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hB)};
         assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10  assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10  assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10  assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};


    #10$fwrite(outfile,"\n+infinity * {+infinity, +zero, +subnormal, +normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n{+zero, +subnormal, +normal} * +infinity:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10$fwrite(outfile,"\n+infinity * {-infinity, -zero, -subnormal, -normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n{+zero, +subnormal, +normal} * -infinity:");
    #10 assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10$fwrite(outfile,"\n-infinity * {+infinity, +zero, +subnormal, +normal}:");
    #10 assign a = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n{-zero, -subnormal, -normal} * +infinity:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10$fwrite(outfile,"\n-infinity * {-infinity, -zero, -subnormal, -normal}:");
    #10 assign a = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n{-zero, -subnormal, -normal} * -infinity:");
    #10 assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10$fwrite(outfile,"\n+zero * {+zero, +subnormal, +normal}:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n{+subnormal, +normal} * +zero:");
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10$fwrite(outfile,"\n-zero * {+zero, +subnormal, +normal}:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n{-subnormal, -normal} * +zero:");
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10$fwrite(outfile,"\n+zero * {-zero, -subnormal, -normal}:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n{+subnormal, +normal} * -zero:");
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10$fwrite(outfile,"\n-zero * {-zero, -subnormal, -normal}:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n{-subnormal, -normal} * -zero:");
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10$fwrite(outfile,"\n+subnormal * +subnormal:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n+subnormal * -subnormal:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n-subnormal * +subnormal:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n-subnormal * -subnormal:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10$fwrite(outfile,"\n1 * 2**15:");
    #10 assign a = 16'h3C00; assign b = 16'h7800;

    #10$fwrite(outfile,"\n1 * 2**14:");
    #10 assign a = 16'h3C00; assign b = 16'h7400;

    #10$fwrite(outfile,"\n1 * 2**13:");
    #10 assign a = 16'h3C00; assign b = 16'h7000;

    #10$fwrite(outfile,"\n1 * 2**12:");
    #10 assign a = 16'h3C00; assign b = 16'h6C00;

    #10$fwrite(outfile,"\n1 * 2**11:");
    #10 assign a = 16'h3C00; assign b = 16'h6800;

    #10$fwrite(outfile,"\n1 * 2**10:");
    #10 assign a = 16'h3C00; assign b = 16'h6400;

    #10$fwrite(outfile,"\n1 * 2**9:");
    #10 assign a = 16'h3C00; assign b = 16'h6000;

    #10$fwrite(outfile,"\n1 * 2**8:");
    #10 assign a = 16'h3C00; assign b = 16'h5C00;

    #10$fwrite(outfile,"\n1 * 2**7:");
    #10 assign a = 16'h3C00; assign b = 16'h5800;

    #10$fwrite(outfile,"\n1 * 2**6:");
    #10 assign a = 16'h3C00; assign b = 16'h5400;

    #10$fwrite(outfile,"\n1 * 2**5:");
    #10 assign a = 16'h3C00; assign b = 16'h5000;

    #10$fwrite(outfile,"\n1 * 2**4:");
    #10 assign a = 16'h3C00; assign b = 16'h4C00;

    #10$fwrite(outfile,"\n1 * 2**3:");
    #10 assign a = 16'h3C00; assign b = 16'h4800;

    #10$fwrite(outfile,"\n1 * 2**2:");
    #10 assign a = 16'h3C00; assign b = 16'h4400;

    #10$fwrite(outfile,"\n1 * 2**1:");
    #10 assign a = 16'h3C00; assign b = 16'h4000;

    #10$fwrite(outfile,"\n1 * 2**0:");
    #10 assign a = 16'h3C00; assign b = 16'h3C00;

    #10$fwrite(outfile,"\n1 * 2**-1:");
    #10 assign a = 16'h3C00; assign b = 16'h3800;

    #10$fwrite(outfile,"\n1 * 2**-2:");
    #10 assign a = 16'h3C00; assign b = 16'h3400;

    #10$fwrite(outfile,"\n1 * 2**-3:");
    #10 assign a = 16'h3C00; assign b = 16'h3000;

    #10$fwrite(outfile,"\n1 * 2**-4:");
    #10 assign a = 16'h3C00; assign b = 16'h2C00;

    #10$fwrite(outfile,"\n1 * 2**-5:");
    #10 assign a = 16'h3C00; assign b = 16'h2800;

    #10$fwrite(outfile,"\n1 * 2**-6:");
    #10 assign a = 16'h3C00; assign b = 16'h2400;

    #10$fwrite(outfile,"\n1 * 2**-7:");
    #10 assign a = 16'h3C00; assign b = 16'h2000;

    #10$fwrite(outfile,"\n1 * 2**-8:");
    #10 assign a = 16'h3C00; assign b = 16'h1C00;

    #10$fwrite(outfile,"\n1 * 2**-9:");
    #10 assign a = 16'h3C00; assign b = 16'h1800;

    #10$fwrite(outfile,"\n1 * 2**-10:");
    #10 assign a = 16'h3C00; assign b = 16'h1400;

    #10$fwrite(outfile,"\n1 * 2**-11:");
    #10 assign a = 16'h3C00; assign b = 16'h1000;

    #10$fwrite(outfile,"\n1 * 2**-12:");
    #10 assign a = 16'h3C00; assign b = 16'h0C00;

    #10$fwrite(outfile,"\n1 * 2**-13:");
    #10 assign a = 16'h3C00; assign b = 16'h0800;

    #10$fwrite(outfile,"\n1 * 2**-14:");
    #10 assign a = 16'h3C00; assign b = 16'h0400;

    #10$fwrite(outfile,"\n1 * 2**-15:");
    #10 assign a = 16'h3C00; assign b = 16'h0200;

    #10$fwrite(outfile,"\n1 * 2**-16:");
    #10 assign a = 16'h3C00; assign b = 16'h0100;

    #10$fwrite(outfile,"\n1 * 2**-17:");
    #10 assign a = 16'h3C00; assign b = 16'h0080;

    #10$fwrite(outfile,"\n1 * 2**-18:");
    #10 assign a = 16'h3C00; assign b = 16'h0040;

    #10$fwrite(outfile,"\n1 * 2**-19:");
    #10 assign a = 16'h3C00; assign b = 16'h0020;

    #10$fwrite(outfile,"\n1 * 2**-20:");
    #10 assign a = 16'h3C00; assign b = 16'h0010;

    #10$fwrite(outfile,"\n1 * 2**-21:");
    #10 assign a = 16'h3C00; assign b = 16'h0008;

    #10$fwrite(outfile,"\n1 * 2**-22:");
    #10 assign a = 16'h3C00; assign b = 16'h0004;

    #10$fwrite(outfile,"\n1 * 2**-23:");
    #10 assign a = 16'h3C00; assign b = 16'h0002;

    #10$fwrite(outfile,"\n1 * 2**-24:");
    #10 assign a = 16'h3C00; assign b = 16'h0001;

    #10$fwrite(outfile,"\n2**15 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h7800;

    #10$fwrite(outfile,"\n2**14 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h7400;

    #10$fwrite(outfile,"\n2**13 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h7000;

    #10$fwrite(outfile,"\n2**12 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h6C00;

    #10$fwrite(outfile,"\n2**11 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h6800;

    #10$fwrite(outfile,"\n2**10 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h6400;

    #10$fwrite(outfile,"\n2**9 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h6000;

    #10$fwrite(outfile,"\n2**8 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h5C00;

    #10$fwrite(outfile,"\n2**7 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h5800;

    #10$fwrite(outfile,"\n2**6 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h5400;

    #10$fwrite(outfile,"\n2**5 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h5000;

    #10$fwrite(outfile,"\n2**4 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h4C00;

    #10$fwrite(outfile,"\n2**3 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h4800;

    #10$fwrite(outfile,"\n2**2 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h4400;

    #10$fwrite(outfile,"\n2**1 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h4000;

    #10$fwrite(outfile,"\n2**0 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h3C00;

    #10$fwrite(outfile,"\n2**-1 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h3800;

    #10$fwrite(outfile,"\n2**-2 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h3400;

    #10$fwrite(outfile,"\n2**-3 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h3000;

    #10$fwrite(outfile,"\n2**-4 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h2C00;

    #10$fwrite(outfile,"\n2**-5 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h2800;

    #10$fwrite(outfile,"\n2**-6 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h2400;

    #10$fwrite(outfile,"\n2**-7 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h2000;

    #10$fwrite(outfile,"\n2**-8 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h1C00;

    #10$fwrite(outfile,"\n2**-9 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h1800;

    #10$fwrite(outfile,"\n2**-10 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h1400;

    #10$fwrite(outfile,"\n2**-11 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h1000;

    #10$fwrite(outfile,"\n2**-12 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0C00;

    #10$fwrite(outfile,"\n2**-13 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0800;

    #10$fwrite(outfile,"\n2**-14 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0400;

    #10$fwrite(outfile,"\n2**-15 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0200;

    #10$fwrite(outfile,"\n2**-16 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0100;

    #10$fwrite(outfile,"\n2**-17 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0080;

    #10$fwrite(outfile,"\n2**-18 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0040;

    #10$fwrite(outfile,"\n2**-19 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0020;

    #10$fwrite(outfile,"\n2**-20 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0010;

    #10$fwrite(outfile,"\n2**-21 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0008;

    #10$fwrite(outfile,"\n2**-22 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0004;

    #10$fwrite(outfile,"\n2**-23 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0002;

    #10$fwrite(outfile,"\n2**-24 * 1:");
    #10 assign b = 16'h3C00; assign a = 16'h0001;

    #10$fwrite(outfile,"\n2**0 * 2**15:");
    #10 assign a = 16'h3C00; assign b = 16'h7800;
    #10 assign a = 16'h3FFF; assign b = 16'h7BFF;

    #10$fwrite(outfile,"\n2**1 * 2**14:");
    #10 assign a = 16'h4000; assign b = 16'h7400;
    #10 assign a = 16'h43FF; assign b = 16'h77FF;

    #10$fwrite(outfile,"\n2**2 * 2**13:");
    #10 assign a = 16'h4400; assign b = 16'h7000;
    #10 assign a = 16'h47FF; assign b = 16'h73FF;

    #10$fwrite(outfile,"\n2**3 * 2**12:");
    #10 assign a = 16'h4800; assign b = 16'h6C00;
    #10 assign a = 16'h4BFF; assign b = 16'h6FFF;

    #10$fwrite(outfile,"\n2**4 * 2**11:");
    #10 assign a = 16'h4C00; assign b = 16'h6800;
    #10 assign a = 16'h4FFF; assign b = 16'h6BFF;

    #10$fwrite(outfile,"\n2**5 * 2**10:");
    #10 assign a = 16'h5000; assign b = 16'h6400;
    #10 assign a = 16'h53FF; assign b = 16'h67FF;

    #10$fwrite(outfile,"\n2**6 * 2**9:");
    #10 assign a = 16'h5400; assign b = 16'h6000;
    #10 assign a = 16'h57FF; assign b = 16'h63FF;

    #10$fwrite(outfile,"\n2**7 * 2**8:");
    #10 assign a = 16'h5800; assign b = 16'h5C00;
    #10 assign a = 16'h5BFF; assign b = 16'h5FFF;

    #10$fwrite(outfile,"\n2**8 * 2**7:");
    #10 assign a = 16'h5C00; assign b = 16'h5800;
    #10 assign a = 16'h5FFF; assign b = 16'h5BFF;

    #10$fwrite(outfile,"\n2**9 * 2**6:");
    #10 assign a = 16'h6000; assign b = 16'h5400;
    #10 assign a = 16'h63FF; assign b = 16'h57FF;

    #10$fwrite(outfile,"\n2**10 * 2**5:");
    #10 assign a = 16'h6400; assign b = 16'h5000;
    #10 assign a = 16'h67FF; assign b = 16'h53FF;

    #10$fwrite(outfile,"\n2**11 * 2**4:");
    #10 assign a = 16'h6800; assign b = 16'h4C00;
    #10 assign a = 16'h6BFF; assign b = 16'h4FFF;

    #10$fwrite(outfile,"\n2**12 * 2**3:");
    #10 assign a = 16'h6C00; assign b = 16'h4800;
    #10 assign a = 16'h6FFF; assign b = 16'h4BFF;

    #10$fwrite(outfile,"\n2**13 * 2**2:");
    #10 assign a = 16'h7000; assign b = 16'h4400;
    #10 assign a = 16'h73FF; assign b = 16'h47FF;

    #10$fwrite(outfile,"\n2**14 * 2**1:");
    #10 assign a = 16'h7400; assign b = 16'h4000;
    #10 assign a = 16'h77FF; assign b = 16'h43FF;

    #10$fwrite(outfile,"\n2**15 * 2**0:");
    #10 assign a = 16'h7800; assign b = 16'h3C00;
    #10 assign a = 16'h7BFF; assign b = 16'h3FFF;

    #10$fwrite(outfile,"\n2**-24 * 2**9:");
    #10 assign a = 16'h0001; assign b = 16'h6000;
    #10 assign a = 16'h0001; assign b = 16'h63FF;

    #10$fwrite(outfile,"\n2**-23 * 2**8:");
    #10 assign a = 16'h0002; assign b = 16'h5C00;
    #10 assign a = 16'h0003; assign b = 16'h5FFF;

    #10$fwrite(outfile,"\n2**-22 * 2**7:");
    #10 assign a = 16'h0004; assign b = 16'h5800;
    #10 assign a = 16'h0007; assign b = 16'h5BFF;

    #10$fwrite(outfile,"\n2**-21 * 2**6:");
    #10 assign a = 16'h0008; assign b = 16'h5400;
    #10 assign a = 16'h000F; assign b = 16'h57FF;

    #10$fwrite(outfile,"\n2**-20 * 2**5:");
    #10 assign a = 16'h0010; assign b = 16'h5000;
    #10 assign a = 16'h001F; assign b = 16'h53FF;

    #10$fwrite(outfile,"\n2**-19 * 2**4:");
    #10 assign a = 16'h0020; assign b = 16'h4C00;
    #10 assign a = 16'h003F; assign b = 16'h4FFF;

    #10$fwrite(outfile,"\n2**-18 * 2**3:");
    #10 assign a = 16'h0040; assign b = 16'h4800;
    #10 assign a = 16'h007F; assign b = 16'h4BFF;

    #10$fwrite(outfile,"\n2**-17 * 2**2:");
    #10 assign a = 16'h0080; assign b = 16'h4400;
    #10 assign a = 16'h00FF; assign b = 16'h47FF;

    #10$fwrite(outfile,"\n2**-16 * 2**1:");
    #10 assign a = 16'h0100; assign b = 16'h4000;
    #10 assign a = 16'h01FF; assign b = 16'h43FF;

    #10$fwrite(outfile,"\n2**-15 * 2**0:");
    #10 assign a = 16'h0200; assign b = 16'h3C00;
    #10 assign a = 16'h03FF; assign b = 16'h3FFF;

    #10$fwrite(outfile,"\n2**-14 * 2**-1:");
    #10 assign a = 16'h0400; assign b = 16'h3800;
    #10 assign a = 16'h07FF; assign b = 16'h3BFF;

    #10$fwrite(outfile,"\n2**-13 * 2**-2:");
    #10 assign a = 16'h0800; assign b = 16'h3400;
    #10 assign a = 16'h0BFF; assign b = 16'h37FF;

    #10$fwrite(outfile,"\n2**-12 * 2**-3:");
    #10 assign a = 16'h0C00; assign b = 16'h3000;
    #10 assign a = 16'h0FFF; assign b = 16'h33FF;

    #10$fwrite(outfile,"\n2**-11 * 2**-4:");
    #10 assign a = 16'h1000; assign b = 16'h2C00;
    #10 assign a = 16'h13FF; assign b = 16'h2FFF;

    #10$fwrite(outfile,"\n2**-10 * 2**-5:");
    #10 assign a = 16'h1400; assign b = 16'h2800;
    #10 assign a = 16'h17FF; assign b = 16'h2BFF;

    #10$fwrite(outfile,"\n2**-9 * 2**-6:");
    #10 assign a = 16'h1800; assign b = 16'h2400;
    #10 assign a = 16'h1BFF; assign b = 16'h27FF;

    #10$fwrite(outfile,"\n2**-8 * 2**-7:");
    #10 assign a = 16'h1C00; assign b = 16'h2000;
    #10 assign a = 16'h1FFF; assign b = 16'h23FF;

    #10$fwrite(outfile,"\n2**-7 * 2**-8:");
    #10 assign a = 16'h2000; assign b = 16'h1C00;
    #10 assign a = 16'h23FF; assign b = 16'h1FFF;

    #10$fwrite(outfile,"\n2**-6 * 2**-9:");
    #10 assign a = 16'h2400; assign b = 16'h1800;
    #10 assign a = 16'h27FF; assign b = 16'h1BFF;

    #10$fwrite(outfile,"\n2**-5 * 2**-10:");
    #10 assign a = 16'h2800; assign b = 16'h1400;
    #10 assign a = 16'h2BFF; assign b = 16'h17FF;

    #10$fwrite(outfile,"\n2**-4 * 2**-11:");
    #10 assign a = 16'h2C00; assign b = 16'h1000;
    #10 assign a = 16'h2FFF; assign b = 16'h13FF;

    #10$fwrite(outfile,"\n2**-3 * 2**-12:");
    #10 assign a = 16'h3000; assign b = 16'h0C00;
    #10 assign a = 16'h33FF; assign b = 16'h0FFF;

    #10$fwrite(outfile,"\n2**-2 * 2**-13:");
    #10 assign a = 16'h3400; assign b = 16'h0800;
    #10 assign a = 16'h37FF; assign b = 16'h0BFF;

    #10$fwrite(outfile,"\n2**-1 * 2**-14:");
    #10 assign a = 16'h3800; assign b = 16'h0400;
    #10 assign a = 16'h3BFF; assign b = 16'h07FF;

    #10$fwrite(outfile,"\n2**0 * 2**-15:");
    #10 assign a = 16'h3C00; assign b = 16'h0200;
    #10 assign a = 16'h3FFF; assign b = 16'h03FF;

    #10$fwrite(outfile,"\n2**1 * 2**-16:");
    #10 assign a = 16'h4000; assign b = 16'h0100;
    #10 assign a = 16'h43FF; assign b = 16'h01FF;

    #10$fwrite(outfile,"\n2**2 * 2**-17:");
    #10 assign a = 16'h4400; assign b = 16'h0080;
    #10 assign a = 16'h47FF; assign b = 16'h00FF;

    #10$fwrite(outfile,"\n2**3 * 2**-18:");
    #10 assign a = 16'h4800; assign b = 16'h0040;
    #10 assign a = 16'h4BFF; assign b = 16'h007F;

    #10$fwrite(outfile,"\n2**4 * 2**-19:");
    #10 assign a = 16'h4C00; assign b = 16'h0020;
    #10 assign a = 16'h4FFF; assign b = 16'h003F;

    #10$fwrite(outfile,"\n2**5 * 2**-20:");
    #10 assign a = 16'h5000; assign b = 16'h0010;
    #10 assign a = 16'h53FF; assign b = 16'h001F;

    #10$fwrite(outfile,"\n2**6 * 2**-21:");
    #10 assign a = 16'h5400; assign b = 16'h0008;
    #10 assign a = 16'h57FF; assign b = 16'h000F;

    #10$fwrite(outfile,"\n2**7 * 2**-22:");
    #10 assign a = 16'h5800; assign b = 16'h0004;
    #10 assign a = 16'h5BFF; assign b = 16'h0007;

    #10$fwrite(outfile,"\n2**8 * 2**-23:");
    #10 assign a = 16'h5C00; assign b = 16'h0002;
    #10 assign a = 16'h5FFF; assign b = 16'h0003;

    #10$fwrite(outfile,"\n2**9 * 2**-24:");
    #10 assign a = 16'h6000; assign b = 16'h0001;
    #10 assign a = 16'h63FF; assign b = 16'h0001;

    #10$fwrite(outfile,"\n2**-24 * 2**-1:");
    #10 assign a = 16'h0001; assign b = 16'h3800;
    #10 assign a = 16'h0001; assign b = 16'h3BFF;

    #10$fwrite(outfile,"\n2**-23 * 2**-2:");
    #10 assign a = 16'h0002; assign b = 16'h3400;
    #10 assign a = 16'h0003; assign b = 16'h37FF;

    #10$fwrite(outfile,"\n2**-22 * 2**-3:");
    #10 assign a = 16'h0004; assign b = 16'h3000;
    #10 assign a = 16'h0007; assign b = 16'h33FF;

    #10$fwrite(outfile,"\n2**-21 * 2**-4:");
    #10 assign a = 16'h0008; assign b = 16'h2C00;
    #10 assign a = 16'h000F; assign b = 16'h2FFF;

    #10$fwrite(outfile,"\n2**-20 * 2**-5:");
    #10 assign a = 16'h0010; assign b = 16'h2800;
    #10 assign a = 16'h001F; assign b = 16'h2BFF;

    #10$fwrite(outfile,"\n2**-19 * 2**-6:");
    #10 assign a = 16'h0020; assign b = 16'h2400;
    #10 assign a = 16'h003F; assign b = 16'h27FF;

    #10$fwrite(outfile,"\n2**-18 * 2**-7:");
    #10 assign a = 16'h0040; assign b = 16'h2000;
    #10 assign a = 16'h007F; assign b = 16'h23FF;

    #10$fwrite(outfile,"\n2**-17 * 2**-8:");
    #10 assign a = 16'h0080; assign b = 16'h1C00;
    #10 assign a = 16'h00FF; assign b = 16'h1FFF;

    #10$fwrite(outfile,"\n2**-16 * 2**-9:");
    #10 assign a = 16'h0100; assign b = 16'h1800;
    #10 assign a = 16'h01FF; assign b = 16'h1BFF;

    #10$fwrite(outfile,"\n2**-15 * 2**-10:");
    #10 assign a = 16'h0200; assign b = 16'h1400;
    #10 assign a = 16'h03FF; assign b = 16'h17FF;

    #10$fwrite(outfile,"\n2**-14 * 2**-11:");
    #10 assign a = 16'h0400; assign b = 16'h1000;
    #10 assign a = 16'h07FF; assign b = 16'h13FF;

    #10$fwrite(outfile,"\n2**-13 * 2**-12:");
    #10 assign a = 16'h0800; assign b = 16'h0C00;
    #10 assign a = 16'h0BFF; assign b = 16'h0FFF;

    #10 $fwrite(outfile,"\n2**-12 * 2**-13:");
    #10 assign a = 16'h0C00; assign b = 16'h0800;
    #10 assign a = 16'h0FFF; assign b = 16'h0BFF;

    #10 $fwrite(outfile,"\n2**-11 * 2**-14:");
    #10 assign a = 16'h1000; assign b = 16'h0400;
    #10 assign a = 16'h13FF; assign b = 16'h07FF;

    #10 $fwrite(outfile,"\n2**-10 * 2**-15:");
    #10 assign a = 16'h1400; assign b = 16'h0200;
    #10 assign a = 16'h17FF; assign b = 16'h03FF;

    #10 $fwrite(outfile,"\n2**-9 * 2**-16:");
    #10 assign a = 16'h1800; assign b = 16'h0100;
    #10 assign a = 16'h1BFF; assign b = 16'h01FF;

    #10 $fwrite(outfile,"\n2**-8 * 2**-17:");
    #10 assign a = 16'h1C00; assign b = 16'h0080;
    #10 assign a = 16'h1FFF; assign b = 16'h00FF;

    #10 $fwrite(outfile,"\n2**-7 * 2**-18:");
    #10 assign a = 16'h2000; assign b = 16'h0040;
    #10 assign a = 16'h23FF; assign b = 16'h007F;

    #10 $fwrite(outfile,"\n2**-6 * 2**-19:");
    #10 assign a = 16'h2400; assign b = 16'h0020;
    #10 assign a = 16'h27FF; assign b = 16'h003F;

    #10 $fwrite(outfile,"\n2**-5 * 2**-20:");
    #10 assign a = 16'h2800; assign b = 16'h0010;
    #10 assign a = 16'h2BFF; assign b = 16'h001F;

    #10 $fwrite(outfile,"\n2**-4 * 2**-21:");
    #10 assign a = 16'h2C00; assign b = 16'h0008;
    #10 assign a = 16'h2FFF; assign b = 16'h000F;

    #10 $fwrite(outfile,"\n2**-3 * 2**-22:");
    #10 assign a = 16'h3000; assign b = 16'h0004;
    #10 assign a = 16'h33FF; assign b = 16'h0007;

    #10 $fwrite(outfile,"\n2**-2 * 2**-23:");
    #10 assign a = 16'h3400; assign b = 16'h0002;
    #10 assign a = 16'h37FF; assign b = 16'h0003;

    #10 $fwrite(outfile,"\n2**-1 * 2**-24:");
    #10 assign a = 16'h3800; assign b = 16'h0001;
    #10 assign a = 16'h3BFF; assign b = 16'h0001;

    #10$fwrite(outfile,"\n20 * 20:"); // 1.0100000000 * 2**4 or 0x4D00
    #10 assign a = 16'h4D00; assign b = 16'h4D00; // 1.1001000000 x 2**8 or 0x5E40

    /*
    #10 $fwrite(outfile,"\n1. 16.894 * 13.351 = 225.552 :");
    #10 assign a = 16'h4C39; assign b = 16'h4AAC;
#10 $fwrite(outfile,"\n2. 46.894 * 43.243 = 2027.837 :");
#10 assign a = 16'h51DC; assign b = 16'h5167;
#10 $fwrite(outfile,"\n3. 46.12 * 19.196 = 885.32 :");
#10 assign a = 16'h51C3; assign b = 16'h4CCC;
#10 $fwrite(outfile,"\n4. 10.71 * 42.392 = 454.018 :");
#10 assign a = 16'h495A; assign b = 16'h514C;
#10 $fwrite(outfile,"\n5. 14.13 * 31.302 = 442.297 :");
#10 assign a = 16'h4B10; assign b = 16'h4FD3;
#10 $fwrite(outfile,"\n6. 6.071 * 13.011 = 78.99 :");
#10 assign a = 16'h4612; assign b = 16'h4A81;
#10 $fwrite(outfile,"\n7. 10.517 * 46.107 = 484.907 :");
#10 assign a = 16'h4942; assign b = 16'h51C3;
#10 $fwrite(outfile,"\n8. 3.145 * 11.248 = 35.375 :");
#10 assign a = 16'h424A; assign b = 16'h499F;
#10 $fwrite(outfile,"\n9. 28.561 * 30.431 = 869.14 :");
#10 assign a = 16'h4F23; assign b = 16'h4F9B;
#10 $fwrite(outfile,"\n10. 7.647 * 29.071 = 222.306 :");
#10 assign a = 16'h47A5; assign b = 16'h4F44;
#10 $fwrite(outfile,"\n11. 44.279 * 41.843 = 1852.766 :");
#10 assign a = 16'h5188; assign b = 16'h513A;
#10 $fwrite(outfile,"\n12. 44.595 * 27.596 = 1230.644 :");
#10 assign a = 16'h5193; assign b = 16'h4EE6;
#10 $fwrite(outfile,"\n13. 29.834 * 13.023 = 388.528 :");
#10 assign a = 16'h4F75; assign b = 16'h4A82;
#10 $fwrite(outfile,"\n14. 26.307 * 18.521 = 487.232 :");
#10 assign a = 16'h4E93; assign b = 16'h4CA1;
#10 $fwrite(outfile,"\n15. 30.901 * 46.582 = 1439.43 :");
#10 assign a = 16'h4FB9; assign b = 16'h51D2;
#10 $fwrite(outfile,"\n16. 40.96 * 6.39 = 261.734 :");
#10 assign a = 16'h511E; assign b = 16'h4663;
#10 $fwrite(outfile,"\n17. 30.036 * 31.762 = 954.003 :");
#10 assign a = 16'h4F82; assign b = 16'h4FF0;
#10 $fwrite(outfile,"\n18. 25.131 * 26.871 = 675.295 :");
#10 assign a = 16'h4E48; assign b = 16'h4EB7;
#10 $fwrite(outfile,"\n19. 45.054 * 33.35 = 1502.551 :");
#10 assign a = 16'h51A1; assign b = 16'h502B;
#10 $fwrite(outfile,"\n20. 48.792 * 39.055 = 1905.572 :");
#10 assign a = 16'h5219; assign b = 16'h50E1;
#10 $fwrite(outfile,"\n21. 21.022 * 39.46 = 829.528 :");
#10 assign a = 16'h4D41; assign b = 16'h50EE;
#10 $fwrite(outfile,"\n22. 14.254 * 5.66 = 80.678 :");
#10 assign a = 16'h4B20; assign b = 16'h45A8;
#10 $fwrite(outfile,"\n23. 24.163 * 30.437 = 735.449 :");
#10 assign a = 16'h4E0A; assign b = 16'h4F9B;
#10 $fwrite(outfile,"\n24. 13.615 * 7.385 = 100.547 :");
#10 assign a = 16'h4ACE; assign b = 16'h4762;
#10 $fwrite(outfile,"\n25. 45.168 * 32.34 = 1460.733 :");
#10 assign a = 16'h51A5; assign b = 16'h500A;
#10 $fwrite(outfile,"\n26. 27.767 * 35.738 = 992.337 :");
#10 assign a = 16'h4EF1; assign b = 16'h5077;
#10 $fwrite(outfile,"\n27. 39.555 * 17.853 = 706.175 :");
#10 assign a = 16'h50F1; assign b = 16'h4C76;
#10 $fwrite(outfile,"\n28. 8.45 * 40.218 = 339.842 :");
#10 assign a = 16'h4839; assign b = 16'h5106;
#10 $fwrite(outfile,"\n29. 30.241 * 35.673 = 1078.787 :");
#10 assign a = 16'h4F8F; assign b = 16'h5075;
#10 $fwrite(outfile,"\n30. 29.205 * 4.062 = 118.631 :");
#10 assign a = 16'h4F4D; assign b = 16'h440F;
#10 $fwrite(outfile,"\n31. 26.139 * 12.51 = 326.999 :");
#10 assign a = 16'h4E88; assign b = 16'h4A41;
#10 $fwrite(outfile,"\n32. 48.675 * 41.144 = 2002.684 :");
#10 assign a = 16'h5215; assign b = 16'h5124;
#10 $fwrite(outfile,"\n33. 18.451 * 9.78 = 180.451 :");
#10 assign a = 16'h4C9C; assign b = 16'h48E3;
#10 $fwrite(outfile,"\n34. 28.846 * 9.086 = 262.095 :");
#10 assign a = 16'h4F36; assign b = 16'h488B;
#10 $fwrite(outfile,"\n35. 14.291 * 30.192 = 431.474 :");
#10 assign a = 16'h4B25; assign b = 16'h4F8C;
#10 $fwrite(outfile,"\n36. 17.93 * 27.125 = 486.351 :");
#10 assign a = 16'h4C7B; assign b = 16'h4EC8;
#10 $fwrite(outfile,"\n37. 11.327 * 26.832 = 303.926 :");
#10 assign a = 16'h49A9; assign b = 16'h4EB5;
#10 $fwrite(outfile,"\n38. 1.404 * 32.87 = 46.149 :");
#10 assign a = 16'h3D9D; assign b = 16'h501B;
#10 $fwrite(outfile,"\n39. 11.671 * 38.683 = 451.469 :");
#10 assign a = 16'h49D5; assign b = 16'h50D5;
#10 $fwrite(outfile,"\n40. 3.603 * 42.182 = 151.982 :");
#10 assign a = 16'h4334; assign b = 16'h5145;
#10 $fwrite(outfile,"\n41. 5.474 * 23.044 = 126.143 :");
#10 assign a = 16'h4579; assign b = 16'h4DC2;
#10 $fwrite(outfile,"\n42. 8.151 * 30.294 = 246.926 :");
#10 assign a = 16'h4813; assign b = 16'h4F92;
#10 $fwrite(outfile,"\n43. 1.43 * 1.183 = 1.692 :");
#10 assign a = 16'h3DB8; assign b = 16'h3CBB;
#10 $fwrite(outfile,"\n44. 16.391 * 39.832 = 652.886 :");
#10 assign a = 16'h4C19; assign b = 16'h50FA;
#10 $fwrite(outfile,"\n45. 22.863 * 11.817 = 270.172 :");
#10 assign a = 16'h4DB7; assign b = 16'h49E8;
#10 $fwrite(outfile,"\n46. 31.805 * 29.311 = 932.236 :");
#10 assign a = 16'h4FF3; assign b = 16'h4F53;
#10 $fwrite(outfile,"\n47. 23.281 * 36.584 = 851.712 :");
#10 assign a = 16'h4DD1; assign b = 16'h5092;
#10 $fwrite(outfile,"\n48. 33.722 * 42.53 = 1434.197 :");
#10 assign a = 16'h5037; assign b = 16'h5150;
#10 $fwrite(outfile,"\n49. 2.982 * 27.596 = 82.291 :");
#10 assign a = 16'h41F6; assign b = 16'h4EE6;
#10 $fwrite(outfile,"\n50. 49.527 * 4.301 = 213.016 :");
#10 assign a = 16'h5230; assign b = 16'h444D;
#10 $fwrite(outfile,"\n51. 9.06 * 6.292 = 57.006 :");
#10 assign a = 16'h4887; assign b = 16'h464A;
#10 $fwrite(outfile,"\n52. 6.825 * 5.165 = 35.251 :");
#10 assign a = 16'h46D3; assign b = 16'h452A;
#10 $fwrite(outfile,"\n53. 24.419 * 18.594 = 454.047 :");
#10 assign a = 16'h4E1A; assign b = 16'h4CA6;
#10 $fwrite(outfile,"\n54. 26.117 * 5.175 = 135.155 :");
#10 assign a = 16'h4E87; assign b = 16'h452C;
#10 $fwrite(outfile,"\n55. 43.164 * 29.447 = 1271.05 :");
#10 assign a = 16'h5165; assign b = 16'h4F5C;
#10 $fwrite(outfile,"\n56. 27.214 * 5.716 = 155.555 :");
#10 assign a = 16'h4ECD; assign b = 16'h45B7;
#10 $fwrite(outfile,"\n57. 43.545 * 35.573 = 1549.026 :");
#10 assign a = 16'h5171; assign b = 16'h5072;
#10 $fwrite(outfile,"\n58. 37.436 * 42.766 = 1600.988 :");
#10 assign a = 16'h50AD; assign b = 16'h5158;
#10 $fwrite(outfile,"\n59. 15.013 * 29.613 = 444.58 :");
#10 assign a = 16'h4B81; assign b = 16'h4F67;
#10 $fwrite(outfile,"\n60. 35.844 * 14.633 = 524.505 :");
#10 assign a = 16'h507B; assign b = 16'h4B51;
#10 $fwrite(outfile,"\n61. 28.779 * 32.124 = 924.497 :");
#10 assign a = 16'h4F31; assign b = 16'h5003;
#10 $fwrite(outfile,"\n62. 49.516 * 4.775 = 236.439 :");
#10 assign a = 16'h5230; assign b = 16'h44C6;
#10 $fwrite(outfile,"\n63. 22.28 * 28.024 = 624.375 :");
#10 assign a = 16'h4D91; assign b = 16'h4F01;
#10 $fwrite(outfile,"\n64. 1.602 * 45.666 = 73.157 :");
#10 assign a = 16'h3E68; assign b = 16'h51B5;
#10 $fwrite(outfile,"\n65. 40.935 * 15.053 = 616.195 :");
#10 assign a = 16'h511D; assign b = 16'h4B86;
#10 $fwrite(outfile,"\n66. 23.793 * 16.738 = 398.247 :");
#10 assign a = 16'h4DF2; assign b = 16'h4C2F;
#10 $fwrite(outfile,"\n67. 14.433 * 34.638 = 499.93 :");
#10 assign a = 16'h4B37; assign b = 16'h5054;
#10 $fwrite(outfile,"\n68. 39.955 * 19.542 = 780.801 :");
#10 assign a = 16'h50FE; assign b = 16'h4CE2;
#10 $fwrite(outfile,"\n69. 17.808 * 44.188 = 786.9 :");
#10 assign a = 16'h4C73; assign b = 16'h5186;
#10 $fwrite(outfile,"\n70. 2.981 * 3.249 = 9.685 :");
#10 assign a = 16'h41F6; assign b = 16'h427F;
#10 $fwrite(outfile,"\n71. 31.942 * 48.916 = 1562.475 :");
#10 assign a = 16'h4FFC; assign b = 16'h521D;
#10 $fwrite(outfile,"\n72. 7.207 * 15.465 = 111.456 :");
#10 assign a = 16'h4734; assign b = 16'h4BBB;
#10 $fwrite(outfile,"\n73. 42.047 * 12.21 = 513.394 :");
#10 assign a = 16'h5141; assign b = 16'h4A1A;
#10 $fwrite(outfile,"\n74. 46.276 * 49.924 = 2310.283 :");
#10 assign a = 16'h51C8; assign b = 16'h523D;
#10 $fwrite(outfile,"\n75. 47.883 * 35.313 = 1690.892 :");
#10 assign a = 16'h51FC; assign b = 16'h506A;
#10 $fwrite(outfile,"\n76. 24.687 * 25.873 = 638.727 :");
#10 assign a = 16'h4E2B; assign b = 16'h4E77;
#10 $fwrite(outfile,"\n77. 4.36 * 8.01 = 34.924 :");
#10 assign a = 16'h445C; assign b = 16'h4801;
#10 $fwrite(outfile,"\n78. 16.458 * 1.15 = 18.927 :");
#10 assign a = 16'h4C1D; assign b = 16'h3C99;
#10 $fwrite(outfile,"\n79. 12.609 * 49.206 = 620.438 :");
#10 assign a = 16'h4A4D; assign b = 16'h5226;
#10 $fwrite(outfile,"\n80. 32.847 * 13.719 = 450.628 :");
#10 assign a = 16'h501B; assign b = 16'h4ADC;
#10 $fwrite(outfile,"\n81. 15.212 * 46.638 = 709.457 :");
#10 assign a = 16'h4B9B; assign b = 16'h51D4;
#10 $fwrite(outfile,"\n82. 40.121 * 28.776 = 1154.522 :");
#10 assign a = 16'h5103; assign b = 16'h4F31;
#10 $fwrite(outfile,"\n83. 9.586 * 10.476 = 100.423 :");
#10 assign a = 16'h48CB; assign b = 16'h493C;
#10 $fwrite(outfile,"\n84. 39.796 * 1.163 = 46.283 :");
#10 assign a = 16'h50F9; assign b = 16'h3CA6;
#10 $fwrite(outfile,"\n85. 19.914 * 16.27 = 324.001 :");
#10 assign a = 16'h4CFA; assign b = 16'h4C11;
#10 $fwrite(outfile,"\n86. 17.761 * 17.075 = 303.269 :");
#10 assign a = 16'h4C70; assign b = 16'h4C44;
#10 $fwrite(outfile,"\n87. 11.003 * 6.189 = 68.098 :");
#10 assign a = 16'h4980; assign b = 16'h4630;
#10 $fwrite(outfile,"\n88. 10.952 * 18.507 = 202.689 :");
#10 assign a = 16'h4979; assign b = 16'h4CA0;
#10 $fwrite(outfile,"\n89. 4.186 * 17.03 = 71.288 :");
#10 assign a = 16'h442F; assign b = 16'h4C41;
#10 $fwrite(outfile,"\n90. 46.568 * 39.154 = 1823.323 :");
#10 assign a = 16'h51D2; assign b = 16'h50E4;
#10 $fwrite(outfile,"\n91. 43.174 * 47.223 = 2038.806 :");
#10 assign a = 16'h5165; assign b = 16'h51E7;
#10 $fwrite(outfile,"\n92. 29.858 * 18.55 = 553.866 :");
#10 assign a = 16'h4F76; assign b = 16'h4CA3;
#10 $fwrite(outfile,"\n93. 48.434 * 10.621 = 514.418 :");
#10 assign a = 16'h520D; assign b = 16'h494F;
#10 $fwrite(outfile,"\n94. 40.819 * 16.919 = 690.617 :");
#10 assign a = 16'h511A; assign b = 16'h4C3A;
#10 $fwrite(outfile,"\n95. 29.38 * 44.281 = 1300.976 :");
#10 assign a = 16'h4F58; assign b = 16'h5188;
#10 $fwrite(outfile,"\n96. 22.819 * 31.596 = 720.989 :");
#10 assign a = 16'h4DB4; assign b = 16'h4FE6;
#10 $fwrite(outfile,"\n97. 45.234 * 15.476 = 700.041 :");
#10 assign a = 16'h51A7; assign b = 16'h4BBC;
#10 $fwrite(outfile,"\n98. 12.145 * 36.68 = 445.479 :");
#10 assign a = 16'h4A12; assign b = 16'h5095;
#10 $fwrite(outfile,"\n99. 2.841 * 22.559 = 64.09 :");
#10 assign a = 16'h41AE; assign b = 16'h4DA3;
#10 $fwrite(outfile,"\n100. 45.967 * 8.975 = 412.554 :");
#10 assign a = 16'h51BE; assign b = 16'h487C;
*/

// 100 test cases with arbitrary normal values as operands

#10 $fwrite(outfile,"\n1. 40.658 * 11.47 = 466.34726 (16'h5F49):");
#10 assign a = 16'h5115; assign b = 16'h49BC;
#10 $fwrite(outfile,"\n2. 22.009 * 7.965 = 175.30168 (16'h597A):");
#10 assign a = 16'h4D81; assign b = 16'h47F7;
#10 $fwrite(outfile,"\n3. 25.639 * 38.648 = 990.89607 (16'h63BE):");
#10 assign a = 16'h4E69; assign b = 16'h50D5;
#10 $fwrite(outfile,"\n4. 45.202 * 14.318 = 647.20224 (16'h610E):");
#10 assign a = 16'h51A6; assign b = 16'h4B29;
#10 $fwrite(outfile,"\n5. 26.53 * 23.494 = 623.29582 (16'h60DF):");
#10 assign a = 16'h4EA2; assign b = 16'h4DE0;
#10 $fwrite(outfile,"\n6. 13.415 * 22.124 = 296.79346 (16'h5CA3):");
#10 assign a = 16'h4AB5; assign b = 16'h4D88;
#10 $fwrite(outfile,"\n7. 0.387 * 13.894 = 5.37698 (16'h4561):");
#10 assign a = 16'h3631; assign b = 16'h4AF2;
#10 $fwrite(outfile,"\n8. 21.0 * 34.439 = 723.219 (16'h61A6):");
#10 assign a = 16'h4D40; assign b = 16'h504E;
#10 $fwrite(outfile,"\n9. 48.212 * 8.349 = 402.52199 (16'h5E4A):");
#10 assign a = 16'h5207; assign b = 16'h482D;
#10 $fwrite(outfile,"\n10. 38.673 * 4.462 = 172.55893 (16'h5964):");
#10 assign a = 16'h50D6; assign b = 16'h4476;
#10 $fwrite(outfile,"\n11. 23.168 * 10.118 = 234.41382 (16'h5B53):");
#10 assign a = 16'h4DCB; assign b = 16'h490F;
#10 $fwrite(outfile,"\n12. 11.786 * 6.758 = 79.64979 (16'h54FA):");
#10 assign a = 16'h49E5; assign b = 16'h46C2;
#10 $fwrite(outfile,"\n13. 22.351 * 5.783 = 129.25583 (16'h580A):");
#10 assign a = 16'h4D96; assign b = 16'h45C8;
#10 $fwrite(outfile,"\n14. 48.242 * 5.857 = 282.55339 (16'h5C6A):");
#10 assign a = 16'h5208; assign b = 16'h45DB;
#10 $fwrite(outfile,"\n15. 47.318 * 2.016 = 95.39309 (16'h55F6):");
#10 assign a = 16'h51EA; assign b = 16'h4008;
#10 $fwrite(outfile,"\n16. 21.242 * 20.89 = 443.74538 (16'h5EEF):");
#10 assign a = 16'h4D4F; assign b = 16'h4D39;
#10 $fwrite(outfile,"\n17. 35.486 * 1.326 = 47.05444 (16'h51E2):");
#10 assign a = 16'h5070; assign b = 16'h3D4E;
#10 $fwrite(outfile,"\n18. 2.791 * 19.236 = 53.68768 (16'h52B6):");
#10 assign a = 16'h4195; assign b = 16'h4CCF;
#10 $fwrite(outfile,"\n19. 14.836 * 20.431 = 303.11432 (16'h5CBC):");
#10 assign a = 16'h4B6B; assign b = 16'h4D1C;
#10 $fwrite(outfile,"\n20. 1.711 * 27.589 = 47.20478 (16'h51E7):");
#10 assign a = 16'h3ED8; assign b = 16'h4EE6;
#10 $fwrite(outfile,"\n21. 22.535 * 18.499 = 416.87496 (16'h5E83):");
#10 assign a = 16'h4DA2; assign b = 16'h4CA0;
#10 $fwrite(outfile,"\n22. 35.961 * 49.362 = 1775.10688 (16'h66EF):");
#10 assign a = 16'h507F; assign b = 16'h522C;
#10 $fwrite(outfile,"\n23. 44.313 * 24.84 = 1100.73492 (16'h644D):");
#10 assign a = 16'h518A; assign b = 16'h4E36;
#10 $fwrite(outfile,"\n24. 3.997 * 46.385 = 185.40084 (16'h59CB):");
#10 assign a = 16'h43FE; assign b = 16'h51CC;
#10 $fwrite(outfile,"\n25. 31.739 * 18.221 = 578.31632 (16'h6085):");
#10 assign a = 16'h4FEF; assign b = 16'h4C8E;
#10 $fwrite(outfile,"\n26. 14.302 * 0.796 = 11.38439 (16'h49B1):");
#10 assign a = 16'h4B27; assign b = 16'h3A5E;
#10 $fwrite(outfile,"\n27. 10.313 * 15.058 = 155.29315 (16'h58DA):");
#10 assign a = 16'h4928; assign b = 16'h4B87;
#10 $fwrite(outfile,"\n28. 31.155 * 25.975 = 809.25113 (16'h6253):");
#10 assign a = 16'h4FCA; assign b = 16'h4E7E;
#10 $fwrite(outfile,"\n29. 22.446 * 5.262 = 118.11085 (16'h5762):");
#10 assign a = 16'h4D9D; assign b = 16'h4543;
#10 $fwrite(outfile,"\n30. 2.38 * 4.4 = 10.472 (16'h493C):");
#10 assign a = 16'h40C3; assign b = 16'h4466;
#10 $fwrite(outfile,"\n31. 32.966 * 1.662 = 54.78949 (16'h52D9):");
#10 assign a = 16'h501F; assign b = 16'h3EA6;
#10 $fwrite(outfile,"\n32. 9.937 * 43.657 = 433.81961 (16'h5EC7):");
#10 assign a = 16'h48F8; assign b = 16'h5175;
#10 $fwrite(outfile,"\n33. 48.188 * 31.89 = 1536.71532 (16'h6601):");
#10 assign a = 16'h5206; assign b = 16'h4FF9;
#10 $fwrite(outfile,"\n34. 26.464 * 4.624 = 122.36954 (16'h57A6):");
#10 assign a = 16'h4E9E; assign b = 16'h44A0;
#10 $fwrite(outfile,"\n35. 46.056 * 4.373 = 201.40289 (16'h5A4B):");
#10 assign a = 16'h51C2; assign b = 16'h445F;
#10 $fwrite(outfile,"\n36. 29.81 * 44.531 = 1327.46911 (16'h652F):");
#10 assign a = 16'h4F74; assign b = 16'h5191;
#10 $fwrite(outfile,"\n37. 1.048 * 34.848 = 36.5207 (16'h5091):");
#10 assign a = 16'h3C31; assign b = 16'h505B;
#10 $fwrite(outfile,"\n38. 1.685 * 36.024 = 60.70044 (16'h5396):");
#10 assign a = 16'h3EBD; assign b = 16'h5081;
#10 $fwrite(outfile,"\n39. 16.189 * 9.141 = 147.98365 (16'h58A0):");
#10 assign a = 16'h4C0C; assign b = 16'h4892;
#10 $fwrite(outfile,"\n40. 21.254 * 25.417 = 540.21292 (16'h6038):");
#10 assign a = 16'h4D50; assign b = 16'h4E5B;
#10 $fwrite(outfile,"\n41. 29.047 * 46.458 = 1349.46553 (16'h6545):");
#10 assign a = 16'h4F43; assign b = 16'h51CF;
#10 $fwrite(outfile,"\n42. 20.02 * 2.266 = 45.36532 (16'h51AC):");
#10 assign a = 16'h4D01; assign b = 16'h4088;
#10 $fwrite(outfile,"\n43. 18.531 * 43.361 = 803.52269 (16'h6247):");
#10 assign a = 16'h4CA2; assign b = 16'h516C;
#10 $fwrite(outfile,"\n44. 12.005 * 4.49 = 53.90245 (16'h52BD):");
#10 assign a = 16'h4A01; assign b = 16'h447D;
#10 $fwrite(outfile,"\n45. 27.669 * 10.238 = 283.27522 (16'h5C6D):");
#10 assign a = 16'h4EEB; assign b = 16'h491E;
#10 $fwrite(outfile,"\n46. 37.839 * 17.542 = 663.77174 (16'h6130):");
#10 assign a = 16'h50BB; assign b = 16'h4C63;
#10 $fwrite(outfile,"\n47. 40.55 * 4.781 = 193.86955 (16'h5A0F):");
#10 assign a = 16'h5112; assign b = 16'h44C8;
#10 $fwrite(outfile,"\n48. 29.453 * 7.917 = 233.1794 (16'h5B49):");
#10 assign a = 16'h4F5D; assign b = 16'h47EB;
#10 $fwrite(outfile,"\n49. 23.757 * 0.297 = 7.05583 (16'h470E):");
#10 assign a = 16'h4DF0; assign b = 16'h34C1;
#10 $fwrite(outfile,"\n50. 4.65 * 35.326 = 164.2659 (16'h5922):");
#10 assign a = 16'h44A6; assign b = 16'h506A;
#10 $fwrite(outfile,"\n51. 49.958 * 18.085 = 903.49043 (16'h630F):");
#10 assign a = 16'h523F; assign b = 16'h4C85;
#10 $fwrite(outfile,"\n52. 31.896 * 5.869 = 187.19762 (16'h59DA):");
#10 assign a = 16'h4FF9; assign b = 16'h45DE;
#10 $fwrite(outfile,"\n53. 46.237 * 37.283 = 1723.85407 (16'h66BC):");
#10 assign a = 16'h51C8; assign b = 16'h50A9;
#10 $fwrite(outfile,"\n54. 8.593 * 29.45 = 253.06385 (16'h5BE9):");
#10 assign a = 16'h484C; assign b = 16'h4F5D;
#10 $fwrite(outfile,"\n55. 16.831 * 25.074 = 422.02049 (16'h5E98):");
#10 assign a = 16'h4C35; assign b = 16'h4E45;
#10 $fwrite(outfile,"\n56. 45.041 * 9.46 = 426.08786 (16'h5EA8):");
#10 assign a = 16'h51A1; assign b = 16'h48BB;
#10 $fwrite(outfile,"\n57. 37.618 * 4.586 = 172.51615 (16'h5964):");
#10 assign a = 16'h50B4; assign b = 16'h4496;
#10 $fwrite(outfile,"\n58. 17.242 * 24.29 = 418.80818 (16'h5E8B):");
#10 assign a = 16'h4C4F; assign b = 16'h4E13;
#10 $fwrite(outfile,"\n59. 6.367 * 9.419 = 59.97077 (16'h537F):");
#10 assign a = 16'h465E; assign b = 16'h48B6;
#10 $fwrite(outfile,"\n60. 26.594 * 42.191 = 1122.02745 (16'h6462):");
#10 assign a = 16'h4EA6; assign b = 16'h5146;
#10 $fwrite(outfile,"\n61. 6.033 * 13.859 = 83.61135 (16'h553A):");
#10 assign a = 16'h4608; assign b = 16'h4AEE;
#10 $fwrite(outfile,"\n62. 45.083 * 33.266 = 1499.73108 (16'h65DC):");
#10 assign a = 16'h51A3; assign b = 16'h5029;
#10 $fwrite(outfile,"\n63. 34.88 * 47.346 = 1651.42848 (16'h6673):");
#10 assign a = 16'h505C; assign b = 16'h51EB;
#10 $fwrite(outfile,"\n64. 11.39 * 33.538 = 381.99782 (16'h5DF8):");
#10 assign a = 16'h49B2; assign b = 16'h5031;
#10 $fwrite(outfile,"\n65. 44.36 * 45.005 = 1996.4218 (16'h67CC):");
#10 assign a = 16'h518C; assign b = 16'h51A0;
#10 $fwrite(outfile,"\n66. 49.611 * 41.685 = 2068.03453 (16'h680A):");
#10 assign a = 16'h5234; assign b = 16'h5136;
#10 $fwrite(outfile,"\n67. 29.223 * 41.644 = 1216.96261 (16'h64C1):");
#10 assign a = 16'h4F4E; assign b = 16'h5135;
#10 $fwrite(outfile,"\n68. 28.83 * 36.149 = 1042.17567 (16'h6412):");
#10 assign a = 16'h4F35; assign b = 16'h5085;
#10 $fwrite(outfile,"\n69. 23.949 * 23.88 = 571.90212 (16'h6078):");
#10 assign a = 16'h4DFD; assign b = 16'h4DF8;
#10 $fwrite(outfile,"\n70. 43.218 * 47.202 = 2039.97604 (16'h67F8):");
#10 assign a = 16'h5167; assign b = 16'h51E6;
#10 $fwrite(outfile,"\n71. 5.515 * 25.634 = 141.37151 (16'h586B):");
#10 assign a = 16'h4584; assign b = 16'h4E69;
#10 $fwrite(outfile,"\n72. 49.905 * 27.887 = 1391.70074 (16'h6570):");
#10 assign a = 16'h523D; assign b = 16'h4EF9;
#10 $fwrite(outfile,"\n73. 28.51 * 33.372 = 951.43572 (16'h636F):");
#10 assign a = 16'h4F21; assign b = 16'h502C;
#10 $fwrite(outfile,"\n74. 23.248 * 19.26 = 447.75648 (16'h5EFF):");
#10 assign a = 16'h4DD0; assign b = 16'h4CD1;
#10 $fwrite(outfile,"\n75. 14.364 * 24.324 = 349.38994 (16'h5D76):");
#10 assign a = 16'h4B2F; assign b = 16'h4E15;
#10 $fwrite(outfile,"\n76. 47.162 * 6.198 = 292.31008 (16'h5C91):");
#10 assign a = 16'h51E5; assign b = 16'h4633;
#10 $fwrite(outfile,"\n77. 26.305 * 20.997 = 552.32609 (16'h6051):");
#10 assign a = 16'h4E94; assign b = 16'h4D40;
#10 $fwrite(outfile,"\n78. 21.79 * 40.11 = 873.9969 (16'h62D4):");
#10 assign a = 16'h4D73; assign b = 16'h5104;
#10 $fwrite(outfile,"\n79. 48.894 * 6.874 = 336.09736 (16'h5D40):");
#10 assign a = 16'h521D; assign b = 16'h46E0;
#10 $fwrite(outfile,"\n80. 2.782 * 6.651 = 18.50308 (16'h4CA0):");
#10 assign a = 16'h4190; assign b = 16'h46A7;
#10 $fwrite(outfile,"\n81. 12.17 * 18.349 = 223.30733 (16'h5AFA):");
#10 assign a = 16'h4A16; assign b = 16'h4C96;
#10 $fwrite(outfile,"\n82. 12.274 * 12.88 = 158.08912 (16'h58F1):");
#10 assign a = 16'h4A23; assign b = 16'h4A71;
#10 $fwrite(outfile,"\n83. 22.728 * 46.991 = 1068.01145 (16'h642C):");
#10 assign a = 16'h4DAF; assign b = 16'h51E0;
#10 $fwrite(outfile,"\n84. 43.238 * 5.258 = 227.3454 (16'h5B1B):");
#10 assign a = 16'h5168; assign b = 16'h4542;
#10 $fwrite(outfile,"\n85. 44.447 * 37.915 = 1685.208 (16'h6695):");
#10 assign a = 16'h518E; assign b = 16'h50BD;
#10 $fwrite(outfile,"\n86. 11.271 * 28.901 = 325.74317 (16'h5D17):");
#10 assign a = 16'h49A3; assign b = 16'h4F3A;
#10 $fwrite(outfile,"\n87. 21.823 * 18.231 = 397.85511 (16'h5E37):");
#10 assign a = 16'h4D75; assign b = 16'h4C8F;
#10 $fwrite(outfile,"\n88. 32.644 * 45.533 = 1486.37925 (16'h65CE):");
#10 assign a = 16'h5015; assign b = 16'h51B1;
#10 $fwrite(outfile,"\n89. 34.543 * 32.874 = 1135.56658 (16'h6470):");
#10 assign a = 16'h5051; assign b = 16'h501C;
#10 $fwrite(outfile,"\n90. 30.865 * 24.05 = 742.30325 (16'h61CD):");
#10 assign a = 16'h4FB7; assign b = 16'h4E03;
#10 $fwrite(outfile,"\n91. 21.488 * 8.083 = 173.6875 (16'h596E):");
#10 assign a = 16'h4D5F; assign b = 16'h480B;
#10 $fwrite(outfile,"\n92. 43.423 * 30.613 = 1329.3083 (16'h6531):");
#10 assign a = 16'h516E; assign b = 16'h4FA7;
#10 $fwrite(outfile,"\n93. 44.389 * 19.769 = 877.52614 (16'h62DB):");
#10 assign a = 16'h518C; assign b = 16'h4CF1;
#10 $fwrite(outfile,"\n94. 12.304 * 29.46 = 362.47584 (16'h5DAA):");
#10 assign a = 16'h4A27; assign b = 16'h4F5D;
#10 $fwrite(outfile,"\n95. 21.783 * 21.894 = 476.917 (16'h5F74):");
#10 assign a = 16'h4D72; assign b = 16'h4D79;
#10 $fwrite(outfile,"\n96. 29.826 * 24.097 = 718.71712 (16'h619D):");
#10 assign a = 16'h4F75; assign b = 16'h4E06;
#10 $fwrite(outfile,"\n97. 6.228 * 32.25 = 200.853 (16'h5A47):");
#10 assign a = 16'h463A; assign b = 16'h5008;
#10 $fwrite(outfile,"\n98. 35.495 * 23.022 = 817.16589 (16'h6262):");
#10 assign a = 16'h5070; assign b = 16'h4DC1;
#10 $fwrite(outfile,"\n99. 34.518 * 5.542 = 191.29876 (16'h59FA):");
#10 assign a = 16'h5051; assign b = 16'h458B;
#10 $fwrite(outfile,"\n100. 40.148 * 32.88 = 1320.06624 (16'h6528):");
#10 assign a = 16'h5105; assign b = 16'h501C;

// 100 testcases of arbitrary normal numbers with one negative operand
//
#10 $fwrite(outfile,"\n1. -11.194 * 14.364 = -160.79062 (16'hD906):");
#10 assign a = 16'hC999; assign b = 16'h4B2F;
#10 $fwrite(outfile,"\n2. 25.48 * -1.964 = -50.04272 (16'hD241):");
#10 assign a = 16'h4E5F; assign b = 16'hBFDB;
#10 $fwrite(outfile,"\n3. -30.045 * 38.758 = -1164.48411 (16'hE48C):");
#10 assign a = 16'hCF83; assign b = 16'h50D8;
#10 $fwrite(outfile,"\n4. -48.869 * 43.59 = -2130.19971 (16'hE829):");
#10 assign a = 16'hD21C; assign b = 16'h5173;
#10 $fwrite(outfile,"\n5. -28.125 * 9.865 = -277.45312 (16'hDC56):");
#10 assign a = 16'hCF08; assign b = 16'h48EF;
#10 $fwrite(outfile,"\n6. 10.094 * -10.481 = -105.79521 (16'hD69D):");
#10 assign a = 16'h490C; assign b = 16'hC93E;
#10 $fwrite(outfile,"\n7. -45.72 * 37.276 = -1704.25872 (16'hE6A8):");
#10 assign a = 16'hD1B7; assign b = 16'h50A9;
#10 $fwrite(outfile,"\n8. 0.85 * -19.948 = -16.9558 (16'hCC3D):");
#10 assign a = 16'h3ACD; assign b = 16'hCCFD;
#10 $fwrite(outfile,"\n9. -38.447 * 41.747 = -1605.04691 (16'hE645):");
#10 assign a = 16'hD0CE; assign b = 16'h5138;
#10 $fwrite(outfile,"\n10. 41.844 * -3.699 = -154.78096 (16'hD8D6):");
#10 assign a = 16'h513B; assign b = 16'hC366;
#10 $fwrite(outfile,"\n11. 46.515 * -16.212 = -754.10118 (16'hE1E4):");
#10 assign a = 16'h51D0; assign b = 16'hCC0E;
#10 $fwrite(outfile,"\n12. -28.028 * 21.434 = -600.75215 (16'hE0B2):");
#10 assign a = 16'hCF02; assign b = 16'h4D5C;
#10 $fwrite(outfile,"\n13. -5.367 * 45.646 = -244.98208 (16'hDBA8):");
#10 assign a = 16'hC55E; assign b = 16'h51B5;
#10 $fwrite(outfile,"\n14. -8.397 * 47.439 = -398.34528 (16'hDE39):");
#10 assign a = 16'hC833; assign b = 16'h51EE;
#10 $fwrite(outfile,"\n15. -10.129 * 43.755 = -443.19439 (16'hDEED):");
#10 assign a = 16'hC911; assign b = 16'h5178;
#10 $fwrite(outfile,"\n16. -44.0 * 29.511 = -1298.484 (16'hE512):");
#10 assign a = 16'hD180; assign b = 16'h4F61;
#10 $fwrite(outfile,"\n17. 44.706 * -37.067 = -1657.1173 (16'hE679):");
#10 assign a = 16'h5197; assign b = 16'hD0A2;
#10 $fwrite(outfile,"\n18. 41.773 * -5.971 = -249.42658 (16'hDBCB):");
#10 assign a = 16'h5139; assign b = 16'hC5F9;
#10 $fwrite(outfile,"\n19. -15.669 * 40.352 = -632.27549 (16'hE0F1):");
#10 assign a = 16'hCBD6; assign b = 16'h510B;
#10 $fwrite(outfile,"\n20. 18.757 * -32.51 = -609.79007 (16'hE0C4):");
#10 assign a = 16'h4CB0; assign b = 16'hD010;
#10 $fwrite(outfile,"\n21. -35.349 * 30.591 = -1081.36126 (16'hE439):");
#10 assign a = 16'hD06B; assign b = 16'h4FA6;
#10 $fwrite(outfile,"\n22. -29.896 * 43.093 = -1288.30833 (16'hE508):");
#10 assign a = 16'hCF79; assign b = 16'h5163;
#10 $fwrite(outfile,"\n23. 40.86 * -40.299 = -1646.61714 (16'hE66F):");
#10 assign a = 16'h511C; assign b = 16'hD10A;
#10 $fwrite(outfile,"\n24. 17.754 * -30.181 = -535.83347 (16'hE030):");
#10 assign a = 16'h4C70; assign b = 16'hCF8C;
#10 $fwrite(outfile,"\n25. -1.817 * 42.685 = -77.55864 (16'hD4D9):");
#10 assign a = 16'hBF45; assign b = 16'h5156;
#10 $fwrite(outfile,"\n26. 47.432 * -42.557 = -2018.56362 (16'hE7E3):");
#10 assign a = 16'h51EE; assign b = 16'hD152;
#10 $fwrite(outfile,"\n27. 1.602 * -11.511 = -18.44062 (16'hCC9C):");
#10 assign a = 16'h3E68; assign b = 16'hC9C1;
#10 $fwrite(outfile,"\n28. 3.317 * -11.832 = -39.24674 (16'hD0E8):");
#10 assign a = 16'h42A2; assign b = 16'hC9EA;
#10 $fwrite(outfile,"\n29. 41.904 * -20.999 = -879.9421 (16'hE2E0):");
#10 assign a = 16'h513D; assign b = 16'hCD40;
#10 $fwrite(outfile,"\n30. -22.9 * 3.424 = -78.4096 (16'hD4E7):");
#10 assign a = 16'hCDBA; assign b = 16'h42D9;
#10 $fwrite(outfile,"\n31. -16.104 * 6.615 = -106.52796 (16'hD6A8):");
#10 assign a = 16'hCC07; assign b = 16'h469D;
#10 $fwrite(outfile,"\n32. 2.041 * -44.354 = -90.52651 (16'hD5A8):");
#10 assign a = 16'h4015; assign b = 16'hD18B;
#10 $fwrite(outfile,"\n33. 40.856 * -27.373 = -1118.35129 (16'hE45E):");
#10 assign a = 16'h511B; assign b = 16'hCED8;
#10 $fwrite(outfile,"\n34. -37.865 * 28.366 = -1074.07859 (16'hE432):");
#10 assign a = 16'hD0BC; assign b = 16'h4F17;
#10 $fwrite(outfile,"\n35. -19.758 * 33.4 = -659.9172 (16'hE128):");
#10 assign a = 16'hCCF1; assign b = 16'h502D;
#10 $fwrite(outfile,"\n36. 48.843 * -35.756 = -1746.43031 (16'hE6D2):");
#10 assign a = 16'h521B; assign b = 16'hD078;
#10 $fwrite(outfile,"\n37. 22.185 * -44.824 = -994.42044 (16'hE3C5):");
#10 assign a = 16'h4D8C; assign b = 16'hD19A;
#10 $fwrite(outfile,"\n38. 36.961 * -10.215 = -377.55661 (16'hDDE6):");
#10 assign a = 16'h509F; assign b = 16'hC91C;
#10 $fwrite(outfile,"\n39. 31.709 * -45.573 = -1445.07426 (16'hE5A5):");
#10 assign a = 16'h4FED; assign b = 16'hD1B2;
#10 $fwrite(outfile,"\n40. -36.746 * 49.885 = -1833.07421 (16'hE729):");
#10 assign a = 16'hD098; assign b = 16'h523C;
#10 $fwrite(outfile,"\n41. -3.317 * 1.614 = -5.35364 (16'hC55B):");
#10 assign a = 16'hC2A2; assign b = 16'h3E75;
#10 $fwrite(outfile,"\n42. 20.46 * -32.84 = -671.9064 (16'hE140):");
#10 assign a = 16'h4D1D; assign b = 16'hD01B;
#10 $fwrite(outfile,"\n43. 8.916 * -22.522 = -200.80615 (16'hDA46):");
#10 assign a = 16'h4875; assign b = 16'hCDA1;
#10 $fwrite(outfile,"\n44. -30.725 * 18.049 = -554.55552 (16'hE055):");
#10 assign a = 16'hCFAE; assign b = 16'h4C83;
#10 $fwrite(outfile,"\n45. -30.852 * 47.48 = -1464.85296 (16'hE5B9):");
#10 assign a = 16'hCFB7; assign b = 16'h51EF;
#10 $fwrite(outfile,"\n46. 14.647 * -12.52 = -183.38044 (16'hD9BB):");
#10 assign a = 16'h4B53; assign b = 16'hCA43;
#10 $fwrite(outfile,"\n47. -31.848 * 46.375 = -1476.951 (16'hE5C5):");
#10 assign a = 16'hCFF6; assign b = 16'h51CC;
#10 $fwrite(outfile,"\n48. -37.315 * 4.967 = -185.3436 (16'hD9CB):");
#10 assign a = 16'hD0AA; assign b = 16'h44F8;
#10 $fwrite(outfile,"\n49. 26.919 * -3.174 = -85.44091 (16'hD557):");
#10 assign a = 16'h4EBB; assign b = 16'hC259;
#10 $fwrite(outfile,"\n50. 36.273 * -19.38 = -702.97074 (16'hE17E):");
#10 assign a = 16'h5089; assign b = 16'hCCD8;
#10 $fwrite(outfile,"\n51. -39.938 * 6.1 = -243.6218 (16'hDB9D):");
#10 assign a = 16'hD0FE; assign b = 16'h461A;
#10 $fwrite(outfile,"\n52. -49.59 * 1.032 = -51.17688 (16'hD266):");
#10 assign a = 16'hD233; assign b = 16'h3C21;
#10 $fwrite(outfile,"\n53. 39.467 * -39.929 = -1575.87784 (16'hE628):");
#10 assign a = 16'h50EF; assign b = 16'hD0FE;
#10 $fwrite(outfile,"\n54. -3.552 * 35.88 = -127.44576 (16'hD7F7):");
#10 assign a = 16'hC31B; assign b = 16'h507C;
#10 $fwrite(outfile,"\n55. 35.019 * -42.122 = -1475.07032 (16'hE5C3):");
#10 assign a = 16'h5061; assign b = 16'hD144;
#10 $fwrite(outfile,"\n56. 16.014 * -9.257 = -148.2416 (16'hD8A2):");
#10 assign a = 16'h4C01; assign b = 16'hC8A1;
#10 $fwrite(outfile,"\n57. 47.592 * -32.32 = -1538.17344 (16'hE602):");
#10 assign a = 16'h51F3; assign b = 16'hD00A;
#10 $fwrite(outfile,"\n58. 43.271 * -10.656 = -461.09578 (16'hDF34):");
#10 assign a = 16'h5169; assign b = 16'hC954;
#10 $fwrite(outfile,"\n59. 4.452 * -18.022 = -80.23394 (16'hD504):");
#10 assign a = 16'h4474; assign b = 16'hCC81;
#10 $fwrite(outfile,"\n60. 10.022 * -41.77 = -418.61894 (16'hDE8A):");
#10 assign a = 16'h4903; assign b = 16'hD139;
#10 $fwrite(outfile,"\n61. 19.309 * -49.758 = -960.77722 (16'hE382):");
#10 assign a = 16'h4CD4; assign b = 16'hD238;
#10 $fwrite(outfile,"\n62. 16.788 * -22.426 = -376.48769 (16'hDDE2):");
#10 assign a = 16'h4C32; assign b = 16'hCD9B;
#10 $fwrite(outfile,"\n63. -39.615 * 5.977 = -236.77886 (16'hDB66):");
#10 assign a = 16'hD0F4; assign b = 16'h45FA;
#10 $fwrite(outfile,"\n64. -23.162 * 42.342 = -980.7254 (16'hE3A9):");
#10 assign a = 16'hCDCA; assign b = 16'h514B;
#10 $fwrite(outfile,"\n65. 0.621 * -16.73 = -10.38933 (16'hC932):");
#10 assign a = 16'h38F8; assign b = 16'hCC2F;
#10 $fwrite(outfile,"\n66. -49.397 * 21.017 = -1038.17675 (16'hE40E):");
#10 assign a = 16'hD22D; assign b = 16'h4D41;
#10 $fwrite(outfile,"\n67. 7.952 * -39.453 = -313.73026 (16'hDCE7):");
#10 assign a = 16'h47F4; assign b = 16'hD0EE;
#10 $fwrite(outfile,"\n68. 29.688 * -35.11 = -1042.34568 (16'hE412):");
#10 assign a = 16'h4F6C; assign b = 16'hD064;
#10 $fwrite(outfile,"\n69. 39.749 * -26.616 = -1057.95938 (16'hE422):");
#10 assign a = 16'h50F8; assign b = 16'hCEA7;
#10 $fwrite(outfile,"\n70. -17.286 * 11.277 = -194.93422 (16'hDA17):");
#10 assign a = 16'hCC52; assign b = 16'h49A3;
#10 $fwrite(outfile,"\n71. -7.758 * 16.658 = -129.23276 (16'hD80A):");
#10 assign a = 16'hC7C2; assign b = 16'h4C2A;
#10 $fwrite(outfile,"\n72. 27.519 * -46.397 = -1276.79904 (16'hE4FD):");
#10 assign a = 16'h4EE1; assign b = 16'hD1CD;
#10 $fwrite(outfile,"\n73. -42.194 * 29.417 = -1241.2209 (16'hE4D9):");
#10 assign a = 16'hD146; assign b = 16'h4F5B;
#10 $fwrite(outfile,"\n74. 23.805 * -9.623 = -229.07551 (16'hDB29):");
#10 assign a = 16'h4DF4; assign b = 16'hC8D0;
#10 $fwrite(outfile,"\n75. -49.919 * 34.115 = -1702.98669 (16'hE6A7):");
#10 assign a = 16'hD23D; assign b = 16'h5044;
#10 $fwrite(outfile,"\n76. -34.174 * 19.56 = -668.44344 (16'hE139):");
#10 assign a = 16'hD046; assign b = 16'h4CE4;
#10 $fwrite(outfile,"\n77. 27.204 * -21.411 = -582.46484 (16'hE08D):");
#10 assign a = 16'h4ECD; assign b = 16'hCD5A;
#10 $fwrite(outfile,"\n78. 26.738 * -10.224 = -273.36931 (16'hDC45):");
#10 assign a = 16'h4EAF; assign b = 16'hC91D;
#10 $fwrite(outfile,"\n79. -43.922 * 6.809 = -299.0649 (16'hDCAC):");
#10 assign a = 16'hD17E; assign b = 16'h46CF;
#10 $fwrite(outfile,"\n80. -5.79 * 31.488 = -182.31552 (16'hD9B3):");
#10 assign a = 16'hC5CA; assign b = 16'h4FDF;
#10 $fwrite(outfile,"\n81. 1.24 * -35.87 = -44.4788 (16'hD18F):");
#10 assign a = 16'h3CF6; assign b = 16'hD07C;
#10 $fwrite(outfile,"\n82. 2.09 * -39.427 = -82.40243 (16'hD526):");
#10 assign a = 16'h402E; assign b = 16'hD0EE;
#10 $fwrite(outfile,"\n83. 34.893 * -12.724 = -443.97853 (16'hDEF0):");
#10 assign a = 16'h505D; assign b = 16'hCA5D;
#10 $fwrite(outfile,"\n84. -8.88 * 10.503 = -93.26664 (16'hD5D4):");
#10 assign a = 16'hC871; assign b = 16'h4940;
#10 $fwrite(outfile,"\n85. 26.282 * -31.858 = -837.29196 (16'hE28B):");
#10 assign a = 16'h4E92; assign b = 16'hCFF7;
#10 $fwrite(outfile,"\n86. 6.93 * -33.839 = -234.50427 (16'hDB54):");
#10 assign a = 16'h46EE; assign b = 16'hD03B;
#10 $fwrite(outfile,"\n87. -47.44 * 40.649 = -1928.38856 (16'hE788):");
#10 assign a = 16'hD1EE; assign b = 16'h5115;
#10 $fwrite(outfile,"\n88. -12.178 * 32.581 = -396.77142 (16'hDE33):");
#10 assign a = 16'hCA17; assign b = 16'h5013;
#10 $fwrite(outfile,"\n89. 45.309 * -7.604 = -344.52964 (16'hDD62):");
#10 assign a = 16'h51AA; assign b = 16'hC79B;
#10 $fwrite(outfile,"\n90. -9.177 * 49.96 = -458.48292 (16'hDF2A):");
#10 assign a = 16'hC897; assign b = 16'h523F;
#10 $fwrite(outfile,"\n91. 24.866 * -34.182 = -849.96961 (16'hE2A4):");
#10 assign a = 16'h4E37; assign b = 16'hD046;
#10 $fwrite(outfile,"\n92. 49.879 * -10.42 = -519.73918 (16'hE00F):");
#10 assign a = 16'h523C; assign b = 16'hC936;
#10 $fwrite(outfile,"\n93. -11.45 * 15.329 = -175.51705 (16'hD97C):");
#10 assign a = 16'hC9BA; assign b = 16'h4BAA;
#10 $fwrite(outfile,"\n94. 24.17 * -39.001 = -942.65417 (16'hE35D):");
#10 assign a = 16'h4E0B; assign b = 16'hD0E0;
#10 $fwrite(outfile,"\n95. -24.563 * 32.113 = -788.79162 (16'hE22A):");
#10 assign a = 16'hCE24; assign b = 16'h5004;
#10 $fwrite(outfile,"\n96. -18.815 * 31.471 = -592.12687 (16'hE0A0):");
#10 assign a = 16'hCCB4; assign b = 16'h4FDE;
#10 $fwrite(outfile,"\n97. 36.908 * -5.623 = -207.53368 (16'hDA7C):");
#10 assign a = 16'h509D; assign b = 16'hC59F;
#10 $fwrite(outfile,"\n98. 22.941 * -12.342 = -283.13782 (16'hDC6D):");
#10 assign a = 16'h4DBC; assign b = 16'hCA2C;
#10 $fwrite(outfile,"\n99. 43.42 * -17.748 = -770.61816 (16'hE205):");
#10 assign a = 16'h516D; assign b = 16'hCC70;
#10 $fwrite(outfile,"\n100. 9.882 * -21.987 = -217.27553 (16'hDACA):");
#10 assign a = 16'h48F1; assign b = 16'hCD7F;

    #10$fwrite(outfile,"\n2.57 * 3.7 = 9.509 (48C1):"); 
    #10 assign a = 16'h4124; assign b = 16'h4366; // 1.0011101000 * 2**10 or 0x64E8 // PI = 1.1001001000 * 2**1
    #10$fwrite(outfile,"\n0001 * 7801 = 1801 :");
    #10 assign a = 16'h0001; assign b = 16'h7801;
    #10$fwrite(outfile,"\n03FF * 3C02 = 0401 : h0401 largest subnormal x some normal = smallest normal");
    #10 assign a = 16'h03FF; assign b = 16'h3C02;//h0401 largest subnormal x some normal = smallest normal 
    #10$fwrite(outfile,"\n * 7BFF * 009C = 38DF :");
    #10 assign a = 16'h7BFF; assign b = 16'h009C;
    #10$fwrite(outfile,"\n0001 * 6400 = 0400 : h0400 smallest subnormal x some normal = smallest normal");
    #10 assign a = 16'h0001; assign b = 16'h6400;//h0400 smallest subnormal x some normal = smallest normal

    #20$fwrite(outfile,"\nEnd of tests : %t", $time);
    #20 $fclose(outfile);
    #20 $stop;
     $finish;
       

  end
  

  fp_mul #(NEXP, NSIG) inst1(
  .a(a),
  .b(b),
  .rnd(rnd),
  .p(p),
  .pFlags(flags)
  );

 always @(a or b) begin
        // Log the results to the file
	#1
        $fwrite(outfile,"\n p (%x %b) = a (%x) * b (%x)", p, flags, a, b);
    end
  
endmodule
