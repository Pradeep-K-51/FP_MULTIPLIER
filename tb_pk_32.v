`timescale 1ns / 1ps


module tb_pk_32;
  parameter NEXP = 8;
  parameter NSIG = 23;
  reg [NEXP+NSIG:0] a, b;
  reg [2:0] rnd;
  wire [NEXP+NSIG:0] p;
  `include "ieee-754-flags.v"
  wire [LAST_FLAG-1:0] flags;

  integer i, j, k, l, m, n,outfile;

 /* initial
  begin
    $monitor("p (%x %b) = a (%x) * b (%x)", p, flags, a, b);
  end
*/

initial begin
        // Open file for writing
        outfile = $fopen("32_bit_round.txt", "w");
        if (outfile == 0) begin
           $display(outfile,"Failed to open output file!");
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
    #10 $fwrite(outfile,"\n{qNaN, infinity, zero, subnormal, normal} * sNaN:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, 1'b0, ({NSIG-1{1'b0}} | 4'hB)};
        assign a = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    // For these tests a is always a quiet NaN.
    #10 $fwrite(outfile,"\nqNaN * {qNaN, infinity, zero, subnormal, normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    // For these tests b is always a quiet NaN.
    #10 $fwrite(outfile,"\n{infinity, zero, subnormal, normal} * qNaN:");
    #10  assign b = {1'b0, {NEXP{1'b1}}, 1'b1, ({NSIG-1{1'b0}} | 4'hB)};
         assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10  assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10  assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10  assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};


    #10 $fwrite(outfile,"\n+infinity * {+infinity, +zero, +subnormal, +normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n{+zero, +subnormal, +normal} * +infinity:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $fwrite(outfile,"\n+infinity * {-infinity, -zero, -subnormal, -normal}:");
    #10 assign a = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n{+zero, +subnormal, +normal} * -infinity:");
    #10 assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $fwrite(outfile,"\n-infinity * {+infinity, +zero, +subnormal, +normal}:");
    #10 assign a = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n{-zero, -subnormal, -normal} * +infinity:");
    #10 assign b = {1'b0, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $fwrite(outfile,"\n-infinity * {-infinity, -zero, -subnormal, -normal}:");
    #10 assign a = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n{-zero, -subnormal, -normal} * -infinity:");
    #10 assign b = {1'b1, {NEXP{1'b1}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $fwrite(outfile,"\n+zero * {+zero, +subnormal, +normal}:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n{+subnormal, +normal} * +zero:");
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $fwrite(outfile,"\n-zero * {+zero, +subnormal, +normal}:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n{-subnormal, -normal} * +zero:");
    #10 assign b = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $fwrite(outfile,"\n+zero * {-zero, -subnormal, -normal}:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n{+subnormal, +normal} * -zero:");
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b0, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $fwrite(outfile,"\n-zero * {-zero, -subnormal, -normal}:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
    #10 assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};
    #10 assign b = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n{-subnormal, -normal} * -zero:");
    #10 assign b = {1'b1, {NEXP{1'b0}}, {NSIG{1'b0}}};
        assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
    #10 assign a = {1'b1, 1'b0, {NEXP-1{1'b1}}, ({NSIG{1'b0}} | 4'hA)};

    #10 $fwrite(outfile,"\n+subnormal * +subnormal:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n+subnormal * -subnormal:");
    #10 assign a = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n-subnormal * +subnormal:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b0, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n-subnormal * -subnormal:");
    #10 assign a = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hA)};
        assign b = {1'b1, {NEXP{1'b0}}, ({NSIG{1'b0}} | 4'hB)};

    #10 $fwrite(outfile,"\n1 * 2**127:");
    #10 assign a = 32'h3F800000; assign b = 32'h7F000000;

    #10 $fwrite(outfile,"\n1 * 2**126:");
    #10 assign a = 32'h3F800000; assign b = 32'h7E800000;

    #10 $fwrite(outfile,"\n1 * 2**125:");
    #10 assign a = 32'h3F800000; assign b = 32'h7E000000;

    #10 $fwrite(outfile,"\n1 * 2**124:");
    #10 assign a = 32'h3F800000; assign b = 32'h7D800000;

    #10 $fwrite(outfile,"\n1 * 2**123:");
    #10 assign a = 32'h3F800000; assign b = 32'h7D000000;

    #10 $fwrite(outfile,"\n1 * 2**122:");
    #10 assign a = 32'h3F800000; assign b = 32'h7C800000;

    #10 $fwrite(outfile,"\n1 * 2**121:");
    #10 assign a = 32'h3F800000; assign b = 32'h7C000000;

    #10 $fwrite(outfile,"\n1 * 2**120:");
    #10 assign a = 32'h3F800000; assign b = 32'h7B800000;

    #10 $fwrite(outfile,"\n1 * 2**119:");
    #10 assign a = 32'h3F800000; assign b = 32'h7B000000;

    #10 $fwrite(outfile,"\n1 * 2**118:");
    #10 assign a = 32'h3F800000; assign b = 32'h7A800000;

    #10 $fwrite(outfile,"\n1 * 2**117:");
    #10 assign a = 32'h3F800000; assign b = 32'h7A000000;

    #10 $fwrite(outfile,"\n1 * 2**116:");
    #10 assign a = 32'h3F800000; assign b = 32'h79800000;

    #10 $fwrite(outfile,"\n1 * 2**115:");
    #10 assign a = 32'h3F800000; assign b = 32'h79000000;

    #10 $fwrite(outfile,"\n1 * 2**114:");
    #10 assign a = 32'h3F800000; assign b = 32'h78800000;

    #10 $fwrite(outfile,"\n1 * 2**113:");
    #10 assign a = 32'h3F800000; assign b = 32'h78000000;

    #10 $fwrite(outfile,"\n1 * 2**112:");
    #10 assign a = 32'h3F800000; assign b = 32'h77800000;

    #10 $fwrite(outfile,"\n1 * 2**111:");
    #10 assign a = 32'h3F800000; assign b = 32'h77000000;

    #10 $fwrite(outfile,"\n1 * 2**110:");
    #10 assign a = 32'h3F800000; assign b = 32'h76800000;

    #10 $fwrite(outfile,"\n1 * 2**109:");
    #10 assign a = 32'h3F800000; assign b = 32'h76000000;

    #10 $fwrite(outfile,"\n1 * 2**108:");
    #10 assign a = 32'h3F800000; assign b = 32'h75800000;

    #10 $fwrite(outfile,"\n1 * 2**107:");
    #10 assign a = 32'h3F800000; assign b = 32'h75000000;

    #10 $fwrite(outfile,"\n1 * 2**106:");
    #10 assign a = 32'h3F800000; assign b = 32'h74800000;

    #10 $fwrite(outfile,"\n1 * 2**105:");
    #10 assign a = 32'h3F800000; assign b = 32'h74000000;

    #10 $fwrite(outfile,"\n1 * 2**104:");
    #10 assign a = 32'h3F800000; assign b = 32'h73800000;

    #10 $fwrite(outfile,"\n1 * 2**103:");
    #10 assign a = 32'h3F800000; assign b = 32'h73000000;

    #10 $fwrite(outfile,"\n1 * 2**102:");
    #10 assign a = 32'h3F800000; assign b = 32'h72800000;

    #10 $fwrite(outfile,"\n1 * 2**101:");
    #10 assign a = 32'h3F800000; assign b = 32'h72000000;

    #10 $fwrite(outfile,"\n1 * 2**100:");
    #10 assign a = 32'h3F800000; assign b = 32'h71800000;

    #10 $fwrite(outfile,"\n1 * 2**99:");
    #10 assign a = 32'h3F800000; assign b = 32'h71000000;

    #10 $fwrite(outfile,"\n1 * 2**98:");
    #10 assign a = 32'h3F800000; assign b = 32'h70800000;

    #10 $fwrite(outfile,"\n1 * 2**97:");
    #10 assign a = 32'h3F800000; assign b = 32'h70000000;

    #10 $fwrite(outfile,"\n1 * 2**96:");
    #10 assign a = 32'h3F800000; assign b = 32'h6F800000;

    #10 $fwrite(outfile,"\n1 * 2**95:");
    #10 assign a = 32'h3F800000; assign b = 32'h6F000000;

    #10 $fwrite(outfile,"\n1 * 2**94:");
    #10 assign a = 32'h3F800000; assign b = 32'h6E800000;

    #10 $fwrite(outfile,"\n1 * 2**93:");
    #10 assign a = 32'h3F800000; assign b = 32'h6E000000;

    #10 $fwrite(outfile,"\n1 * 2**92:");
    #10 assign a = 32'h3F800000; assign b = 32'h6D800000;

    #10 $fwrite(outfile,"\n1 * 2**91:");
    #10 assign a = 32'h3F800000; assign b = 32'h6D000000;

    #10 $fwrite(outfile,"\n1 * 2**90:");
    #10 assign a = 32'h3F800000; assign b = 32'h6C800000;

    #10 $fwrite(outfile,"\n1 * 2**89:");
    #10 assign a = 32'h3F800000; assign b = 32'h6C000000;

    #10 $fwrite(outfile,"\n1 * 2**88:");
    #10 assign a = 32'h3F800000; assign b = 32'h6B800000;

    #10 $fwrite(outfile,"\n1 * 2**87:");
    #10 assign a = 32'h3F800000; assign b = 32'h6B000000;

    #10 $fwrite(outfile,"\n1 * 2**86:");
    #10 assign a = 32'h3F800000; assign b = 32'h6A800000;

    #10 $fwrite(outfile,"\n1 * 2**85:");
    #10 assign a = 32'h3F800000; assign b = 32'h6A000000;

    #10 $fwrite(outfile,"\n1 * 2**84:");
    #10 assign a = 32'h3F800000; assign b = 32'h69800000;

    #10 $fwrite(outfile,"\n1 * 2**83:");
    #10 assign a = 32'h3F800000; assign b = 32'h69000000;

    #10 $fwrite(outfile,"\n1 * 2**82:");
    #10 assign a = 32'h3F800000; assign b = 32'h68800000;

    #10 $fwrite(outfile,"\n1 * 2**81:");
    #10 assign a = 32'h3F800000; assign b = 32'h68000000;

    #10 $fwrite(outfile,"\n1 * 2**80:");
    #10 assign a = 32'h3F800000; assign b = 32'h67800000;

    #10 $fwrite(outfile,"\n1 * 2**79:");
    #10 assign a = 32'h3F800000; assign b = 32'h67000000;

    #10 $fwrite(outfile,"\n1 * 2**78:");
    #10 assign a = 32'h3F800000; assign b = 32'h66800000;

    #10 $fwrite(outfile,"\n1 * 2**77:");
    #10 assign a = 32'h3F800000; assign b = 32'h66000000;

    #10 $fwrite(outfile,"\n1 * 2**76:");
    #10 assign a = 32'h3F800000; assign b = 32'h65800000;

    #10 $fwrite(outfile,"\n1 * 2**75:");
    #10 assign a = 32'h3F800000; assign b = 32'h65000000;

    #10 $fwrite(outfile,"\n1 * 2**74:");
    #10 assign a = 32'h3F800000; assign b = 32'h64800000;

    #10 $fwrite(outfile,"\n1 * 2**73:");
    #10 assign a = 32'h3F800000; assign b = 32'h64000000;

    #10 $fwrite(outfile,"\n1 * 2**72:");
    #10 assign a = 32'h3F800000; assign b = 32'h63800000;

    #10 $fwrite(outfile,"\n1 * 2**71:");
    #10 assign a = 32'h3F800000; assign b = 32'h63000000;

    #10 $fwrite(outfile,"\n1 * 2**70:");
    #10 assign a = 32'h3F800000; assign b = 32'h62800000;

    #10 $fwrite(outfile,"\n1 * 2**69:");
    #10 assign a = 32'h3F800000; assign b = 32'h62000000;

    #10 $fwrite(outfile,"\n1 * 2**68:");
    #10 assign a = 32'h3F800000; assign b = 32'h61800000;

    #10 $fwrite(outfile,"\n1 * 2**67:");
    #10 assign a = 32'h3F800000; assign b = 32'h61000000;

    #10 $fwrite(outfile,"\n1 * 2**66:");
    #10 assign a = 32'h3F800000; assign b = 32'h60800000;

    #10 $fwrite(outfile,"\n1 * 2**65:");
    #10 assign a = 32'h3F800000; assign b = 32'h60000000;

    #10 $fwrite(outfile,"\n1 * 2**64:");
    #10 assign a = 32'h3F800000; assign b = 32'h5F800000;

    #10 $fwrite(outfile,"\n1 * 2**63:");
    #10 assign a = 32'h3F800000; assign b = 32'h5F000000;

    #10 $fwrite(outfile,"\n1 * 2**62:");
    #10 assign a = 32'h3F800000; assign b = 32'h5E800000;

    #10 $fwrite(outfile,"\n1 * 2**61:");
    #10 assign a = 32'h3F800000; assign b = 32'h5E000000;

    #10 $fwrite(outfile,"\n1 * 2**60:");
    #10 assign a = 32'h3F800000; assign b = 32'h5D800000;

    #10 $fwrite(outfile,"\n1 * 2**59:");
    #10 assign a = 32'h3F800000; assign b = 32'h5D000000;

    #10 $fwrite(outfile,"\n1 * 2**58:");
    #10 assign a = 32'h3F800000; assign b = 32'h5C800000;

    #10 $fwrite(outfile,"\n1 * 2**57:");
    #10 assign a = 32'h3F800000; assign b = 32'h5C000000;

    #10 $fwrite(outfile,"\n1 * 2**56:");
    #10 assign a = 32'h3F800000; assign b = 32'h5B800000;

    #10 $fwrite(outfile,"\n1 * 2**55:");
    #10 assign a = 32'h3F800000; assign b = 32'h5B000000;

    #10 $fwrite(outfile,"\n1 * 2**54:");
    #10 assign a = 32'h3F800000; assign b = 32'h5A800000;

    #10 $fwrite(outfile,"\n1 * 2**53:");
    #10 assign a = 32'h3F800000; assign b = 32'h5A000000;

    #10 $fwrite(outfile,"\n1 * 2**52:");
    #10 assign a = 32'h3F800000; assign b = 32'h59800000;

    #10 $fwrite(outfile,"\n1 * 2**51:");
    #10 assign a = 32'h3F800000; assign b = 32'h59000000;

    #10 $fwrite(outfile,"\n1 * 2**50:");
    #10 assign a = 32'h3F800000; assign b = 32'h58800000;

    #10 $fwrite(outfile,"\n1 * 2**49:");
    #10 assign a = 32'h3F800000; assign b = 32'h58000000;

    #10 $fwrite(outfile,"\n1 * 2**48:");
    #10 assign a = 32'h3F800000; assign b = 32'h57800000;

    #10 $fwrite(outfile,"\n1 * 2**47:");
    #10 assign a = 32'h3F800000; assign b = 32'h57000000;

    #10 $fwrite(outfile,"\n1 * 2**46:");
    #10 assign a = 32'h3F800000; assign b = 32'h56800000;

    #10 $fwrite(outfile,"\n1 * 2**45:");
    #10 assign a = 32'h3F800000; assign b = 32'h56000000;

    #10 $fwrite(outfile,"\n1 * 2**44:");
    #10 assign a = 32'h3F800000; assign b = 32'h55800000;

    #10 $fwrite(outfile,"\n1 * 2**43:");
    #10 assign a = 32'h3F800000; assign b = 32'h55000000;

    #10 $fwrite(outfile,"\n1 * 2**42:");
    #10 assign a = 32'h3F800000; assign b = 32'h54800000;

    #10 $fwrite(outfile,"\n1 * 2**41:");
    #10 assign a = 32'h3F800000; assign b = 32'h54000000;

    #10 $fwrite(outfile,"\n1 * 2**40:");
    #10 assign a = 32'h3F800000; assign b = 32'h53800000;

    #10 $fwrite(outfile,"\n1 * 2**39:");
    #10 assign a = 32'h3F800000; assign b = 32'h53000000;

    #10 $fwrite(outfile,"\n1 * 2**38:");
    #10 assign a = 32'h3F800000; assign b = 32'h52800000;

    #10 $fwrite(outfile,"\n1 * 2**37:");
    #10 assign a = 32'h3F800000; assign b = 32'h52000000;

    #10 $fwrite(outfile,"\n1 * 2**36:");
    #10 assign a = 32'h3F800000; assign b = 32'h51800000;

    #10 $fwrite(outfile,"\n1 * 2**35:");
    #10 assign a = 32'h3F800000; assign b = 32'h51000000;

    #10 $fwrite(outfile,"\n1 * 2**34:");
    #10 assign a = 32'h3F800000; assign b = 32'h50800000;

    #10 $fwrite(outfile,"\n1 * 2**33:");
    #10 assign a = 32'h3F800000; assign b = 32'h50000000;

    #10 $fwrite(outfile,"\n1 * 2**32:");
    #10 assign a = 32'h3F800000; assign b = 32'h4F800000;

    #10 $fwrite(outfile,"\n1 * 2**31:");
    #10 assign a = 32'h3F800000; assign b = 32'h4F000000;

    #10 $fwrite(outfile,"\n1 * 2**30:");
    #10 assign a = 32'h3F800000; assign b = 32'h4E800000;

    #10 $fwrite(outfile,"\n1 * 2**29:");
    #10 assign a = 32'h3F800000; assign b = 32'h4E000000;

    #10 $fwrite(outfile,"\n1 * 2**28:");
    #10 assign a = 32'h3F800000; assign b = 32'h4D800000;

    #10 $fwrite(outfile,"\n1 * 2**27:");
    #10 assign a = 32'h3F800000; assign b = 32'h4D000000;

    #10 $fwrite(outfile,"\n1 * 2**26:");
    #10 assign a = 32'h3F800000; assign b = 32'h4C800000;

    #10 $fwrite(outfile,"\n1 * 2**25:");
    #10 assign a = 32'h3F800000; assign b = 32'h4C000000;

    #10 $fwrite(outfile,"\n1 * 2**24:");
    #10 assign a = 32'h3F800000; assign b = 32'h4B800000;

    #10 $fwrite(outfile,"\n1 * 2**23:");
    #10 assign a = 32'h3F800000; assign b = 32'h4B000000;

    #10 $fwrite(outfile,"\n1 * 2**22:");
    #10 assign a = 32'h3F800000; assign b = 32'h4A800000;

    #10 $fwrite(outfile,"\n1 * 2**21:");
    #10 assign a = 32'h3F800000; assign b = 32'h4A000000;

    #10 $fwrite(outfile,"\n1 * 2**20:");
    #10 assign a = 32'h3F800000; assign b = 32'h49800000;

    #10 $fwrite(outfile,"\n1 * 2**19:");
    #10 assign a = 32'h3F800000; assign b = 32'h49000000;

    #10 $fwrite(outfile,"\n1 * 2**18:");
    #10 assign a = 32'h3F800000; assign b = 32'h48800000;

    #10 $fwrite(outfile,"\n1 * 2**17:");
    #10 assign a = 32'h3F800000; assign b = 32'h48000000;

    #10 $fwrite(outfile,"\n1 * 2**16:");
    #10 assign a = 32'h3F800000; assign b = 32'h47800000;

    #10 $fwrite(outfile,"\n1 * 2**15:");
    #10 assign a = 32'h3F800000; assign b = 32'h47000000;

    #10 $fwrite(outfile,"\n1 * 2**14:");
    #10 assign a = 32'h3F800000; assign b = 32'h46800000;

    #10 $fwrite(outfile,"\n1 * 2**13:");
    #10 assign a = 32'h3F800000; assign b = 32'h46000000;

    #10 $fwrite(outfile,"\n1 * 2**12:");
    #10 assign a = 32'h3F800000; assign b = 32'h45800000;

    #10 $fwrite(outfile,"\n1 * 2**11:");
    #10 assign a = 32'h3F800000; assign b = 32'h45000000;

    #10 $fwrite(outfile,"\n1 * 2**10:");
    #10 assign a = 32'h3F800000; assign b = 32'h44800000;

    #10 $fwrite(outfile,"\n1 * 2**9:");
    #10 assign a = 32'h3F800000; assign b = 32'h44000000;

    #10 $fwrite(outfile,"\n1 * 2**8:");
    #10 assign a = 32'h3F800000; assign b = 32'h43800000;

    #10 $fwrite(outfile,"\n1 * 2**7:");
    #10 assign a = 32'h3F800000; assign b = 32'h43000000;

    #10 $fwrite(outfile,"\n1 * 2**6:");
    #10 assign a = 32'h3F800000; assign b = 32'h42800000;

    #10 $fwrite(outfile,"\n1 * 2**5:");
    #10 assign a = 32'h3F800000; assign b = 32'h42000000;

    #10 $fwrite(outfile,"\n1 * 2**4:");
    #10 assign a = 32'h3F800000; assign b = 32'h41800000;

    #10 $fwrite(outfile,"\n1 * 2**3:");
    #10 assign a = 32'h3F800000; assign b = 32'h41000000;

    #10 $fwrite(outfile,"\n1 * 2**2:");
    #10 assign a = 32'h3F800000; assign b = 32'h40800000;

    #10 $fwrite(outfile,"\n1 * 2**1:");
    #10 assign a = 32'h3F800000; assign b = 32'h40000000;

    #10 $fwrite(outfile,"\n1 * 2**0:");
    #10 assign a = 32'h3F800000; assign b = 32'h3F800000;

    #10 $fwrite(outfile,"\n1 * 2**-1:");
    #10 assign a = 32'h3F800000; assign b = 32'h3F000000;

    #10 $fwrite(outfile,"\n1 * 2**-2:");
    #10 assign a = 32'h3F800000; assign b = 32'h3E800000;

    #10 $fwrite(outfile,"\n1 * 2**-3:");
    #10 assign a = 32'h3F800000; assign b = 32'h3E000000;

    #10 $fwrite(outfile,"\n1 * 2**-4:");
    #10 assign a = 32'h3F800000; assign b = 32'h3D800000;

    #10 $fwrite(outfile,"\n1 * 2**-5:");
    #10 assign a = 32'h3F800000; assign b = 32'h3D000000;

    #10 $fwrite(outfile,"\n1 * 2**-6:");
    #10 assign a = 32'h3F800000; assign b = 32'h3C800000;

    #10 $fwrite(outfile,"\n1 * 2**-7:");
    #10 assign a = 32'h3F800000; assign b = 32'h3C000000;

    #10 $fwrite(outfile,"\n1 * 2**-8:");
    #10 assign a = 32'h3F800000; assign b = 32'h3B800000;

    #10 $fwrite(outfile,"\n1 * 2**-9:");
    #10 assign a = 32'h3F800000; assign b = 32'h3B000000;

    #10 $fwrite(outfile,"\n1 * 2**-10:");
    #10 assign a = 32'h3F800000; assign b = 32'h3A800000;

    #10 $fwrite(outfile,"\n1 * 2**-11:");
    #10 assign a = 32'h3F800000; assign b = 32'h3A000000;

    #10 $fwrite(outfile,"\n1 * 2**-12:");
    #10 assign a = 32'h3F800000; assign b = 32'h39800000;

    #10 $fwrite(outfile,"\n1 * 2**-13:");
    #10 assign a = 32'h3F800000; assign b = 32'h39000000;

    #10 $fwrite(outfile,"\n1 * 2**-14:");
    #10 assign a = 32'h3F800000; assign b = 32'h38800000;

    #10 $fwrite(outfile,"\n1 * 2**-15:");
    #10 assign a = 32'h3F800000; assign b = 32'h38000000;

    #10 $fwrite(outfile,"\n1 * 2**-16:");
    #10 assign a = 32'h3F800000; assign b = 32'h37800000;

    #10 $fwrite(outfile,"\n1 * 2**-17:");
    #10 assign a = 32'h3F800000; assign b = 32'h37000000;

    #10 $fwrite(outfile,"\n1 * 2**-18:");
    #10 assign a = 32'h3F800000; assign b = 32'h36800000;

    #10 $fwrite(outfile,"\n1 * 2**-19:");
    #10 assign a = 32'h3F800000; assign b = 32'h36000000;

    #10 $fwrite(outfile,"\n1 * 2**-20:");
    #10 assign a = 32'h3F800000; assign b = 32'h35800000;

    #10 $fwrite(outfile,"\n1 * 2**-21:");
    #10 assign a = 32'h3F800000; assign b = 32'h35000000;

    #10 $fwrite(outfile,"\n1 * 2**-22:");
    #10 assign a = 32'h3F800000; assign b = 32'h34800000;

    #10 $fwrite(outfile,"\n1 * 2**-23:");
    #10 assign a = 32'h3F800000; assign b = 32'h34000000;

    #10 $fwrite(outfile,"\n1 * 2**-24:");
    #10 assign a = 32'h3F800000; assign b = 32'h33800000;

    #10 $fwrite(outfile,"\n1 * 2**-25:");
    #10 assign a = 32'h3F800000; assign b = 32'h33000000;

    #10 $fwrite(outfile,"\n1 * 2**-26:");
    #10 assign a = 32'h3F800000; assign b = 32'h32800000;

    #10 $fwrite(outfile,"\n1 * 2**-27:");
    #10 assign a = 32'h3F800000; assign b = 32'h32000000;

    #10 $fwrite(outfile,"\n1 * 2**-28:");
    #10 assign a = 32'h3F800000; assign b = 32'h31800000;

    #10 $fwrite(outfile,"\n1 * 2**-29:");
    #10 assign a = 32'h3F800000; assign b = 32'h31000000;

    #10 $fwrite(outfile,"\n1 * 2**-30:");
    #10 assign a = 32'h3F800000; assign b = 32'h30800000;

    #10 $fwrite(outfile,"\n1 * 2**-31:");
    #10 assign a = 32'h3F800000; assign b = 32'h30000000;

    #10 $fwrite(outfile,"\n1 * 2**-32:");
    #10 assign a = 32'h3F800000; assign b = 32'h2F800000;

    #10 $fwrite(outfile,"\n1 * 2**-33:");
    #10 assign a = 32'h3F800000; assign b = 32'h2F000000;

    #10 $fwrite(outfile,"\n1 * 2**-34:");
    #10 assign a = 32'h3F800000; assign b = 32'h2E800000;

    #10 $fwrite(outfile,"\n1 * 2**-35:");
    #10 assign a = 32'h3F800000; assign b = 32'h2E000000;

    #10 $fwrite(outfile,"\n1 * 2**-36:");
    #10 assign a = 32'h3F800000; assign b = 32'h2D800000;

    #10 $fwrite(outfile,"\n1 * 2**-37:");
    #10 assign a = 32'h3F800000; assign b = 32'h2D000000;

    #10 $fwrite(outfile,"\n1 * 2**-38:");
    #10 assign a = 32'h3F800000; assign b = 32'h2C800000;

    #10 $fwrite(outfile,"\n1 * 2**-39:");
    #10 assign a = 32'h3F800000; assign b = 32'h2C000000;

    #10 $fwrite(outfile,"\n1 * 2**-40:");
    #10 assign a = 32'h3F800000; assign b = 32'h2B800000;

    #10 $fwrite(outfile,"\n1 * 2**-41:");
    #10 assign a = 32'h3F800000; assign b = 32'h2B000000;

    #10 $fwrite(outfile,"\n1 * 2**-42:");
    #10 assign a = 32'h3F800000; assign b = 32'h2A800000;

    #10 $fwrite(outfile,"\n1 * 2**-43:");
    #10 assign a = 32'h3F800000; assign b = 32'h2A000000;

    #10 $fwrite(outfile,"\n1 * 2**-44:");
    #10 assign a = 32'h3F800000; assign b = 32'h29800000;

    #10 $fwrite(outfile,"\n1 * 2**-45:");
    #10 assign a = 32'h3F800000; assign b = 32'h29000000;

    #10 $fwrite(outfile,"\n1 * 2**-46:");
    #10 assign a = 32'h3F800000; assign b = 32'h28800000;

    #10 $fwrite(outfile,"\n1 * 2**-47:");
    #10 assign a = 32'h3F800000; assign b = 32'h28000000;

    #10 $fwrite(outfile,"\n1 * 2**-48:");
    #10 assign a = 32'h3F800000; assign b = 32'h27800000;

    #10 $fwrite(outfile,"\n1 * 2**-49:");
    #10 assign a = 32'h3F800000; assign b = 32'h27000000;

    #10 $fwrite(outfile,"\n1 * 2**-50:");
    #10 assign a = 32'h3F800000; assign b = 32'h26800000;

    #10 $fwrite(outfile,"\n1 * 2**-51:");
    #10 assign a = 32'h3F800000; assign b = 32'h26000000;

    #10 $fwrite(outfile,"\n1 * 2**-52:");
    #10 assign a = 32'h3F800000; assign b = 32'h25800000;

    #10 $fwrite(outfile,"\n1 * 2**-53:");
    #10 assign a = 32'h3F800000; assign b = 32'h25000000;

    #10 $fwrite(outfile,"\n1 * 2**-54:");
    #10 assign a = 32'h3F800000; assign b = 32'h24800000;

    #10 $fwrite(outfile,"\n1 * 2**-55:");
    #10 assign a = 32'h3F800000; assign b = 32'h24000000;

    #10 $fwrite(outfile,"\n1 * 2**-56:");
    #10 assign a = 32'h3F800000; assign b = 32'h23800000;

    #10 $fwrite(outfile,"\n1 * 2**-57:");
    #10 assign a = 32'h3F800000; assign b = 32'h23000000;

    #10 $fwrite(outfile,"\n1 * 2**-58:");
    #10 assign a = 32'h3F800000; assign b = 32'h22800000;

    #10 $fwrite(outfile,"\n1 * 2**-59:");
    #10 assign a = 32'h3F800000; assign b = 32'h22000000;

    #10 $fwrite(outfile,"\n1 * 2**-60:");
    #10 assign a = 32'h3F800000; assign b = 32'h21800000;

    #10 $fwrite(outfile,"\n1 * 2**-61:");
    #10 assign a = 32'h3F800000; assign b = 32'h21000000;

    #10 $fwrite(outfile,"\n1 * 2**-62:");
    #10 assign a = 32'h3F800000; assign b = 32'h20800000;

    #10 $fwrite(outfile,"\n1 * 2**-63:");
    #10 assign a = 32'h3F800000; assign b = 32'h20000000;

    #10 $fwrite(outfile,"\n1 * 2**-64:");
    #10 assign a = 32'h3F800000; assign b = 32'h1F800000;

    #10 $fwrite(outfile,"\n1 * 2**-65:");
    #10 assign a = 32'h3F800000; assign b = 32'h1F000000;

    #10 $fwrite(outfile,"\n1 * 2**-66:");
    #10 assign a = 32'h3F800000; assign b = 32'h1E800000;

    #10 $fwrite(outfile,"\n1 * 2**-67:");
    #10 assign a = 32'h3F800000; assign b = 32'h1E000000;

    #10 $fwrite(outfile,"\n1 * 2**-68:");
    #10 assign a = 32'h3F800000; assign b = 32'h1D800000;

    #10 $fwrite(outfile,"\n1 * 2**-69:");
    #10 assign a = 32'h3F800000; assign b = 32'h1D000000;

    #10 $fwrite(outfile,"\n1 * 2**-70:");
    #10 assign a = 32'h3F800000; assign b = 32'h1C800000;

    #10 $fwrite(outfile,"\n1 * 2**-71:");
    #10 assign a = 32'h3F800000; assign b = 32'h1C000000;

    #10 $fwrite(outfile,"\n1 * 2**-72:");
    #10 assign a = 32'h3F800000; assign b = 32'h1B800000;

    #10 $fwrite(outfile,"\n1 * 2**-73:");
    #10 assign a = 32'h3F800000; assign b = 32'h1B000000;

    #10 $fwrite(outfile,"\n1 * 2**-74:");
    #10 assign a = 32'h3F800000; assign b = 32'h1A800000;

    #10 $fwrite(outfile,"\n1 * 2**-75:");
    #10 assign a = 32'h3F800000; assign b = 32'h1A000000;

    #10 $fwrite(outfile,"\n1 * 2**-76:");
    #10 assign a = 32'h3F800000; assign b = 32'h19800000;

    #10 $fwrite(outfile,"\n1 * 2**-77:");
    #10 assign a = 32'h3F800000; assign b = 32'h19000000;

    #10 $fwrite(outfile,"\n1 * 2**-78:");
    #10 assign a = 32'h3F800000; assign b = 32'h18800000;

    #10 $fwrite(outfile,"\n1 * 2**-79:");
    #10 assign a = 32'h3F800000; assign b = 32'h18000000;

    #10 $fwrite(outfile,"\n1 * 2**-80:");
    #10 assign a = 32'h3F800000; assign b = 32'h17800000;

    #10 $fwrite(outfile,"\n1 * 2**-81:");
    #10 assign a = 32'h3F800000; assign b = 32'h17000000;

    #10 $fwrite(outfile,"\n1 * 2**-82:");
    #10 assign a = 32'h3F800000; assign b = 32'h16800000;

    #10 $fwrite(outfile,"\n1 * 2**-83:");
    #10 assign a = 32'h3F800000; assign b = 32'h16000000;

    #10 $fwrite(outfile,"\n1 * 2**-84:");
    #10 assign a = 32'h3F800000; assign b = 32'h15800000;

    #10 $fwrite(outfile,"\n1 * 2**-85:");
    #10 assign a = 32'h3F800000; assign b = 32'h15000000;

    #10 $fwrite(outfile,"\n1 * 2**-86:");
    #10 assign a = 32'h3F800000; assign b = 32'h14800000;

    #10 $fwrite(outfile,"\n1 * 2**-87:");
    #10 assign a = 32'h3F800000; assign b = 32'h14000000;

    #10 $fwrite(outfile,"\n1 * 2**-88:");
    #10 assign a = 32'h3F800000; assign b = 32'h13800000;

    #10 $fwrite(outfile,"\n1 * 2**-89:");
    #10 assign a = 32'h3F800000; assign b = 32'h13000000;

    #10 $fwrite(outfile,"\n1 * 2**-90:");
    #10 assign a = 32'h3F800000; assign b = 32'h12800000;

    #10 $fwrite(outfile,"\n1 * 2**-91:");
    #10 assign a = 32'h3F800000; assign b = 32'h12000000;

    #10 $fwrite(outfile,"\n1 * 2**-92:");
    #10 assign a = 32'h3F800000; assign b = 32'h11800000;

    #10 $fwrite(outfile,"\n1 * 2**-93:");
    #10 assign a = 32'h3F800000; assign b = 32'h11000000;

    #10 $fwrite(outfile,"\n1 * 2**-94:");
    #10 assign a = 32'h3F800000; assign b = 32'h10800000;

    #10 $fwrite(outfile,"\n1 * 2**-95:");
    #10 assign a = 32'h3F800000; assign b = 32'h10000000;

    #10 $fwrite(outfile,"\n1 * 2**-96:");
    #10 assign a = 32'h3F800000; assign b = 32'h0F800000;

    #10 $fwrite(outfile,"\n1 * 2**-97:");
    #10 assign a = 32'h3F800000; assign b = 32'h0F000000;

    #10 $fwrite(outfile,"\n1 * 2**-98:");
    #10 assign a = 32'h3F800000; assign b = 32'h0E800000;

    #10 $fwrite(outfile,"\n1 * 2**-99:");
    #10 assign a = 32'h3F800000; assign b = 32'h0E000000;

    #10 $fwrite(outfile,"\n1 * 2**-100:");
    #10 assign a = 32'h3F800000; assign b = 32'h0D800000;

    #10 $fwrite(outfile,"\n1 * 2**-101:");
    #10 assign a = 32'h3F800000; assign b = 32'h0D000000;

    #10 $fwrite(outfile,"\n1 * 2**-102:");
    #10 assign a = 32'h3F800000; assign b = 32'h0C800000;

    #10 $fwrite(outfile,"\n1 * 2**-103:");
    #10 assign a = 32'h3F800000; assign b = 32'h0C000000;

    #10 $fwrite(outfile,"\n1 * 2**-104:");
    #10 assign a = 32'h3F800000; assign b = 32'h0B800000;

    #10 $fwrite(outfile,"\n1 * 2**-105:");
    #10 assign a = 32'h3F800000; assign b = 32'h0B000000;

    #10 $fwrite(outfile,"\n1 * 2**-106:");
    #10 assign a = 32'h3F800000; assign b = 32'h0A800000;

    #10 $fwrite(outfile,"\n1 * 2**-107:");
    #10 assign a = 32'h3F800000; assign b = 32'h0A000000;

    #10 $fwrite(outfile,"\n1 * 2**-108:");
    #10 assign a = 32'h3F800000; assign b = 32'h09800000;

    #10 $fwrite(outfile,"\n1 * 2**-109:");
    #10 assign a = 32'h3F800000; assign b = 32'h09000000;

    #10 $fwrite(outfile,"\n1 * 2**-110:");
    #10 assign a = 32'h3F800000; assign b = 32'h08800000;

    #10 $fwrite(outfile,"\n1 * 2**-111:");
    #10 assign a = 32'h3F800000; assign b = 32'h08000000;

    #10 $fwrite(outfile,"\n1 * 2**-112:");
    #10 assign a = 32'h3F800000; assign b = 32'h07800000;

    #10 $fwrite(outfile,"\n1 * 2**-113:");
    #10 assign a = 32'h3F800000; assign b = 32'h07000000;

    #10 $fwrite(outfile,"\n1 * 2**-114:");
    #10 assign a = 32'h3F800000; assign b = 32'h06800000;

    #10 $fwrite(outfile,"\n1 * 2**-115:");
    #10 assign a = 32'h3F800000; assign b = 32'h06000000;

    #10 $fwrite(outfile,"\n1 * 2**-116:");
    #10 assign a = 32'h3F800000; assign b = 32'h05800000;

    #10 $fwrite(outfile,"\n1 * 2**-117:");
    #10 assign a = 32'h3F800000; assign b = 32'h05000000;

    #10 $fwrite(outfile,"\n1 * 2**-118:");
    #10 assign a = 32'h3F800000; assign b = 32'h04800000;

    #10 $fwrite(outfile,"\n1 * 2**-119:");
    #10 assign a = 32'h3F800000; assign b = 32'h04000000;

    #10 $fwrite(outfile,"\n1 * 2**-120:");
    #10 assign a = 32'h3F800000; assign b = 32'h03800000;

    #10 $fwrite(outfile,"\n1 * 2**-121:");
    #10 assign a = 32'h3F800000; assign b = 32'h03000000;

    #10 $fwrite(outfile,"\n1 * 2**-122:");
    #10 assign a = 32'h3F800000; assign b = 32'h02800000;

    #10 $fwrite(outfile,"\n1 * 2**-123:");
    #10 assign a = 32'h3F800000; assign b = 32'h02000000;

    #10 $fwrite(outfile,"\n1 * 2**-124:");
    #10 assign a = 32'h3F800000; assign b = 32'h01800000;

    #10 $fwrite(outfile,"\n1 * 2**-125:");
    #10 assign a = 32'h3F800000; assign b = 32'h01000000;

    #10 $fwrite(outfile,"\n1 * 2**-126:");
    #10 assign a = 32'h3F800000; assign b = 32'h00800000;

    #10 $fwrite(outfile,"\n1 * 2**-127:");
    #10 assign a = 32'h3F800000; assign b = 32'h00400000;

    #10 $fwrite(outfile,"\n1 * 2**-128:");
    #10 assign a = 32'h3F800000; assign b = 32'h00200000;

    #10 $fwrite(outfile,"\n1 * 2**-129:");
    #10 assign a = 32'h3F800000; assign b = 32'h00100000;

    #10 $fwrite(outfile,"\n1 * 2**-130:");
    #10 assign a = 32'h3F800000; assign b = 32'h00080000;

    #10 $fwrite(outfile,"\n1 * 2**-131:");
    #10 assign a = 32'h3F800000; assign b = 32'h00040000;

    #10 $fwrite(outfile,"\n1 * 2**-132:");
    #10 assign a = 32'h3F800000; assign b = 32'h00020000;

    #10 $fwrite(outfile,"\n1 * 2**-133:");
    #10 assign a = 32'h3F800000; assign b = 32'h00010000;

    #10 $fwrite(outfile,"\n1 * 2**-134:");
    #10 assign a = 32'h3F800000; assign b = 32'h00008000;

    #10 $fwrite(outfile,"\n1 * 2**-135:");
    #10 assign a = 32'h3F800000; assign b = 32'h00004000;

    #10 $fwrite(outfile,"\n1 * 2**-136:");
    #10 assign a = 32'h3F800000; assign b = 32'h00002000;

    #10 $fwrite(outfile,"\n1 * 2**-137:");
    #10 assign a = 32'h3F800000; assign b = 32'h00001000;

    #10 $fwrite(outfile,"\n1 * 2**-138:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000800;

    #10 $fwrite(outfile,"\n1 * 2**-139:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000400;

    #10 $fwrite(outfile,"\n1 * 2**-140:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000200;

    #10 $fwrite(outfile,"\n1 * 2**-141:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000100;

    #10 $fwrite(outfile,"\n1 * 2**-142:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000080;

    #10 $fwrite(outfile,"\n1 * 2**-143:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000040;

    #10 $fwrite(outfile,"\n1 * 2**-144:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000020;

    #10 $fwrite(outfile,"\n1 * 2**-145:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000010;

    #10 $fwrite(outfile,"\n1 * 2**-146:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000008;

    #10 $fwrite(outfile,"\n1 * 2**-147:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000004;

    #10 $fwrite(outfile,"\n1 * 2**-148:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000002;

    #10 $fwrite(outfile,"\n1 * 2**-149:");
    #10 assign a = 32'h3F800000; assign b = 32'h00000001;

    #10 $fwrite(outfile,"\n2**127 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7F000000;

    #10 $fwrite(outfile,"\n2**126 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7E800000;

    #10 $fwrite(outfile,"\n2**125 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7E000000;

    #10 $fwrite(outfile,"\n2**124 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7D800000;

    #10 $fwrite(outfile,"\n2**123 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7D000000;

    #10 $fwrite(outfile,"\n2**122 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7C800000;

    #10 $fwrite(outfile,"\n2**121 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7C000000;

    #10 $fwrite(outfile,"\n2**120 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7B800000;

    #10 $fwrite(outfile,"\n2**119 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7B000000;

    #10 $fwrite(outfile,"\n2**118 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7A800000;

    #10 $fwrite(outfile,"\n2**117 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h7A000000;

    #10 $fwrite(outfile,"\n2**116 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h79800000;

    #10 $fwrite(outfile,"\n2**115 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h79000000;

    #10 $fwrite(outfile,"\n2**114 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h78800000;

    #10 $fwrite(outfile,"\n2**113 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h78000000;

    #10 $fwrite(outfile,"\n2**112 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h77800000;

    #10 $fwrite(outfile,"\n2**111 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h77000000;

    #10 $fwrite(outfile,"\n2**110 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h76800000;

    #10 $fwrite(outfile,"\n2**109 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h76000000;

    #10 $fwrite(outfile,"\n2**108 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h75800000;

    #10 $fwrite(outfile,"\n2**107 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h75000000;

    #10 $fwrite(outfile,"\n2**106 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h74800000;

    #10 $fwrite(outfile,"\n2**105 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h74000000;

    #10 $fwrite(outfile,"\n2**104 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h73800000;

    #10 $fwrite(outfile,"\n2**103 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h73000000;

    #10 $fwrite(outfile,"\n2**102 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h72800000;

    #10 $fwrite(outfile,"\n2**101 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h72000000;

    #10 $fwrite(outfile,"\n2**100 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h71800000;

    #10 $fwrite(outfile,"\n2**99 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h71000000;

    #10 $fwrite(outfile,"\n2**98 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h70800000;

    #10 $fwrite(outfile,"\n2**97 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h70000000;

    #10 $fwrite(outfile,"\n2**96 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6F800000;

    #10 $fwrite(outfile,"\n2**95 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6F000000;

    #10 $fwrite(outfile,"\n2**94 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6E800000;

    #10 $fwrite(outfile,"\n2**93 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6E000000;

    #10 $fwrite(outfile,"\n2**92 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6D800000;

    #10 $fwrite(outfile,"\n2**91 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6D000000;

    #10 $fwrite(outfile,"\n2**90 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6C800000;

    #10 $fwrite(outfile,"\n2**89 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6C000000;

    #10 $fwrite(outfile,"\n2**88 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6B800000;

    #10 $fwrite(outfile,"\n2**87 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6B000000;

    #10 $fwrite(outfile,"\n2**86 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6A800000;

    #10 $fwrite(outfile,"\n2**85 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h6A000000;

    #10 $fwrite(outfile,"\n2**84 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h69800000;

    #10 $fwrite(outfile,"\n2**83 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h69000000;

    #10 $fwrite(outfile,"\n2**82 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h68800000;

    #10 $fwrite(outfile,"\n2**81 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h68000000;

    #10 $fwrite(outfile,"\n2**80 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h67800000;

    #10 $fwrite(outfile,"\n2**79 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h67000000;

    #10 $fwrite(outfile,"\n2**78 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h66800000;

    #10 $fwrite(outfile,"\n2**77 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h66000000;

    #10 $fwrite(outfile,"\n2**76 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h65800000;

    #10 $fwrite(outfile,"\n2**75 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h65000000;

    #10 $fwrite(outfile,"\n2**74 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h64800000;

    #10 $fwrite(outfile,"\n2**73 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h64000000;

    #10 $fwrite(outfile,"\n2**72 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h63800000;

    #10 $fwrite(outfile,"\n2**71 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h63000000;

    #10 $fwrite(outfile,"\n2**70 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h62800000;

    #10 $fwrite(outfile,"\n2**69 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h62000000;

    #10 $fwrite(outfile,"\n2**68 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h61800000;

    #10 $fwrite(outfile,"\n2**67 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h61000000;

    #10 $fwrite(outfile,"\n2**66 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h60800000;

    #10 $fwrite(outfile,"\n2**65 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h60000000;

    #10 $fwrite(outfile,"\n2**64 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5F800000;

    #10 $fwrite(outfile,"\n2**63 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5F000000;

    #10 $fwrite(outfile,"\n2**62 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5E800000;

    #10 $fwrite(outfile,"\n2**61 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5E000000;

    #10 $fwrite(outfile,"\n2**60 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5D800000;

    #10 $fwrite(outfile,"\n2**59 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5D000000;

    #10 $fwrite(outfile,"\n2**58 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5C800000;

    #10 $fwrite(outfile,"\n2**57 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5C000000;

    #10 $fwrite(outfile,"\n2**56 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5B800000;

    #10 $fwrite(outfile,"\n2**55 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5B000000;

    #10 $fwrite(outfile,"\n2**54 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5A800000;

    #10 $fwrite(outfile,"\n2**53 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h5A000000;

    #10 $fwrite(outfile,"\n2**52 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h59800000;

    #10 $fwrite(outfile,"\n2**51 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h59000000;

    #10 $fwrite(outfile,"\n2**50 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h58800000;

    #10 $fwrite(outfile,"\n2**49 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h58000000;

    #10 $fwrite(outfile,"\n2**48 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h57800000;

    #10 $fwrite(outfile,"\n2**47 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h57000000;

    #10 $fwrite(outfile,"\n2**46 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h56800000;

    #10 $fwrite(outfile,"\n2**45 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h56000000;

    #10 $fwrite(outfile,"\n2**44 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h55800000;

    #10 $fwrite(outfile,"\n2**43 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h55000000;

    #10 $fwrite(outfile,"\n2**42 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h54800000;

    #10 $fwrite(outfile,"\n2**41 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h54000000;

    #10 $fwrite(outfile,"\n2**40 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h53800000;

    #10 $fwrite(outfile,"\n2**39 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h53000000;

    #10 $fwrite(outfile,"\n2**38 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h52800000;

    #10 $fwrite(outfile,"\n2**37 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h52000000;

    #10 $fwrite(outfile,"\n2**36 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h51800000;

    #10 $fwrite(outfile,"\n2**35 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h51000000;

    #10 $fwrite(outfile,"\n2**34 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h50800000;

    #10 $fwrite(outfile,"\n2**33 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h50000000;

    #10 $fwrite(outfile,"\n2**32 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4F800000;

    #10 $fwrite(outfile,"\n2**31 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4F000000;

    #10 $fwrite(outfile,"\n2**30 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4E800000;

    #10 $fwrite(outfile,"\n2**29 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4E000000;

    #10 $fwrite(outfile,"\n2**28 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4D800000;

    #10 $fwrite(outfile,"\n2**27 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4D000000;

    #10 $fwrite(outfile,"\n2**26 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4C800000;

    #10 $fwrite(outfile,"\n2**25 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4C000000;

    #10 $fwrite(outfile,"\n2**24 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4B800000;

    #10 $fwrite(outfile,"\n2**23 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4B000000;

    #10 $fwrite(outfile,"\n2**22 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4A800000;

    #10 $fwrite(outfile,"\n2**21 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h4A000000;

    #10 $fwrite(outfile,"\n2**20 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h49800000;

    #10 $fwrite(outfile,"\n2**19 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h49000000;

    #10 $fwrite(outfile,"\n2**18 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h48800000;

    #10 $fwrite(outfile,"\n2**17 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h48000000;

    #10 $fwrite(outfile,"\n2**16 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h47800000;

    #10 $fwrite(outfile,"\n2**15 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h47000000;

    #10 $fwrite(outfile,"\n2**14 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h46800000;

    #10 $fwrite(outfile,"\n2**13 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h46000000;

    #10 $fwrite(outfile,"\n2**12 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h45800000;

    #10 $fwrite(outfile,"\n2**11 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h45000000;

    #10 $fwrite(outfile,"\n2**10 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h44800000;

    #10 $fwrite(outfile,"\n2**9 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h44000000;

    #10 $fwrite(outfile,"\n2**8 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h43800000;

    #10 $fwrite(outfile,"\n2**7 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h43000000;

    #10 $fwrite(outfile,"\n2**6 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h42800000;

    #10 $fwrite(outfile,"\n2**5 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h42000000;

    #10 $fwrite(outfile,"\n2**4 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h41800000;

    #10 $fwrite(outfile,"\n2**3 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h41000000;

    #10 $fwrite(outfile,"\n2**2 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h40800000;

    #10 $fwrite(outfile,"\n2**1 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h40000000;

    #10 $fwrite(outfile,"\n2**0 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3F800000;

    #10 $fwrite(outfile,"\n2**-1 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3F000000;

    #10 $fwrite(outfile,"\n2**-2 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3E800000;

    #10 $fwrite(outfile,"\n2**-3 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3E000000;

    #10 $fwrite(outfile,"\n2**-4 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3D800000;

    #10 $fwrite(outfile,"\n2**-5 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3D000000;

    #10 $fwrite(outfile,"\n2**-6 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3C800000;

    #10 $fwrite(outfile,"\n2**-7 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3C000000;

    #10 $fwrite(outfile,"\n2**-8 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3B800000;

    #10 $fwrite(outfile,"\n2**-9 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3B000000;

    #10 $fwrite(outfile,"\n2**-10 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3A800000;

    #10 $fwrite(outfile,"\n2**-11 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h3A000000;

    #10 $fwrite(outfile,"\n2**-12 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h39800000;

    #10 $fwrite(outfile,"\n2**-13 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h39000000;

    #10 $fwrite(outfile,"\n2**-14 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h38800000;

    #10 $fwrite(outfile,"\n2**-15 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h38000000;

    #10 $fwrite(outfile,"\n2**-16 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h37800000;

    #10 $fwrite(outfile,"\n2**-17 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h37000000;

    #10 $fwrite(outfile,"\n2**-18 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h36800000;

    #10 $fwrite(outfile,"\n2**-19 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h36000000;

    #10 $fwrite(outfile,"\n2**-20 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h35800000;

    #10 $fwrite(outfile,"\n2**-21 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h35000000;

    #10 $fwrite(outfile,"\n2**-22 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h34800000;

    #10 $fwrite(outfile,"\n2**-23 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h34000000;

    #10 $fwrite(outfile,"\n2**-24 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h33800000;

    #10 $fwrite(outfile,"\n2**-25 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h33000000;

    #10 $fwrite(outfile,"\n2**-26 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h32800000;

    #10 $fwrite(outfile,"\n2**-27 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h32000000;

    #10 $fwrite(outfile,"\n2**-28 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h31800000;

    #10 $fwrite(outfile,"\n2**-29 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h31000000;

    #10 $fwrite(outfile,"\n2**-30 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h30800000;

    #10 $fwrite(outfile,"\n2**-31 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h30000000;

    #10 $fwrite(outfile,"\n2**-32 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2F800000;

    #10 $fwrite(outfile,"\n2**-33 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2F000000;

    #10 $fwrite(outfile,"\n2**-34 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2E800000;

    #10 $fwrite(outfile,"\n2**-35 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2E000000;

    #10 $fwrite(outfile,"\n2**-36 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2D800000;

    #10 $fwrite(outfile,"\n2**-37 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2D000000;

    #10 $fwrite(outfile,"\n2**-38 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2C800000;

    #10 $fwrite(outfile,"\n2**-39 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2C000000;

    #10 $fwrite(outfile,"\n2**-40 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2B800000;

    #10 $fwrite(outfile,"\n2**-41 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2B000000;

    #10 $fwrite(outfile,"\n2**-42 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2A800000;

    #10 $fwrite(outfile,"\n2**-43 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h2A000000;

    #10 $fwrite(outfile,"\n2**-44 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h29800000;

    #10 $fwrite(outfile,"\n2**-45 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h29000000;

    #10 $fwrite(outfile,"\n2**-46 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h28800000;

    #10 $fwrite(outfile,"\n2**-47 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h28000000;

    #10 $fwrite(outfile,"\n2**-48 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h27800000;

    #10 $fwrite(outfile,"\n2**-49 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h27000000;

    #10 $fwrite(outfile,"\n2**-50 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h26800000;

    #10 $fwrite(outfile,"\n2**-51 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h26000000;

    #10 $fwrite(outfile,"\n2**-52 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h25800000;

    #10 $fwrite(outfile,"\n2**-53 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h25000000;

    #10 $fwrite(outfile,"\n2**-54 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h24800000;

    #10 $fwrite(outfile,"\n2**-55 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h24000000;

    #10 $fwrite(outfile,"\n2**-56 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h23800000;

    #10 $fwrite(outfile,"\n2**-57 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h23000000;

    #10 $fwrite(outfile,"\n2**-58 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h22800000;

    #10 $fwrite(outfile,"\n2**-59 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h22000000;

    #10 $fwrite(outfile,"\n2**-60 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h21800000;

    #10 $fwrite(outfile,"\n2**-61 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h21000000;

    #10 $fwrite(outfile,"\n2**-62 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h20800000;

    #10 $fwrite(outfile,"\n2**-63 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h20000000;

    #10 $fwrite(outfile,"\n2**-64 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1F800000;

    #10 $fwrite(outfile,"\n2**-65 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1F000000;

    #10 $fwrite(outfile,"\n2**-66 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1E800000;

    #10 $fwrite(outfile,"\n2**-67 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1E000000;

    #10 $fwrite(outfile,"\n2**-68 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1D800000;

    #10 $fwrite(outfile,"\n2**-69 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1D000000;

    #10 $fwrite(outfile,"\n2**-70 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1C800000;

    #10 $fwrite(outfile,"\n2**-71 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1C000000;

    #10 $fwrite(outfile,"\n2**-72 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1B800000;

    #10 $fwrite(outfile,"\n2**-73 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1B000000;

    #10 $fwrite(outfile,"\n2**-74 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1A800000;

    #10 $fwrite(outfile,"\n2**-75 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h1A000000;

    #10 $fwrite(outfile,"\n2**-76 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h19800000;

    #10 $fwrite(outfile,"\n2**-77 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h19000000;

    #10 $fwrite(outfile,"\n2**-78 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h18800000;

    #10 $fwrite(outfile,"\n2**-79 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h18000000;

    #10 $fwrite(outfile,"\n2**-80 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h17800000;

    #10 $fwrite(outfile,"\n2**-81 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h17000000;

    #10 $fwrite(outfile,"\n2**-82 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h16800000;

    #10 $fwrite(outfile,"\n2**-83 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h16000000;

    #10 $fwrite(outfile,"\n2**-84 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h15800000;

    #10 $fwrite(outfile,"\n2**-85 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h15000000;

    #10 $fwrite(outfile,"\n2**-86 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h14800000;

    #10 $fwrite(outfile,"\n2**-87 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h14000000;

    #10 $fwrite(outfile,"\n2**-88 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h13800000;

    #10 $fwrite(outfile,"\n2**-89 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h13000000;

    #10 $fwrite(outfile,"\n2**-90 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h12800000;

    #10 $fwrite(outfile,"\n2**-91 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h12000000;

    #10 $fwrite(outfile,"\n2**-92 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h11800000;

    #10 $fwrite(outfile,"\n2**-93 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h11000000;

    #10 $fwrite(outfile,"\n2**-94 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h10800000;

    #10 $fwrite(outfile,"\n2**-95 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h10000000;

    #10 $fwrite(outfile,"\n2**-96 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0F800000;

    #10 $fwrite(outfile,"\n2**-97 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0F000000;

    #10 $fwrite(outfile,"\n2**-98 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0E800000;

    #10 $fwrite(outfile,"\n2**-99 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0E000000;

    #10 $fwrite(outfile,"\n2**-100 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0D800000;

    #10 $fwrite(outfile,"\n2**-101 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0D000000;

    #10 $fwrite(outfile,"\n2**-102 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0C800000;

    #10 $fwrite(outfile,"\n2**-103 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0C000000;

    #10 $fwrite(outfile,"\n2**-104 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0B800000;

    #10 $fwrite(outfile,"\n2**-105 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0B000000;

    #10 $fwrite(outfile,"\n2**-106 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0A800000;

    #10 $fwrite(outfile,"\n2**-107 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h0A000000;

    #10 $fwrite(outfile,"\n2**-108 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h09800000;

    #10 $fwrite(outfile,"\n2**-109 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h09000000;

    #10 $fwrite(outfile,"\n2**-110 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h08800000;

    #10 $fwrite(outfile,"\n2**-111 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h08000000;

    #10 $fwrite(outfile,"\n2**-112 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h07800000;

    #10 $fwrite(outfile,"\n2**-113 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h07000000;

    #10 $fwrite(outfile,"\n2**-114 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h06800000;

    #10 $fwrite(outfile,"\n2**-115 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h06000000;

    #10 $fwrite(outfile,"\n2**-116 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h05800000;

    #10 $fwrite(outfile,"\n2**-117 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h05000000;

    #10 $fwrite(outfile,"\n2**-118 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h04800000;

    #10 $fwrite(outfile,"\n2**-119 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h04000000;

    #10 $fwrite(outfile,"\n2**-120 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h03800000;

    #10 $fwrite(outfile,"\n2**-121 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h03000000;

    #10 $fwrite(outfile,"\n2**-122 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h02800000;

    #10 $fwrite(outfile,"\n2**-123 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h02000000;

    #10 $fwrite(outfile,"\n2**-124 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h01800000;

    #10 $fwrite(outfile,"\n2**-125 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h01000000;

    #10 $fwrite(outfile,"\n2**-126 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00800000;

    #10 $fwrite(outfile,"\n2**-127 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00400000;

    #10 $fwrite(outfile,"\n2**-128 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00200000;

    #10 $fwrite(outfile,"\n2**-129 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00100000;

    #10 $fwrite(outfile,"\n2**-130 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00080000;

    #10 $fwrite(outfile,"\n2**-131 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00040000;

    #10 $fwrite(outfile,"\n2**-132 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00020000;

    #10 $fwrite(outfile,"\n2**-133 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00010000;

    #10 $fwrite(outfile,"\n2**-134 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00008000;

    #10 $fwrite(outfile,"\n2**-135 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00004000;

    #10 $fwrite(outfile,"\n2**-136 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00002000;

    #10 $fwrite(outfile,"\n2**-137 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00001000;

    #10 $fwrite(outfile,"\n2**-138 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000800;

    #10 $fwrite(outfile,"\n2**-139 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000400;

    #10 $fwrite(outfile,"\n2**-140 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000200;

    #10 $fwrite(outfile,"\n2**-141 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000100;

    #10 $fwrite(outfile,"\n2**-142 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000080;

    #10 $fwrite(outfile,"\n2**-143 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000040;

    #10 $fwrite(outfile,"\n2**-144 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000020;

    #10 $fwrite(outfile,"\n2**-145 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000010;

    #10 $fwrite(outfile,"\n2**-146 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000008;

    #10 $fwrite(outfile,"\n2**-147 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000004;

    #10 $fwrite(outfile,"\n2**-148 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000002;

    #10 $fwrite(outfile,"\n2**-149 * 1:");
    #10 assign b = 32'h3F800000; assign a = 32'h00000001;

    #10 $fwrite(outfile,"\n2**0 * 2**127:");
    #10 assign a = 32'h3F800000; assign b = 32'h7F000000;
    #10 assign a = 32'h3FFFFFFF; assign b = 32'h7F7FFFFF;

    #10 $fwrite(outfile,"\n2**1 * 2**126:");
    #10 assign a = 32'h40000000; assign b = 32'h7E800000;
    #10 assign a = 32'h407FFFFF; assign b = 32'h7EFFFFFF;

    #10 $fwrite(outfile,"\n2**2 * 2**125:");
    #10 assign a = 32'h40800000; assign b = 32'h7E000000;
    #10 assign a = 32'h40FFFFFF; assign b = 32'h7E7FFFFF;

    #10 $fwrite(outfile,"\n2**3 * 2**124:");
    #10 assign a = 32'h41000000; assign b = 32'h7D800000;
    #10 assign a = 32'h417FFFFF; assign b = 32'h7DFFFFFF;

    #10 $fwrite(outfile,"\n2**4 * 2**123:");
    #10 assign a = 32'h41800000; assign b = 32'h7D000000;
    #10 assign a = 32'h41FFFFFF; assign b = 32'h7D7FFFFF;

    #10 $fwrite(outfile,"\n2**5 * 2**122:");
    #10 assign a = 32'h42000000; assign b = 32'h7C800000;
    #10 assign a = 32'h427FFFFF; assign b = 32'h7CFFFFFF;

    #10 $fwrite(outfile,"\n2**6 * 2**121:");
    #10 assign a = 32'h42800000; assign b = 32'h7C000000;
    #10 assign a = 32'h42FFFFFF; assign b = 32'h7C7FFFFF;

    #10 $fwrite(outfile,"\n2**7 * 2**120:");
    #10 assign a = 32'h43000000; assign b = 32'h7B800000;
    #10 assign a = 32'h437FFFFF; assign b = 32'h7BFFFFFF;

    #10 $fwrite(outfile,"\n2**8 * 2**119:");
    #10 assign a = 32'h43800000; assign b = 32'h7B000000;
    #10 assign a = 32'h43FFFFFF; assign b = 32'h7B7FFFFF;

    #10 $fwrite(outfile,"\n2**9 * 2**118:");
    #10 assign a = 32'h44000000; assign b = 32'h7A800000;
    #10 assign a = 32'h447FFFFF; assign b = 32'h7AFFFFFF;

    #10 $fwrite(outfile,"\n2**10 * 2**117:");
    #10 assign a = 32'h44800000; assign b = 32'h7A000000;
    #10 assign a = 32'h44FFFFFF; assign b = 32'h7A7FFFFF;

    #10 $fwrite(outfile,"\n2**11 * 2**116:");
    #10 assign a = 32'h45000000; assign b = 32'h79800000;
    #10 assign a = 32'h457FFFFF; assign b = 32'h79FFFFFF;

    #10 $fwrite(outfile,"\n2**12 * 2**115:");
    #10 assign a = 32'h45800000; assign b = 32'h79000000;
    #10 assign a = 32'h45FFFFFF; assign b = 32'h797FFFFF;

    #10 $fwrite(outfile,"\n2**13 * 2**114:");
    #10 assign a = 32'h46000000; assign b = 32'h78800000;
    #10 assign a = 32'h467FFFFF; assign b = 32'h78FFFFFF;

    #10 $fwrite(outfile,"\n2**14 * 2**113:");
    #10 assign a = 32'h46800000; assign b = 32'h78000000;
    #10 assign a = 32'h46FFFFFF; assign b = 32'h787FFFFF;

    #10 $fwrite(outfile,"\n2**15 * 2**112:");
    #10 assign a = 32'h47000000; assign b = 32'h77800000;
    #10 assign a = 32'h477FFFFF; assign b = 32'h77FFFFFF;

    #10 $fwrite(outfile,"\n2**16 * 2**111:");
    #10 assign a = 32'h47800000; assign b = 32'h77000000;
    #10 assign a = 32'h47FFFFFF; assign b = 32'h777FFFFF;

    #10 $fwrite(outfile,"\n2**17 * 2**110:");
    #10 assign a = 32'h48000000; assign b = 32'h76800000;
    #10 assign a = 32'h487FFFFF; assign b = 32'h76FFFFFF;

    #10 $fwrite(outfile,"\n2**18 * 2**109:");
    #10 assign a = 32'h48800000; assign b = 32'h76000000;
    #10 assign a = 32'h48FFFFFF; assign b = 32'h767FFFFF;

    #10 $fwrite(outfile,"\n2**19 * 2**108:");
    #10 assign a = 32'h49000000; assign b = 32'h75800000;
    #10 assign a = 32'h497FFFFF; assign b = 32'h75FFFFFF;

    #10 $fwrite(outfile,"\n2**20 * 2**107:");
    #10 assign a = 32'h49800000; assign b = 32'h75000000;
    #10 assign a = 32'h49FFFFFF; assign b = 32'h757FFFFF;

    #10 $fwrite(outfile,"\n2**21 * 2**106:");
    #10 assign a = 32'h4A000000; assign b = 32'h74800000;
    #10 assign a = 32'h4A7FFFFF; assign b = 32'h74FFFFFF;

    #10 $fwrite(outfile,"\n2**22 * 2**105:");
    #10 assign a = 32'h4A800000; assign b = 32'h74000000;
    #10 assign a = 32'h4AFFFFFF; assign b = 32'h747FFFFF;

    #10 $fwrite(outfile,"\n2**23 * 2**104:");
    #10 assign a = 32'h4B000000; assign b = 32'h73800000;
    #10 assign a = 32'h4B7FFFFF; assign b = 32'h73FFFFFF;

    #10 $fwrite(outfile,"\n2**24 * 2**103:");
    #10 assign a = 32'h4B800000; assign b = 32'h73000000;
    #10 assign a = 32'h4BFFFFFF; assign b = 32'h737FFFFF;

    #10 $fwrite(outfile,"\n2**25 * 2**102:");
    #10 assign a = 32'h4C000000; assign b = 32'h72800000;
    #10 assign a = 32'h4C7FFFFF; assign b = 32'h72FFFFFF;

    #10 $fwrite(outfile,"\n2**26 * 2**101:");
    #10 assign a = 32'h4C800000; assign b = 32'h72000000;
    #10 assign a = 32'h4CFFFFFF; assign b = 32'h727FFFFF;

    #10 $fwrite(outfile,"\n2**27 * 2**100:");
    #10 assign a = 32'h4D000000; assign b = 32'h71800000;
    #10 assign a = 32'h4D7FFFFF; assign b = 32'h71FFFFFF;

    #10 $fwrite(outfile,"\n2**28 * 2**99:");
    #10 assign a = 32'h4D800000; assign b = 32'h71000000;
    #10 assign a = 32'h4DFFFFFF; assign b = 32'h717FFFFF;

    #10 $fwrite(outfile,"\n2**29 * 2**98:");
    #10 assign a = 32'h4E000000; assign b = 32'h70800000;
    #10 assign a = 32'h4E7FFFFF; assign b = 32'h70FFFFFF;

    #10 $fwrite(outfile,"\n2**30 * 2**97:");
    #10 assign a = 32'h4E800000; assign b = 32'h70000000;
    #10 assign a = 32'h4EFFFFFF; assign b = 32'h707FFFFF;

    #10 $fwrite(outfile,"\n2**31 * 2**96:");
    #10 assign a = 32'h4F000000; assign b = 32'h6F800000;
    #10 assign a = 32'h4F7FFFFF; assign b = 32'h6FFFFFFF;

    #10 $fwrite(outfile,"\n2**32 * 2**95:");
    #10 assign a = 32'h4F800000; assign b = 32'h6F000000;
    #10 assign a = 32'h4FFFFFFF; assign b = 32'h6F7FFFFF;

    #10 $fwrite(outfile,"\n2**33 * 2**94:");
    #10 assign a = 32'h50000000; assign b = 32'h6E800000;
    #10 assign a = 32'h507FFFFF; assign b = 32'h6EFFFFFF;

    #10 $fwrite(outfile,"\n2**34 * 2**93:");
    #10 assign a = 32'h50800000; assign b = 32'h6E000000;
    #10 assign a = 32'h50FFFFFF; assign b = 32'h6E7FFFFF;

    #10 $fwrite(outfile,"\n2**35 * 2**92:");
    #10 assign a = 32'h51000000; assign b = 32'h6D800000;
    #10 assign a = 32'h517FFFFF; assign b = 32'h6DFFFFFF;

    #10 $fwrite(outfile,"\n2**36 * 2**91:");
    #10 assign a = 32'h51800000; assign b = 32'h6D000000;
    #10 assign a = 32'h51FFFFFF; assign b = 32'h6D7FFFFF;

    #10 $fwrite(outfile,"\n2**37 * 2**90:");
    #10 assign a = 32'h52000000; assign b = 32'h6C800000;
    #10 assign a = 32'h527FFFFF; assign b = 32'h6CFFFFFF;

    #10 $fwrite(outfile,"\n2**38 * 2**89:");
    #10 assign a = 32'h52800000; assign b = 32'h6C000000;
    #10 assign a = 32'h52FFFFFF; assign b = 32'h6C7FFFFF;

    #10 $fwrite(outfile,"\n2**39 * 2**88:");
    #10 assign a = 32'h53000000; assign b = 32'h6B800000;
    #10 assign a = 32'h537FFFFF; assign b = 32'h6BFFFFFF;

    #10 $fwrite(outfile,"\n2**40 * 2**87:");
    #10 assign a = 32'h53800000; assign b = 32'h6B000000;
    #10 assign a = 32'h53FFFFFF; assign b = 32'h6B7FFFFF;

    #10 $fwrite(outfile,"\n2**41 * 2**86:");
    #10 assign a = 32'h54000000; assign b = 32'h6A800000;
    #10 assign a = 32'h547FFFFF; assign b = 32'h6AFFFFFF;

    #10 $fwrite(outfile,"\n2**42 * 2**85:");
    #10 assign a = 32'h54800000; assign b = 32'h6A000000;
    #10 assign a = 32'h54FFFFFF; assign b = 32'h6A7FFFFF;

    #10 $fwrite(outfile,"\n2**43 * 2**84:");
    #10 assign a = 32'h55000000; assign b = 32'h69800000;
    #10 assign a = 32'h557FFFFF; assign b = 32'h69FFFFFF;

    #10 $fwrite(outfile,"\n2**44 * 2**83:");
    #10 assign a = 32'h55800000; assign b = 32'h69000000;
    #10 assign a = 32'h55FFFFFF; assign b = 32'h697FFFFF;

    #10 $fwrite(outfile,"\n2**45 * 2**82:");
    #10 assign a = 32'h56000000; assign b = 32'h68800000;
    #10 assign a = 32'h567FFFFF; assign b = 32'h68FFFFFF;

    #10 $fwrite(outfile,"\n2**46 * 2**81:");
    #10 assign a = 32'h56800000; assign b = 32'h68000000;
    #10 assign a = 32'h56FFFFFF; assign b = 32'h687FFFFF;

    #10 $fwrite(outfile,"\n2**47 * 2**80:");
    #10 assign a = 32'h57000000; assign b = 32'h67800000;
    #10 assign a = 32'h577FFFFF; assign b = 32'h67FFFFFF;

    #10 $fwrite(outfile,"\n2**48 * 2**79:");
    #10 assign a = 32'h57800000; assign b = 32'h67000000;
    #10 assign a = 32'h57FFFFFF; assign b = 32'h677FFFFF;

    #10 $fwrite(outfile,"\n2**49 * 2**78:");
    #10 assign a = 32'h58000000; assign b = 32'h66800000;
    #10 assign a = 32'h587FFFFF; assign b = 32'h66FFFFFF;

    #10 $fwrite(outfile,"\n2**50 * 2**77:");
    #10 assign a = 32'h58800000; assign b = 32'h66000000;
    #10 assign a = 32'h58FFFFFF; assign b = 32'h667FFFFF;

    #10 $fwrite(outfile,"\n2**51 * 2**76:");
    #10 assign a = 32'h59000000; assign b = 32'h65800000;
    #10 assign a = 32'h597FFFFF; assign b = 32'h65FFFFFF;

    #10 $fwrite(outfile,"\n2**52 * 2**75:");
    #10 assign a = 32'h59800000; assign b = 32'h65000000;
    #10 assign a = 32'h59FFFFFF; assign b = 32'h657FFFFF;

    #10 $fwrite(outfile,"\n2**53 * 2**74:");
    #10 assign a = 32'h5A000000; assign b = 32'h64800000;
    #10 assign a = 32'h5A7FFFFF; assign b = 32'h64FFFFFF;

    #10 $fwrite(outfile,"\n2**54 * 2**73:");
    #10 assign a = 32'h5A800000; assign b = 32'h64000000;
    #10 assign a = 32'h5AFFFFFF; assign b = 32'h647FFFFF;

    #10 $fwrite(outfile,"\n2**55 * 2**72:");
    #10 assign a = 32'h5B000000; assign b = 32'h63800000;
    #10 assign a = 32'h5B7FFFFF; assign b = 32'h63FFFFFF;

    #10 $fwrite(outfile,"\n2**56 * 2**71:");
    #10 assign a = 32'h5B800000; assign b = 32'h63000000;
    #10 assign a = 32'h5BFFFFFF; assign b = 32'h637FFFFF;

    #10 $fwrite(outfile,"\n2**57 * 2**70:");
    #10 assign a = 32'h5C000000; assign b = 32'h62800000;
    #10 assign a = 32'h5C7FFFFF; assign b = 32'h62FFFFFF;

    #10 $fwrite(outfile,"\n2**58 * 2**69:");
    #10 assign a = 32'h5C800000; assign b = 32'h62000000;
    #10 assign a = 32'h5CFFFFFF; assign b = 32'h627FFFFF;

    #10 $fwrite(outfile,"\n2**59 * 2**68:");
    #10 assign a = 32'h5D000000; assign b = 32'h61800000;
    #10 assign a = 32'h5D7FFFFF; assign b = 32'h61FFFFFF;

    #10 $fwrite(outfile,"\n2**60 * 2**67:");
    #10 assign a = 32'h5D800000; assign b = 32'h61000000;
    #10 assign a = 32'h5DFFFFFF; assign b = 32'h617FFFFF;

    #10 $fwrite(outfile,"\n2**61 * 2**66:");
    #10 assign a = 32'h5E000000; assign b = 32'h60800000;
    #10 assign a = 32'h5E7FFFFF; assign b = 32'h60FFFFFF;

    #10 $fwrite(outfile,"\n2**62 * 2**65:");
    #10 assign a = 32'h5E800000; assign b = 32'h60000000;
    #10 assign a = 32'h5EFFFFFF; assign b = 32'h607FFFFF;

    #10 $fwrite(outfile,"\n2**63 * 2**64:");
    #10 assign a = 32'h5F000000; assign b = 32'h5F800000;
    #10 assign a = 32'h5F7FFFFF; assign b = 32'h5FFFFFFF;

    #10 $fwrite(outfile,"\n2**64 * 2**63:");
    #10 assign a = 32'h5F800000; assign b = 32'h5F000000;
    #10 assign a = 32'h5FFFFFFF; assign b = 32'h5F7FFFFF;

    #10 $fwrite(outfile,"\n2**65 * 2**62:");
    #10 assign a = 32'h60000000; assign b = 32'h5E800000;
    #10 assign a = 32'h607FFFFF; assign b = 32'h5EFFFFFF;

    #10 $fwrite(outfile,"\n2**66 * 2**61:");
    #10 assign a = 32'h60800000; assign b = 32'h5E000000;
    #10 assign a = 32'h60FFFFFF; assign b = 32'h5E7FFFFF;

    #10 $fwrite(outfile,"\n2**67 * 2**60:");
    #10 assign a = 32'h61000000; assign b = 32'h5D800000;
    #10 assign a = 32'h617FFFFF; assign b = 32'h5DFFFFFF;

    #10 $fwrite(outfile,"\n2**68 * 2**59:");
    #10 assign a = 32'h61800000; assign b = 32'h5D000000;
    #10 assign a = 32'h61FFFFFF; assign b = 32'h5D7FFFFF;

    #10 $fwrite(outfile,"\n2**69 * 2**58:");
    #10 assign a = 32'h62000000; assign b = 32'h5C800000;
    #10 assign a = 32'h627FFFFF; assign b = 32'h5CFFFFFF;

    #10 $fwrite(outfile,"\n2**70 * 2**57:");
    #10 assign a = 32'h62800000; assign b = 32'h5C000000;
    #10 assign a = 32'h62FFFFFF; assign b = 32'h5C7FFFFF;

    #10 $fwrite(outfile,"\n2**71 * 2**56:");
    #10 assign a = 32'h63000000; assign b = 32'h5B800000;
    #10 assign a = 32'h637FFFFF; assign b = 32'h5BFFFFFF;

    #10 $fwrite(outfile,"\n2**72 * 2**55:");
    #10 assign a = 32'h63800000; assign b = 32'h5B000000;
    #10 assign a = 32'h63FFFFFF; assign b = 32'h5B7FFFFF;

    #10 $fwrite(outfile,"\n2**73 * 2**54:");
    #10 assign a = 32'h64000000; assign b = 32'h5A800000;
    #10 assign a = 32'h647FFFFF; assign b = 32'h5AFFFFFF;

    #10 $fwrite(outfile,"\n2**74 * 2**53:");
    #10 assign a = 32'h64800000; assign b = 32'h5A000000;
    #10 assign a = 32'h64FFFFFF; assign b = 32'h5A7FFFFF;

    #10 $fwrite(outfile,"\n2**75 * 2**52:");
    #10 assign a = 32'h65000000; assign b = 32'h59800000;
    #10 assign a = 32'h657FFFFF; assign b = 32'h59FFFFFF;

    #10 $fwrite(outfile,"\n2**76 * 2**51:");
    #10 assign a = 32'h65800000; assign b = 32'h59000000;
    #10 assign a = 32'h65FFFFFF; assign b = 32'h597FFFFF;

    #10 $fwrite(outfile,"\n2**77 * 2**50:");
    #10 assign a = 32'h66000000; assign b = 32'h58800000;
    #10 assign a = 32'h667FFFFF; assign b = 32'h58FFFFFF;

    #10 $fwrite(outfile,"\n2**78 * 2**49:");
    #10 assign a = 32'h66800000; assign b = 32'h58000000;
    #10 assign a = 32'h66FFFFFF; assign b = 32'h587FFFFF;

    #10 $fwrite(outfile,"\n2**79 * 2**48:");
    #10 assign a = 32'h67000000; assign b = 32'h57800000;
    #10 assign a = 32'h677FFFFF; assign b = 32'h57FFFFFF;

    #10 $fwrite(outfile,"\n2**80 * 2**47:");
    #10 assign a = 32'h67800000; assign b = 32'h57000000;
    #10 assign a = 32'h67FFFFFF; assign b = 32'h577FFFFF;

    #10 $fwrite(outfile,"\n2**81 * 2**46:");
    #10 assign a = 32'h68000000; assign b = 32'h56800000;
    #10 assign a = 32'h687FFFFF; assign b = 32'h56FFFFFF;

    #10 $fwrite(outfile,"\n2**82 * 2**45:");
    #10 assign a = 32'h68800000; assign b = 32'h56000000;
    #10 assign a = 32'h68FFFFFF; assign b = 32'h567FFFFF;

    #10 $fwrite(outfile,"\n2**83 * 2**44:");
    #10 assign a = 32'h69000000; assign b = 32'h55800000;
    #10 assign a = 32'h697FFFFF; assign b = 32'h55FFFFFF;

    #10 $fwrite(outfile,"\n2**84 * 2**43:");
    #10 assign a = 32'h69800000; assign b = 32'h55000000;
    #10 assign a = 32'h69FFFFFF; assign b = 32'h557FFFFF;

    #10 $fwrite(outfile,"\n2**85 * 2**42:");
    #10 assign a = 32'h6A000000; assign b = 32'h54800000;
    #10 assign a = 32'h6A7FFFFF; assign b = 32'h54FFFFFF;

    #10 $fwrite(outfile,"\n2**86 * 2**41:");
    #10 assign a = 32'h6A800000; assign b = 32'h54000000;
    #10 assign a = 32'h6AFFFFFF; assign b = 32'h547FFFFF;

    #10 $fwrite(outfile,"\n2**87 * 2**40:");
    #10 assign a = 32'h6B000000; assign b = 32'h53800000;
    #10 assign a = 32'h6B7FFFFF; assign b = 32'h53FFFFFF;

    #10 $fwrite(outfile,"\n2**88 * 2**39:");
    #10 assign a = 32'h6B800000; assign b = 32'h53000000;
    #10 assign a = 32'h6BFFFFFF; assign b = 32'h537FFFFF;

    #10 $fwrite(outfile,"\n2**89 * 2**38:");
    #10 assign a = 32'h6C000000; assign b = 32'h52800000;
    #10 assign a = 32'h6C7FFFFF; assign b = 32'h52FFFFFF;

    #10 $fwrite(outfile,"\n2**90 * 2**37:");
    #10 assign a = 32'h6C800000; assign b = 32'h52000000;
    #10 assign a = 32'h6CFFFFFF; assign b = 32'h527FFFFF;

    #10 $fwrite(outfile,"\n2**91 * 2**36:");
    #10 assign a = 32'h6D000000; assign b = 32'h51800000;
    #10 assign a = 32'h6D7FFFFF; assign b = 32'h51FFFFFF;

    #10 $fwrite(outfile,"\n2**92 * 2**35:");
    #10 assign a = 32'h6D800000; assign b = 32'h51000000;
    #10 assign a = 32'h6DFFFFFF; assign b = 32'h517FFFFF;

    #10 $fwrite(outfile,"\n2**93 * 2**34:");
    #10 assign a = 32'h6E000000; assign b = 32'h50800000;
    #10 assign a = 32'h6E7FFFFF; assign b = 32'h50FFFFFF;

    #10 $fwrite(outfile,"\n2**94 * 2**33:");
    #10 assign a = 32'h6E800000; assign b = 32'h50000000;
    #10 assign a = 32'h6EFFFFFF; assign b = 32'h507FFFFF;

    #10 $fwrite(outfile,"\n2**95 * 2**32:");
    #10 assign a = 32'h6F000000; assign b = 32'h4F800000;
    #10 assign a = 32'h6F7FFFFF; assign b = 32'h4FFFFFFF;

    #10 $fwrite(outfile,"\n2**96 * 2**31:");
    #10 assign a = 32'h6F800000; assign b = 32'h4F000000;
    #10 assign a = 32'h6FFFFFFF; assign b = 32'h4F7FFFFF;

    #10 $fwrite(outfile,"\n2**97 * 2**30:");
    #10 assign a = 32'h70000000; assign b = 32'h4E800000;
    #10 assign a = 32'h707FFFFF; assign b = 32'h4EFFFFFF;

    #10 $fwrite(outfile,"\n2**98 * 2**29:");
    #10 assign a = 32'h70800000; assign b = 32'h4E000000;
    #10 assign a = 32'h70FFFFFF; assign b = 32'h4E7FFFFF;

    #10 $fwrite(outfile,"\n2**99 * 2**28:");
    #10 assign a = 32'h71000000; assign b = 32'h4D800000;
    #10 assign a = 32'h717FFFFF; assign b = 32'h4DFFFFFF;

    #10 $fwrite(outfile,"\n2**100 * 2**27:");
    #10 assign a = 32'h71800000; assign b = 32'h4D000000;
    #10 assign a = 32'h71FFFFFF; assign b = 32'h4D7FFFFF;

    #10 $fwrite(outfile,"\n2**101 * 2**26:");
    #10 assign a = 32'h72000000; assign b = 32'h4C800000;
    #10 assign a = 32'h727FFFFF; assign b = 32'h4CFFFFFF;

    #10 $fwrite(outfile,"\n2**102 * 2**25:");
    #10 assign a = 32'h72800000; assign b = 32'h4C000000;
    #10 assign a = 32'h72FFFFFF; assign b = 32'h4C7FFFFF;

    #10 $fwrite(outfile,"\n2**103 * 2**24:");
    #10 assign a = 32'h73000000; assign b = 32'h4B800000;
    #10 assign a = 32'h737FFFFF; assign b = 32'h4BFFFFFF;

    #10 $fwrite(outfile,"\n2**104 * 2**23:");
    #10 assign a = 32'h73800000; assign b = 32'h4B000000;
    #10 assign a = 32'h73FFFFFF; assign b = 32'h4B7FFFFF;

    #10 $fwrite(outfile,"\n2**105 * 2**22:");
    #10 assign a = 32'h74000000; assign b = 32'h4A800000;
    #10 assign a = 32'h747FFFFF; assign b = 32'h4AFFFFFF;

    #10 $fwrite(outfile,"\n2**106 * 2**21:");
    #10 assign a = 32'h74800000; assign b = 32'h4A000000;
    #10 assign a = 32'h74FFFFFF; assign b = 32'h4A7FFFFF;

    #10 $fwrite(outfile,"\n2**107 * 2**20:");
    #10 assign a = 32'h75000000; assign b = 32'h49800000;
    #10 assign a = 32'h757FFFFF; assign b = 32'h49FFFFFF;

    #10 $fwrite(outfile,"\n2**108 * 2**19:");
    #10 assign a = 32'h75800000; assign b = 32'h49000000;
    #10 assign a = 32'h75FFFFFF; assign b = 32'h497FFFFF;

    #10 $fwrite(outfile,"\n2**109 * 2**18:");
    #10 assign a = 32'h76000000; assign b = 32'h48800000;
    #10 assign a = 32'h767FFFFF; assign b = 32'h48FFFFFF;

    #10 $fwrite(outfile,"\n2**110 * 2**17:");
    #10 assign a = 32'h76800000; assign b = 32'h48000000;
    #10 assign a = 32'h76FFFFFF; assign b = 32'h487FFFFF;

    #10 $fwrite(outfile,"\n2**111 * 2**16:");
    #10 assign a = 32'h77000000; assign b = 32'h47800000;
    #10 assign a = 32'h777FFFFF; assign b = 32'h47FFFFFF;

    #10 $fwrite(outfile,"\n2**112 * 2**15:");
    #10 assign a = 32'h77800000; assign b = 32'h47000000;
    #10 assign a = 32'h77FFFFFF; assign b = 32'h477FFFFF;

    #10 $fwrite(outfile,"\n2**113 * 2**14:");
    #10 assign a = 32'h78000000; assign b = 32'h46800000;
    #10 assign a = 32'h787FFFFF; assign b = 32'h46FFFFFF;

    #10 $fwrite(outfile,"\n2**114 * 2**13:");
    #10 assign a = 32'h78800000; assign b = 32'h46000000;
    #10 assign a = 32'h78FFFFFF; assign b = 32'h467FFFFF;

    #10 $fwrite(outfile,"\n2**115 * 2**12:");
    #10 assign a = 32'h79000000; assign b = 32'h45800000;
    #10 assign a = 32'h797FFFFF; assign b = 32'h45FFFFFF;

    #10 $fwrite(outfile,"\n2**116 * 2**11:");
    #10 assign a = 32'h79800000; assign b = 32'h45000000;
    #10 assign a = 32'h79FFFFFF; assign b = 32'h457FFFFF;

    #10 $fwrite(outfile,"\n2**117 * 2**10:");
    #10 assign a = 32'h7A000000; assign b = 32'h44800000;
    #10 assign a = 32'h7A7FFFFF; assign b = 32'h44FFFFFF;

    #10 $fwrite(outfile,"\n2**118 * 2**9:");
    #10 assign a = 32'h7A800000; assign b = 32'h44000000;
    #10 assign a = 32'h7AFFFFFF; assign b = 32'h447FFFFF;

    #10 $fwrite(outfile,"\n2**119 * 2**8:");
    #10 assign a = 32'h7B000000; assign b = 32'h43800000;
    #10 assign a = 32'h7B7FFFFF; assign b = 32'h43FFFFFF;

    #10 $fwrite(outfile,"\n2**120 * 2**7:");
    #10 assign a = 32'h7B800000; assign b = 32'h43000000;
    #10 assign a = 32'h7BFFFFFF; assign b = 32'h437FFFFF;

    #10 $fwrite(outfile,"\n2**121 * 2**6:");
    #10 assign a = 32'h7C000000; assign b = 32'h42800000;
    #10 assign a = 32'h7C7FFFFF; assign b = 32'h42FFFFFF;

    #10 $fwrite(outfile,"\n2**122 * 2**5:");
    #10 assign a = 32'h7C800000; assign b = 32'h42000000;
    #10 assign a = 32'h7CFFFFFF; assign b = 32'h427FFFFF;

    #10 $fwrite(outfile,"\n2**123 * 2**4:");
    #10 assign a = 32'h7D000000; assign b = 32'h41800000;
    #10 assign a = 32'h7D7FFFFF; assign b = 32'h41FFFFFF;

    #10 $fwrite(outfile,"\n2**124 * 2**3:");
    #10 assign a = 32'h7D800000; assign b = 32'h41000000;
    #10 assign a = 32'h7DFFFFFF; assign b = 32'h417FFFFF;

    #10 $fwrite(outfile,"\n2**125 * 2**2:");
    #10 assign a = 32'h7E000000; assign b = 32'h40800000;
    #10 assign a = 32'h7E7FFFFF; assign b = 32'h40FFFFFF;

    #10 $fwrite(outfile,"\n2**126 * 2**1:");
    #10 assign a = 32'h7E800000; assign b = 32'h40000000;
    #10 assign a = 32'h7EFFFFFF; assign b = 32'h407FFFFF;

    #10 $fwrite(outfile,"\n2**127 * 2**0:");
    #10 assign a = 32'h7F000000; assign b = 32'h3F800000;
    #10 assign a = 32'h7F7FFFFF; assign b = 32'h3FFFFFFF;

    #10 $fwrite(outfile,"\n2**-149 * 2**22:");
    #10 assign a = 32'h00000001; assign b = 32'h4A800000;
    #10 assign a = 32'h00000001; assign b = 32'h4AFFFFFF;

    #10 $fwrite(outfile,"\n2**-148 * 2**21:");
    #10 assign a = 32'h00000002; assign b = 32'h4A000000;
    #10 assign a = 32'h00000003; assign b = 32'h4A7FFFFF;

    #10 $fwrite(outfile,"\n2**-147 * 2**20:");
    #10 assign a = 32'h00000004; assign b = 32'h49800000;
    #10 assign a = 32'h00000007; assign b = 32'h49FFFFFF;

    #10 $fwrite(outfile,"\n2**-146 * 2**19:");
    #10 assign a = 32'h00000008; assign b = 32'h49000000;
    #10 assign a = 32'h0000000F; assign b = 32'h497FFFFF;

    #10 $fwrite(outfile,"\n2**-145 * 2**18:");
    #10 assign a = 32'h00000010; assign b = 32'h48800000;
    #10 assign a = 32'h0000001F; assign b = 32'h48FFFFFF;

    #10 $fwrite(outfile,"\n2**-144 * 2**17:");
    #10 assign a = 32'h00000020; assign b = 32'h48000000;
    #10 assign a = 32'h0000003F; assign b = 32'h487FFFFF;

    #10 $fwrite(outfile,"\n2**-143 * 2**16:");
    #10 assign a = 32'h00000040; assign b = 32'h47800000;
    #10 assign a = 32'h0000007F; assign b = 32'h47FFFFFF;

    #10 $fwrite(outfile,"\n2**-142 * 2**15:");
    #10 assign a = 32'h00000080; assign b = 32'h47000000;
    #10 assign a = 32'h000000FF; assign b = 32'h477FFFFF;

    #10 $fwrite(outfile,"\n2**-141 * 2**14:");
    #10 assign a = 32'h00000100; assign b = 32'h46800000;
    #10 assign a = 32'h000001FF; assign b = 32'h46FFFFFF;

    #10 $fwrite(outfile,"\n2**-140 * 2**13:");
    #10 assign a = 32'h00000200; assign b = 32'h46000000;
    #10 assign a = 32'h000003FF; assign b = 32'h467FFFFF;

    #10 $fwrite(outfile,"\n2**-139 * 2**12:");
    #10 assign a = 32'h00000400; assign b = 32'h45800000;
    #10 assign a = 32'h000007FF; assign b = 32'h45FFFFFF;

    #10 $fwrite(outfile,"\n2**-138 * 2**11:");
    #10 assign a = 32'h00000800; assign b = 32'h45000000;
    #10 assign a = 32'h00000FFF; assign b = 32'h457FFFFF;

    #10 $fwrite(outfile,"\n2**-137 * 2**10:");
    #10 assign a = 32'h00001000; assign b = 32'h44800000;
    #10 assign a = 32'h00001FFF; assign b = 32'h44FFFFFF;

    #10 $fwrite(outfile,"\n2**-136 * 2**9:");
    #10 assign a = 32'h00002000; assign b = 32'h44000000;
    #10 assign a = 32'h00003FFF; assign b = 32'h447FFFFF;

    #10 $fwrite(outfile,"\n2**-135 * 2**8:");
    #10 assign a = 32'h00004000; assign b = 32'h43800000;
    #10 assign a = 32'h00007FFF; assign b = 32'h43FFFFFF;

    #10 $fwrite(outfile,"\n2**-134 * 2**7:");
    #10 assign a = 32'h00008000; assign b = 32'h43000000;
    #10 assign a = 32'h0000FFFF; assign b = 32'h437FFFFF;

    #10 $fwrite(outfile,"\n2**-133 * 2**6:");
    #10 assign a = 32'h00010000; assign b = 32'h42800000;
    #10 assign a = 32'h0001FFFF; assign b = 32'h42FFFFFF;

    #10 $fwrite(outfile,"\n2**-132 * 2**5:");
    #10 assign a = 32'h00020000; assign b = 32'h42000000;
    #10 assign a = 32'h0003FFFF; assign b = 32'h427FFFFF;

    #10 $fwrite(outfile,"\n2**-131 * 2**4:");
    #10 assign a = 32'h00040000; assign b = 32'h41800000;
    #10 assign a = 32'h0007FFFF; assign b = 32'h41FFFFFF;

    #10 $fwrite(outfile,"\n2**-130 * 2**3:");
    #10 assign a = 32'h00080000; assign b = 32'h41000000;
    #10 assign a = 32'h000FFFFF; assign b = 32'h417FFFFF;

    #10 $fwrite(outfile,"\n2**-129 * 2**2:");
    #10 assign a = 32'h00100000; assign b = 32'h40800000;
    #10 assign a = 32'h001FFFFF; assign b = 32'h40FFFFFF;

    #10 $fwrite(outfile,"\n2**-128 * 2**1:");
    #10 assign a = 32'h00200000; assign b = 32'h40000000;
    #10 assign a = 32'h003FFFFF; assign b = 32'h407FFFFF;

    #10 $fwrite(outfile,"\n2**-127 * 2**0:");
    #10 assign a = 32'h00400000; assign b = 32'h3F800000;
    #10 assign a = 32'h007FFFFF; assign b = 32'h3FFFFFFF;

    #10 $fwrite(outfile,"\n2**-126 * 2**-1:");
    #10 assign a = 32'h00800000; assign b = 32'h3F000000;
    #10 assign a = 32'h00FFFFFF; assign b = 32'h3F7FFFFF;

    #10 $fwrite(outfile,"\n2**-125 * 2**-2:");
    #10 assign a = 32'h01000000; assign b = 32'h3E800000;
    #10 assign a = 32'h017FFFFF; assign b = 32'h3EFFFFFF;

    #10 $fwrite(outfile,"\n2**-124 * 2**-3:");
    #10 assign a = 32'h01800000; assign b = 32'h3E000000;
    #10 assign a = 32'h01FFFFFF; assign b = 32'h3E7FFFFF;

    #10 $fwrite(outfile,"\n2**-123 * 2**-4:");
    #10 assign a = 32'h02000000; assign b = 32'h3D800000;
    #10 assign a = 32'h027FFFFF; assign b = 32'h3DFFFFFF;

    #10 $fwrite(outfile,"\n2**-122 * 2**-5:");
    #10 assign a = 32'h02800000; assign b = 32'h3D000000;
    #10 assign a = 32'h02FFFFFF; assign b = 32'h3D7FFFFF;

    #10 $fwrite(outfile,"\n2**-121 * 2**-6:");
    #10 assign a = 32'h03000000; assign b = 32'h3C800000;
    #10 assign a = 32'h037FFFFF; assign b = 32'h3CFFFFFF;

    #10 $fwrite(outfile,"\n2**-120 * 2**-7:");
    #10 assign a = 32'h03800000; assign b = 32'h3C000000;
    #10 assign a = 32'h03FFFFFF; assign b = 32'h3C7FFFFF;

    #10 $fwrite(outfile,"\n2**-119 * 2**-8:");
    #10 assign a = 32'h04000000; assign b = 32'h3B800000;
    #10 assign a = 32'h047FFFFF; assign b = 32'h3BFFFFFF;

    #10 $fwrite(outfile,"\n2**-118 * 2**-9:");
    #10 assign a = 32'h04800000; assign b = 32'h3B000000;
    #10 assign a = 32'h04FFFFFF; assign b = 32'h3B7FFFFF;

    #10 $fwrite(outfile,"\n2**-117 * 2**-10:");
    #10 assign a = 32'h05000000; assign b = 32'h3A800000;
    #10 assign a = 32'h057FFFFF; assign b = 32'h3AFFFFFF;

    #10 $fwrite(outfile,"\n2**-116 * 2**-11:");
    #10 assign a = 32'h05800000; assign b = 32'h3A000000;
    #10 assign a = 32'h05FFFFFF; assign b = 32'h3A7FFFFF;

    #10 $fwrite(outfile,"\n2**-115 * 2**-12:");
    #10 assign a = 32'h06000000; assign b = 32'h39800000;
    #10 assign a = 32'h067FFFFF; assign b = 32'h39FFFFFF;

    #10 $fwrite(outfile,"\n2**-114 * 2**-13:");
    #10 assign a = 32'h06800000; assign b = 32'h39000000;
    #10 assign a = 32'h06FFFFFF; assign b = 32'h397FFFFF;

    #10 $fwrite(outfile,"\n2**-113 * 2**-14:");
    #10 assign a = 32'h07000000; assign b = 32'h38800000;
    #10 assign a = 32'h077FFFFF; assign b = 32'h38FFFFFF;

    #10 $fwrite(outfile,"\n2**-112 * 2**-15:");
    #10 assign a = 32'h07800000; assign b = 32'h38000000;
    #10 assign a = 32'h07FFFFFF; assign b = 32'h387FFFFF;

    #10 $fwrite(outfile,"\n2**-111 * 2**-16:");
    #10 assign a = 32'h08000000; assign b = 32'h37800000;
    #10 assign a = 32'h087FFFFF; assign b = 32'h37FFFFFF;

    #10 $fwrite(outfile,"\n2**-110 * 2**-17:");
    #10 assign a = 32'h08800000; assign b = 32'h37000000;
    #10 assign a = 32'h08FFFFFF; assign b = 32'h377FFFFF;

    #10 $fwrite(outfile,"\n2**-109 * 2**-18:");
    #10 assign a = 32'h09000000; assign b = 32'h36800000;
    #10 assign a = 32'h097FFFFF; assign b = 32'h36FFFFFF;

    #10 $fwrite(outfile,"\n2**-108 * 2**-19:");
    #10 assign a = 32'h09800000; assign b = 32'h36000000;
    #10 assign a = 32'h09FFFFFF; assign b = 32'h367FFFFF;

    #10 $fwrite(outfile,"\n2**-107 * 2**-20:");
    #10 assign a = 32'h0A000000; assign b = 32'h35800000;
    #10 assign a = 32'h0A7FFFFF; assign b = 32'h35FFFFFF;

    #10 $fwrite(outfile,"\n2**-106 * 2**-21:");
    #10 assign a = 32'h0A800000; assign b = 32'h35000000;
    #10 assign a = 32'h0AFFFFFF; assign b = 32'h357FFFFF;

    #10 $fwrite(outfile,"\n2**-105 * 2**-22:");
    #10 assign a = 32'h0B000000; assign b = 32'h34800000;
    #10 assign a = 32'h0B7FFFFF; assign b = 32'h34FFFFFF;

    #10 $fwrite(outfile,"\n2**-104 * 2**-23:");
    #10 assign a = 32'h0B800000; assign b = 32'h34000000;
    #10 assign a = 32'h0BFFFFFF; assign b = 32'h347FFFFF;

    #10 $fwrite(outfile,"\n2**-103 * 2**-24:");
    #10 assign a = 32'h0C000000; assign b = 32'h33800000;
    #10 assign a = 32'h0C7FFFFF; assign b = 32'h33FFFFFF;

    #10 $fwrite(outfile,"\n2**-102 * 2**-25:");
    #10 assign a = 32'h0C800000; assign b = 32'h33000000;
    #10 assign a = 32'h0CFFFFFF; assign b = 32'h337FFFFF;

    #10 $fwrite(outfile,"\n2**-101 * 2**-26:");
    #10 assign a = 32'h0D000000; assign b = 32'h32800000;
    #10 assign a = 32'h0D7FFFFF; assign b = 32'h32FFFFFF;

    #10 $fwrite(outfile,"\n2**-100 * 2**-27:");
    #10 assign a = 32'h0D800000; assign b = 32'h32000000;
    #10 assign a = 32'h0DFFFFFF; assign b = 32'h327FFFFF;

    #10 $fwrite(outfile,"\n2**-99 * 2**-28:");
    #10 assign a = 32'h0E000000; assign b = 32'h31800000;
    #10 assign a = 32'h0E7FFFFF; assign b = 32'h31FFFFFF;

    #10 $fwrite(outfile,"\n2**-98 * 2**-29:");
    #10 assign a = 32'h0E800000; assign b = 32'h31000000;
    #10 assign a = 32'h0EFFFFFF; assign b = 32'h317FFFFF;

    #10 $fwrite(outfile,"\n2**-97 * 2**-30:");
    #10 assign a = 32'h0F000000; assign b = 32'h30800000;
    #10 assign a = 32'h0F7FFFFF; assign b = 32'h30FFFFFF;

    #10 $fwrite(outfile,"\n2**-96 * 2**-31:");
    #10 assign a = 32'h0F800000; assign b = 32'h30000000;
    #10 assign a = 32'h0FFFFFFF; assign b = 32'h307FFFFF;

    #10 $fwrite(outfile,"\n2**-95 * 2**-32:");
    #10 assign a = 32'h10000000; assign b = 32'h2F800000;
    #10 assign a = 32'h107FFFFF; assign b = 32'h2FFFFFFF;

    #10 $fwrite(outfile,"\n2**-94 * 2**-33:");
    #10 assign a = 32'h10800000; assign b = 32'h2F000000;
    #10 assign a = 32'h10FFFFFF; assign b = 32'h2F7FFFFF;

    #10 $fwrite(outfile,"\n2**-93 * 2**-34:");
    #10 assign a = 32'h11000000; assign b = 32'h2E800000;
    #10 assign a = 32'h117FFFFF; assign b = 32'h2EFFFFFF;

    #10 $fwrite(outfile,"\n2**-92 * 2**-35:");
    #10 assign a = 32'h11800000; assign b = 32'h2E000000;
    #10 assign a = 32'h11FFFFFF; assign b = 32'h2E7FFFFF;

    #10 $fwrite(outfile,"\n2**-91 * 2**-36:");
    #10 assign a = 32'h12000000; assign b = 32'h2D800000;
    #10 assign a = 32'h127FFFFF; assign b = 32'h2DFFFFFF;

    #10 $fwrite(outfile,"\n2**-90 * 2**-37:");
    #10 assign a = 32'h12800000; assign b = 32'h2D000000;
    #10 assign a = 32'h12FFFFFF; assign b = 32'h2D7FFFFF;

    #10 $fwrite(outfile,"\n2**-89 * 2**-38:");
    #10 assign a = 32'h13000000; assign b = 32'h2C800000;
    #10 assign a = 32'h137FFFFF; assign b = 32'h2CFFFFFF;

    #10 $fwrite(outfile,"\n2**-88 * 2**-39:");
    #10 assign a = 32'h13800000; assign b = 32'h2C000000;
    #10 assign a = 32'h13FFFFFF; assign b = 32'h2C7FFFFF;

    #10 $fwrite(outfile,"\n2**-87 * 2**-40:");
    #10 assign a = 32'h14000000; assign b = 32'h2B800000;
    #10 assign a = 32'h147FFFFF; assign b = 32'h2BFFFFFF;

    #10 $fwrite(outfile,"\n2**-86 * 2**-41:");
    #10 assign a = 32'h14800000; assign b = 32'h2B000000;
    #10 assign a = 32'h14FFFFFF; assign b = 32'h2B7FFFFF;

    #10 $fwrite(outfile,"\n2**-85 * 2**-42:");
    #10 assign a = 32'h15000000; assign b = 32'h2A800000;
    #10 assign a = 32'h157FFFFF; assign b = 32'h2AFFFFFF;

    #10 $fwrite(outfile,"\n2**-84 * 2**-43:");
    #10 assign a = 32'h15800000; assign b = 32'h2A000000;
    #10 assign a = 32'h15FFFFFF; assign b = 32'h2A7FFFFF;

    #10 $fwrite(outfile,"\n2**-83 * 2**-44:");
    #10 assign a = 32'h16000000; assign b = 32'h29800000;
    #10 assign a = 32'h167FFFFF; assign b = 32'h29FFFFFF;

    #10 $fwrite(outfile,"\n2**-82 * 2**-45:");
    #10 assign a = 32'h16800000; assign b = 32'h29000000;
    #10 assign a = 32'h16FFFFFF; assign b = 32'h297FFFFF;

    #10 $fwrite(outfile,"\n2**-81 * 2**-46:");
    #10 assign a = 32'h17000000; assign b = 32'h28800000;
    #10 assign a = 32'h177FFFFF; assign b = 32'h28FFFFFF;

    #10 $fwrite(outfile,"\n2**-80 * 2**-47:");
    #10 assign a = 32'h17800000; assign b = 32'h28000000;
    #10 assign a = 32'h17FFFFFF; assign b = 32'h287FFFFF;

    #10 $fwrite(outfile,"\n2**-79 * 2**-48:");
    #10 assign a = 32'h18000000; assign b = 32'h27800000;
    #10 assign a = 32'h187FFFFF; assign b = 32'h27FFFFFF;

    #10 $fwrite(outfile,"\n2**-78 * 2**-49:");
    #10 assign a = 32'h18800000; assign b = 32'h27000000;
    #10 assign a = 32'h18FFFFFF; assign b = 32'h277FFFFF;

    #10 $fwrite(outfile,"\n2**-77 * 2**-50:");
    #10 assign a = 32'h19000000; assign b = 32'h26800000;
    #10 assign a = 32'h197FFFFF; assign b = 32'h26FFFFFF;

    #10 $fwrite(outfile,"\n2**-76 * 2**-51:");
    #10 assign a = 32'h19800000; assign b = 32'h26000000;
    #10 assign a = 32'h19FFFFFF; assign b = 32'h267FFFFF;

    #10 $fwrite(outfile,"\n2**-75 * 2**-52:");
    #10 assign a = 32'h1A000000; assign b = 32'h25800000;
    #10 assign a = 32'h1A7FFFFF; assign b = 32'h25FFFFFF;

    #10 $fwrite(outfile,"\n2**-74 * 2**-53:");
    #10 assign a = 32'h1A800000; assign b = 32'h25000000;
    #10 assign a = 32'h1AFFFFFF; assign b = 32'h257FFFFF;

    #10 $fwrite(outfile,"\n2**-73 * 2**-54:");
    #10 assign a = 32'h1B000000; assign b = 32'h24800000;
    #10 assign a = 32'h1B7FFFFF; assign b = 32'h24FFFFFF;

    #10 $fwrite(outfile,"\n2**-72 * 2**-55:");
    #10 assign a = 32'h1B800000; assign b = 32'h24000000;
    #10 assign a = 32'h1BFFFFFF; assign b = 32'h247FFFFF;

    #10 $fwrite(outfile,"\n2**-71 * 2**-56:");
    #10 assign a = 32'h1C000000; assign b = 32'h23800000;
    #10 assign a = 32'h1C7FFFFF; assign b = 32'h23FFFFFF;

    #10 $fwrite(outfile,"\n2**-70 * 2**-57:");
    #10 assign a = 32'h1C800000; assign b = 32'h23000000;
    #10 assign a = 32'h1CFFFFFF; assign b = 32'h237FFFFF;

    #10 $fwrite(outfile,"\n2**-69 * 2**-58:");
    #10 assign a = 32'h1D000000; assign b = 32'h22800000;
    #10 assign a = 32'h1D7FFFFF; assign b = 32'h22FFFFFF;

    #10 $fwrite(outfile,"\n2**-68 * 2**-59:");
    #10 assign a = 32'h1D800000; assign b = 32'h22000000;
    #10 assign a = 32'h1DFFFFFF; assign b = 32'h227FFFFF;

    #10 $fwrite(outfile,"\n2**-67 * 2**-60:");
    #10 assign a = 32'h1E000000; assign b = 32'h21800000;
    #10 assign a = 32'h1E7FFFFF; assign b = 32'h21FFFFFF;

    #10 $fwrite(outfile,"\n2**-66 * 2**-61:");
    #10 assign a = 32'h1E800000; assign b = 32'h21000000;
    #10 assign a = 32'h1EFFFFFF; assign b = 32'h217FFFFF;

    #10 $fwrite(outfile,"\n2**-65 * 2**-62:");
    #10 assign a = 32'h1F000000; assign b = 32'h20800000;
    #10 assign a = 32'h1F7FFFFF; assign b = 32'h20FFFFFF;

    #10 $fwrite(outfile,"\n2**-64 * 2**-63:");
    #10 assign a = 32'h1F800000; assign b = 32'h20000000;
    #10 assign a = 32'h1FFFFFFF; assign b = 32'h207FFFFF;

    #10 $fwrite(outfile,"\n2**-63 * 2**-64:");
    #10 assign a = 32'h20000000; assign b = 32'h1F800000;
    #10 assign a = 32'h207FFFFF; assign b = 32'h1FFFFFFF;

    #10 $fwrite(outfile,"\n2**-62 * 2**-65:");
    #10 assign a = 32'h20800000; assign b = 32'h1F000000;
    #10 assign a = 32'h20FFFFFF; assign b = 32'h1F7FFFFF;

    #10 $fwrite(outfile,"\n2**-61 * 2**-66:");
    #10 assign a = 32'h21000000; assign b = 32'h1E800000;
    #10 assign a = 32'h217FFFFF; assign b = 32'h1EFFFFFF;

    #10 $fwrite(outfile,"\n2**-60 * 2**-67:");
    #10 assign a = 32'h21800000; assign b = 32'h1E000000;
    #10 assign a = 32'h21FFFFFF; assign b = 32'h1E7FFFFF;

    #10 $fwrite(outfile,"\n2**-59 * 2**-68:");
    #10 assign a = 32'h22000000; assign b = 32'h1D800000;
    #10 assign a = 32'h227FFFFF; assign b = 32'h1DFFFFFF;

    #10 $fwrite(outfile,"\n2**-58 * 2**-69:");
    #10 assign a = 32'h22800000; assign b = 32'h1D000000;
    #10 assign a = 32'h22FFFFFF; assign b = 32'h1D7FFFFF;

    #10 $fwrite(outfile,"\n2**-57 * 2**-70:");
    #10 assign a = 32'h23000000; assign b = 32'h1C800000;
    #10 assign a = 32'h237FFFFF; assign b = 32'h1CFFFFFF;

    #10 $fwrite(outfile,"\n2**-56 * 2**-71:");
    #10 assign a = 32'h23800000; assign b = 32'h1C000000;
    #10 assign a = 32'h23FFFFFF; assign b = 32'h1C7FFFFF;

    #10 $fwrite(outfile,"\n2**-55 * 2**-72:");
    #10 assign a = 32'h24000000; assign b = 32'h1B800000;
    #10 assign a = 32'h247FFFFF; assign b = 32'h1BFFFFFF;

    #10 $fwrite(outfile,"\n2**-54 * 2**-73:");
    #10 assign a = 32'h24800000; assign b = 32'h1B000000;
    #10 assign a = 32'h24FFFFFF; assign b = 32'h1B7FFFFF;

    #10 $fwrite(outfile,"\n2**-53 * 2**-74:");
    #10 assign a = 32'h25000000; assign b = 32'h1A800000;
    #10 assign a = 32'h257FFFFF; assign b = 32'h1AFFFFFF;

    #10 $fwrite(outfile,"\n2**-52 * 2**-75:");
    #10 assign a = 32'h25800000; assign b = 32'h1A000000;
    #10 assign a = 32'h25FFFFFF; assign b = 32'h1A7FFFFF;

    #10 $fwrite(outfile,"\n2**-51 * 2**-76:");
    #10 assign a = 32'h26000000; assign b = 32'h19800000;
    #10 assign a = 32'h267FFFFF; assign b = 32'h19FFFFFF;

    #10 $fwrite(outfile,"\n2**-50 * 2**-77:");
    #10 assign a = 32'h26800000; assign b = 32'h19000000;
    #10 assign a = 32'h26FFFFFF; assign b = 32'h197FFFFF;

    #10 $fwrite(outfile,"\n2**-49 * 2**-78:");
    #10 assign a = 32'h27000000; assign b = 32'h18800000;
    #10 assign a = 32'h277FFFFF; assign b = 32'h18FFFFFF;

    #10 $fwrite(outfile,"\n2**-48 * 2**-79:");
    #10 assign a = 32'h27800000; assign b = 32'h18000000;
    #10 assign a = 32'h27FFFFFF; assign b = 32'h187FFFFF;

    #10 $fwrite(outfile,"\n2**-47 * 2**-80:");
    #10 assign a = 32'h28000000; assign b = 32'h17800000;
    #10 assign a = 32'h287FFFFF; assign b = 32'h17FFFFFF;

    #10 $fwrite(outfile,"\n2**-46 * 2**-81:");
    #10 assign a = 32'h28800000; assign b = 32'h17000000;
    #10 assign a = 32'h28FFFFFF; assign b = 32'h177FFFFF;

    #10 $fwrite(outfile,"\n2**-45 * 2**-82:");
    #10 assign a = 32'h29000000; assign b = 32'h16800000;
    #10 assign a = 32'h297FFFFF; assign b = 32'h16FFFFFF;

    #10 $fwrite(outfile,"\n2**-44 * 2**-83:");
    #10 assign a = 32'h29800000; assign b = 32'h16000000;
    #10 assign a = 32'h29FFFFFF; assign b = 32'h167FFFFF;

    #10 $fwrite(outfile,"\n2**-43 * 2**-84:");
    #10 assign a = 32'h2A000000; assign b = 32'h15800000;
    #10 assign a = 32'h2A7FFFFF; assign b = 32'h15FFFFFF;

    #10 $fwrite(outfile,"\n2**-42 * 2**-85:");
    #10 assign a = 32'h2A800000; assign b = 32'h15000000;
    #10 assign a = 32'h2AFFFFFF; assign b = 32'h157FFFFF;

    #10 $fwrite(outfile,"\n2**-41 * 2**-86:");
    #10 assign a = 32'h2B000000; assign b = 32'h14800000;
    #10 assign a = 32'h2B7FFFFF; assign b = 32'h14FFFFFF;

    #10 $fwrite(outfile,"\n2**-40 * 2**-87:");
    #10 assign a = 32'h2B800000; assign b = 32'h14000000;
    #10 assign a = 32'h2BFFFFFF; assign b = 32'h147FFFFF;

    #10 $fwrite(outfile,"\n2**-39 * 2**-88:");
    #10 assign a = 32'h2C000000; assign b = 32'h13800000;
    #10 assign a = 32'h2C7FFFFF; assign b = 32'h13FFFFFF;

    #10 $fwrite(outfile,"\n2**-38 * 2**-89:");
    #10 assign a = 32'h2C800000; assign b = 32'h13000000;
    #10 assign a = 32'h2CFFFFFF; assign b = 32'h137FFFFF;

    #10 $fwrite(outfile,"\n2**-37 * 2**-90:");
    #10 assign a = 32'h2D000000; assign b = 32'h12800000;
    #10 assign a = 32'h2D7FFFFF; assign b = 32'h12FFFFFF;

    #10 $fwrite(outfile,"\n2**-36 * 2**-91:");
    #10 assign a = 32'h2D800000; assign b = 32'h12000000;
    #10 assign a = 32'h2DFFFFFF; assign b = 32'h127FFFFF;

    #10 $fwrite(outfile,"\n2**-35 * 2**-92:");
    #10 assign a = 32'h2E000000; assign b = 32'h11800000;
    #10 assign a = 32'h2E7FFFFF; assign b = 32'h11FFFFFF;

    #10 $fwrite(outfile,"\n2**-34 * 2**-93:");
    #10 assign a = 32'h2E800000; assign b = 32'h11000000;
    #10 assign a = 32'h2EFFFFFF; assign b = 32'h117FFFFF;

    #10 $fwrite(outfile,"\n2**-33 * 2**-94:");
    #10 assign a = 32'h2F000000; assign b = 32'h10800000;
    #10 assign a = 32'h2F7FFFFF; assign b = 32'h10FFFFFF;

    #10 $fwrite(outfile,"\n2**-32 * 2**-95:");
    #10 assign a = 32'h2F800000; assign b = 32'h10000000;
    #10 assign a = 32'h2FFFFFFF; assign b = 32'h107FFFFF;

    #10 $fwrite(outfile,"\n2**-31 * 2**-96:");
    #10 assign a = 32'h30000000; assign b = 32'h0F800000;
    #10 assign a = 32'h307FFFFF; assign b = 32'h0FFFFFFF;

    #10 $fwrite(outfile,"\n2**-30 * 2**-97:");
    #10 assign a = 32'h30800000; assign b = 32'h0F000000;
    #10 assign a = 32'h30FFFFFF; assign b = 32'h0F7FFFFF;

    #10 $fwrite(outfile,"\n2**-29 * 2**-98:");
    #10 assign a = 32'h31000000; assign b = 32'h0E800000;
    #10 assign a = 32'h317FFFFF; assign b = 32'h0EFFFFFF;

    #10 $fwrite(outfile,"\n2**-28 * 2**-99:");
    #10 assign a = 32'h31800000; assign b = 32'h0E000000;
    #10 assign a = 32'h31FFFFFF; assign b = 32'h0E7FFFFF;

    #10 $fwrite(outfile,"\n2**-27 * 2**-100:");
    #10 assign a = 32'h32000000; assign b = 32'h0D800000;
    #10 assign a = 32'h327FFFFF; assign b = 32'h0DFFFFFF;

    #10 $fwrite(outfile,"\n2**-26 * 2**-101:");
    #10 assign a = 32'h32800000; assign b = 32'h0D000000;
    #10 assign a = 32'h32FFFFFF; assign b = 32'h0D7FFFFF;

    #10 $fwrite(outfile,"\n2**-25 * 2**-102:");
    #10 assign a = 32'h33000000; assign b = 32'h0C800000;
    #10 assign a = 32'h337FFFFF; assign b = 32'h0CFFFFFF;

    #10 $fwrite(outfile,"\n2**-24 * 2**-103:");
    #10 assign a = 32'h33800000; assign b = 32'h0C000000;
    #10 assign a = 32'h33FFFFFF; assign b = 32'h0C7FFFFF;

    #10 $fwrite(outfile,"\n2**-23 * 2**-104:");
    #10 assign a = 32'h34000000; assign b = 32'h0B800000;
    #10 assign a = 32'h347FFFFF; assign b = 32'h0BFFFFFF;

    #10 $fwrite(outfile,"\n2**-22 * 2**-105:");
    #10 assign a = 32'h34800000; assign b = 32'h0B000000;
    #10 assign a = 32'h34FFFFFF; assign b = 32'h0B7FFFFF;

    #10 $fwrite(outfile,"\n2**-21 * 2**-106:");
    #10 assign a = 32'h35000000; assign b = 32'h0A800000;
    #10 assign a = 32'h357FFFFF; assign b = 32'h0AFFFFFF;

    #10 $fwrite(outfile,"\n2**-20 * 2**-107:");
    #10 assign a = 32'h35800000; assign b = 32'h0A000000;
    #10 assign a = 32'h35FFFFFF; assign b = 32'h0A7FFFFF;

    #10 $fwrite(outfile,"\n2**-19 * 2**-108:");
    #10 assign a = 32'h36000000; assign b = 32'h09800000;
    #10 assign a = 32'h367FFFFF; assign b = 32'h09FFFFFF;

    #10 $fwrite(outfile,"\n2**-18 * 2**-109:");
    #10 assign a = 32'h36800000; assign b = 32'h09000000;
    #10 assign a = 32'h36FFFFFF; assign b = 32'h097FFFFF;

    #10 $fwrite(outfile,"\n2**-17 * 2**-110:");
    #10 assign a = 32'h37000000; assign b = 32'h08800000;
    #10 assign a = 32'h377FFFFF; assign b = 32'h08FFFFFF;

    #10 $fwrite(outfile,"\n2**-16 * 2**-111:");
    #10 assign a = 32'h37800000; assign b = 32'h08000000;
    #10 assign a = 32'h37FFFFFF; assign b = 32'h087FFFFF;

    #10 $fwrite(outfile,"\n2**-15 * 2**-112:");
    #10 assign a = 32'h38000000; assign b = 32'h07800000;
    #10 assign a = 32'h387FFFFF; assign b = 32'h07FFFFFF;

    #10 $fwrite(outfile,"\n2**-14 * 2**-113:");
    #10 assign a = 32'h38800000; assign b = 32'h07000000;
    #10 assign a = 32'h38FFFFFF; assign b = 32'h077FFFFF;

    #10 $fwrite(outfile,"\n2**-13 * 2**-114:");
    #10 assign a = 32'h39000000; assign b = 32'h06800000;
    #10 assign a = 32'h397FFFFF; assign b = 32'h06FFFFFF;

    #10 $fwrite(outfile,"\n2**-12 * 2**-115:");
    #10 assign a = 32'h39800000; assign b = 32'h06000000;
    #10 assign a = 32'h39FFFFFF; assign b = 32'h067FFFFF;

    #10 $fwrite(outfile,"\n2**-11 * 2**-116:");
    #10 assign a = 32'h3A000000; assign b = 32'h05800000;
    #10 assign a = 32'h3A7FFFFF; assign b = 32'h05FFFFFF;

    #10 $fwrite(outfile,"\n2**-10 * 2**-117:");
    #10 assign a = 32'h3A800000; assign b = 32'h05000000;
    #10 assign a = 32'h3AFFFFFF; assign b = 32'h057FFFFF;

    #10 $fwrite(outfile,"\n2**-9 * 2**-118:");
    #10 assign a = 32'h3B000000; assign b = 32'h04800000;
    #10 assign a = 32'h3B7FFFFF; assign b = 32'h04FFFFFF;

    #10 $fwrite(outfile,"\n2**-8 * 2**-119:");
    #10 assign a = 32'h3B800000; assign b = 32'h04000000;
    #10 assign a = 32'h3BFFFFFF; assign b = 32'h047FFFFF;

    #10 $fwrite(outfile,"\n2**-7 * 2**-120:");
    #10 assign a = 32'h3C000000; assign b = 32'h03800000;
    #10 assign a = 32'h3C7FFFFF; assign b = 32'h03FFFFFF;

    #10 $fwrite(outfile,"\n2**-6 * 2**-121:");
    #10 assign a = 32'h3C800000; assign b = 32'h03000000;
    #10 assign a = 32'h3CFFFFFF; assign b = 32'h037FFFFF;

    #10 $fwrite(outfile,"\n2**-5 * 2**-122:");
    #10 assign a = 32'h3D000000; assign b = 32'h02800000;
    #10 assign a = 32'h3D7FFFFF; assign b = 32'h02FFFFFF;

    #10 $fwrite(outfile,"\n2**-4 * 2**-123:");
    #10 assign a = 32'h3D800000; assign b = 32'h02000000;
    #10 assign a = 32'h3DFFFFFF; assign b = 32'h027FFFFF;

    #10 $fwrite(outfile,"\n2**-3 * 2**-124:");
    #10 assign a = 32'h3E000000; assign b = 32'h01800000;
    #10 assign a = 32'h3E7FFFFF; assign b = 32'h01FFFFFF;

    #10 $fwrite(outfile,"\n2**-2 * 2**-125:");
    #10 assign a = 32'h3E800000; assign b = 32'h01000000;
    #10 assign a = 32'h3EFFFFFF; assign b = 32'h017FFFFF;

    #10 $fwrite(outfile,"\n2**-1 * 2**-126:");
    #10 assign a = 32'h3F000000; assign b = 32'h00800000;
    #10 assign a = 32'h3F7FFFFF; assign b = 32'h00FFFFFF;

    #10 $fwrite(outfile,"\n2**0 * 2**-127:");
    #10 assign a = 32'h3F800000; assign b = 32'h00400000;
    #10 assign a = 32'h3FFFFFFF; assign b = 32'h007FFFFF;

    #10 $fwrite(outfile,"\n2**1 * 2**-128:");
    #10 assign a = 32'h40000000; assign b = 32'h00200000;
    #10 assign a = 32'h407FFFFF; assign b = 32'h003FFFFF;

    #10 $fwrite(outfile,"\n2**2 * 2**-129:");
    #10 assign a = 32'h40800000; assign b = 32'h00100000;
    #10 assign a = 32'h40FFFFFF; assign b = 32'h001FFFFF;

    #10 $fwrite(outfile,"\n2**3 * 2**-130:");
    #10 assign a = 32'h41000000; assign b = 32'h00080000;
    #10 assign a = 32'h417FFFFF; assign b = 32'h000FFFFF;

    #10 $fwrite(outfile,"\n2**4 * 2**-131:");
    #10 assign a = 32'h41800000; assign b = 32'h00040000;
    #10 assign a = 32'h41FFFFFF; assign b = 32'h0007FFFF;

    #10 $fwrite(outfile,"\n2**5 * 2**-132:");
    #10 assign a = 32'h42000000; assign b = 32'h00020000;
    #10 assign a = 32'h427FFFFF; assign b = 32'h0003FFFF;

    #10 $fwrite(outfile,"\n2**6 * 2**-133:");
    #10 assign a = 32'h42800000; assign b = 32'h00010000;
    #10 assign a = 32'h42FFFFFF; assign b = 32'h0001FFFF;

    #10 $fwrite(outfile,"\n2**7 * 2**-134:");
    #10 assign a = 32'h43000000; assign b = 32'h00008000;
    #10 assign a = 32'h437FFFFF; assign b = 32'h0000FFFF;

    #10 $fwrite(outfile,"\n2**8 * 2**-135:");
    #10 assign a = 32'h43800000; assign b = 32'h00004000;
    #10 assign a = 32'h43FFFFFF; assign b = 32'h00007FFF;

    #10 $fwrite(outfile,"\n2**9 * 2**-136:");
    #10 assign a = 32'h44000000; assign b = 32'h00002000;
    #10 assign a = 32'h447FFFFF; assign b = 32'h00003FFF;

    #10 $fwrite(outfile,"\n2**10 * 2**-137:");
    #10 assign a = 32'h44800000; assign b = 32'h00001000;
    #10 assign a = 32'h44FFFFFF; assign b = 32'h00001FFF;

    #10 $fwrite(outfile,"\n2**11 * 2**-138:");
    #10 assign a = 32'h45000000; assign b = 32'h00000800;
    #10 assign a = 32'h457FFFFF; assign b = 32'h00000FFF;

    #10 $fwrite(outfile,"\n2**12 * 2**-139:");
    #10 assign a = 32'h45800000; assign b = 32'h00000400;
    #10 assign a = 32'h45FFFFFF; assign b = 32'h000007FF;

    #10 $fwrite(outfile,"\n2**13 * 2**-140:");
    #10 assign a = 32'h46000000; assign b = 32'h00000200;
    #10 assign a = 32'h467FFFFF; assign b = 32'h000003FF;

    #10 $fwrite(outfile,"\n2**14 * 2**-141:");
    #10 assign a = 32'h46800000; assign b = 32'h00000100;
    #10 assign a = 32'h46FFFFFF; assign b = 32'h000001FF;

    #10 $fwrite(outfile,"\n2**15 * 2**-142:");
    #10 assign a = 32'h47000000; assign b = 32'h00000080;
    #10 assign a = 32'h477FFFFF; assign b = 32'h000000FF;

    #10 $fwrite(outfile,"\n2**16 * 2**-143:");
    #10 assign a = 32'h47800000; assign b = 32'h00000040;
    #10 assign a = 32'h47FFFFFF; assign b = 32'h0000007F;

    #10 $fwrite(outfile,"\n2**17 * 2**-144:");
    #10 assign a = 32'h48000000; assign b = 32'h00000020;
    #10 assign a = 32'h487FFFFF; assign b = 32'h0000003F;

    #10 $fwrite(outfile,"\n2**18 * 2**-145:");
    #10 assign a = 32'h48800000; assign b = 32'h00000010;
    #10 assign a = 32'h48FFFFFF; assign b = 32'h0000001F;

    #10 $fwrite(outfile,"\n2**19 * 2**-146:");
    #10 assign a = 32'h49000000; assign b = 32'h00000008;
    #10 assign a = 32'h497FFFFF; assign b = 32'h0000000F;

    #10 $fwrite(outfile,"\n2**20 * 2**-147:");
    #10 assign a = 32'h49800000; assign b = 32'h00000004;
    #10 assign a = 32'h49FFFFFF; assign b = 32'h00000007;

    #10 $fwrite(outfile,"\n2**21 * 2**-148:");
    #10 assign a = 32'h4A000000; assign b = 32'h00000002;
    #10 assign a = 32'h4A7FFFFF; assign b = 32'h00000003;

    #10 $fwrite(outfile,"\n2**22 * 2**-149:");
    #10 assign a = 32'h4A800000; assign b = 32'h00000001;
    #10 assign a = 32'h4AFFFFFF; assign b = 32'h00000001;

    #10 $fwrite(outfile,"\n2**-149 * 2**-1:");
    #10 assign a = 32'h00000001; assign b = 32'h3F000000;
    #10 assign a = 32'h00000001; assign b = 32'h3F7FFFFF;

    #10 $fwrite(outfile,"\n2**-148 * 2**-2:");
    #10 assign a = 32'h00000002; assign b = 32'h3E800000;
    #10 assign a = 32'h00000003; assign b = 32'h3EFFFFFF;

    #10 $fwrite(outfile,"\n2**-147 * 2**-3:");
    #10 assign a = 32'h00000004; assign b = 32'h3E000000;
    #10 assign a = 32'h00000007; assign b = 32'h3E7FFFFF;

    #10 $fwrite(outfile,"\n2**-146 * 2**-4:");
    #10 assign a = 32'h00000008; assign b = 32'h3D800000;
    #10 assign a = 32'h0000000F; assign b = 32'h3DFFFFFF;

    #10 $fwrite(outfile,"\n2**-145 * 2**-5:");
    #10 assign a = 32'h00000010; assign b = 32'h3D000000;
    #10 assign a = 32'h0000001F; assign b = 32'h3D7FFFFF;

    #10 $fwrite(outfile,"\n2**-144 * 2**-6:");
    #10 assign a = 32'h00000020; assign b = 32'h3C800000;
    #10 assign a = 32'h0000003F; assign b = 32'h3CFFFFFF;

    #10 $fwrite(outfile,"\n2**-143 * 2**-7:");
    #10 assign a = 32'h00000040; assign b = 32'h3C000000;
    #10 assign a = 32'h0000007F; assign b = 32'h3C7FFFFF;

    #10 $fwrite(outfile,"\n2**-142 * 2**-8:");
    #10 assign a = 32'h00000080; assign b = 32'h3B800000;
    #10 assign a = 32'h000000FF; assign b = 32'h3BFFFFFF;

    #10 $fwrite(outfile,"\n2**-141 * 2**-9:");
    #10 assign a = 32'h00000100; assign b = 32'h3B000000;
    #10 assign a = 32'h000001FF; assign b = 32'h3B7FFFFF;

    #10 $fwrite(outfile,"\n2**-140 * 2**-10:");
    #10 assign a = 32'h00000200; assign b = 32'h3A800000;
    #10 assign a = 32'h000003FF; assign b = 32'h3AFFFFFF;

    #10 $fwrite(outfile,"\n2**-139 * 2**-11:");
    #10 assign a = 32'h00000400; assign b = 32'h3A000000;
    #10 assign a = 32'h000007FF; assign b = 32'h3A7FFFFF;

    #10 $fwrite(outfile,"\n2**-138 * 2**-12:");
    #10 assign a = 32'h00000800; assign b = 32'h39800000;
    #10 assign a = 32'h00000FFF; assign b = 32'h39FFFFFF;

    #10 $fwrite(outfile,"\n2**-137 * 2**-13:");
    #10 assign a = 32'h00001000; assign b = 32'h39000000;
    #10 assign a = 32'h00001FFF; assign b = 32'h397FFFFF;

    #10 $fwrite(outfile,"\n2**-136 * 2**-14:");
    #10 assign a = 32'h00002000; assign b = 32'h38800000;
    #10 assign a = 32'h00003FFF; assign b = 32'h38FFFFFF;

    #10 $fwrite(outfile,"\n2**-135 * 2**-15:");
    #10 assign a = 32'h00004000; assign b = 32'h38000000;
    #10 assign a = 32'h00007FFF; assign b = 32'h387FFFFF;

    #10 $fwrite(outfile,"\n2**-134 * 2**-16:");
    #10 assign a = 32'h00008000; assign b = 32'h37800000;
    #10 assign a = 32'h0000FFFF; assign b = 32'h37FFFFFF;

    #10 $fwrite(outfile,"\n2**-133 * 2**-17:");
    #10 assign a = 32'h00010000; assign b = 32'h37000000;
    #10 assign a = 32'h0001FFFF; assign b = 32'h377FFFFF;

    #10 $fwrite(outfile,"\n2**-132 * 2**-18:");
    #10 assign a = 32'h00020000; assign b = 32'h36800000;
    #10 assign a = 32'h0003FFFF; assign b = 32'h36FFFFFF;

    #10 $fwrite(outfile,"\n2**-131 * 2**-19:");
    #10 assign a = 32'h00040000; assign b = 32'h36000000;
    #10 assign a = 32'h0007FFFF; assign b = 32'h367FFFFF;

    #10 $fwrite(outfile,"\n2**-130 * 2**-20:");
    #10 assign a = 32'h00080000; assign b = 32'h35800000;
    #10 assign a = 32'h000FFFFF; assign b = 32'h35FFFFFF;

    #10 $fwrite(outfile,"\n2**-129 * 2**-21:");
    #10 assign a = 32'h00100000; assign b = 32'h35000000;
    #10 assign a = 32'h001FFFFF; assign b = 32'h357FFFFF;

    #10 $fwrite(outfile,"\n2**-128 * 2**-22:");
    #10 assign a = 32'h00200000; assign b = 32'h34800000;
    #10 assign a = 32'h003FFFFF; assign b = 32'h34FFFFFF;

    #10 $fwrite(outfile,"\n2**-127 * 2**-23:");
    #10 assign a = 32'h00400000; assign b = 32'h34000000;
    #10 assign a = 32'h007FFFFF; assign b = 32'h347FFFFF;

    #10 $fwrite(outfile,"\n2**-126 * 2**-24:");
    #10 assign a = 32'h00800000; assign b = 32'h33800000;
    #10 assign a = 32'h00FFFFFF; assign b = 32'h33FFFFFF;

    #10 $fwrite(outfile,"\n2**-125 * 2**-25:");
    #10 assign a = 32'h01000000; assign b = 32'h33000000;
    #10 assign a = 32'h017FFFFF; assign b = 32'h337FFFFF;

    #10 $fwrite(outfile,"\n2**-124 * 2**-26:");
    #10 assign a = 32'h01800000; assign b = 32'h32800000;
    #10 assign a = 32'h01FFFFFF; assign b = 32'h32FFFFFF;

    #10 $fwrite(outfile,"\n2**-123 * 2**-27:");
    #10 assign a = 32'h02000000; assign b = 32'h32000000;
    #10 assign a = 32'h027FFFFF; assign b = 32'h327FFFFF;

    #10 $fwrite(outfile,"\n2**-122 * 2**-28:");
    #10 assign a = 32'h02800000; assign b = 32'h31800000;
    #10 assign a = 32'h02FFFFFF; assign b = 32'h31FFFFFF;

    #10 $fwrite(outfile,"\n2**-121 * 2**-29:");
    #10 assign a = 32'h03000000; assign b = 32'h31000000;
    #10 assign a = 32'h037FFFFF; assign b = 32'h317FFFFF;

    #10 $fwrite(outfile,"\n2**-120 * 2**-30:");
    #10 assign a = 32'h03800000; assign b = 32'h30800000;
    #10 assign a = 32'h03FFFFFF; assign b = 32'h30FFFFFF;

    #10 $fwrite(outfile,"\n2**-119 * 2**-31:");
    #10 assign a = 32'h04000000; assign b = 32'h30000000;
    #10 assign a = 32'h047FFFFF; assign b = 32'h307FFFFF;

    #10 $fwrite(outfile,"\n2**-118 * 2**-32:");
    #10 assign a = 32'h04800000; assign b = 32'h2F800000;
    #10 assign a = 32'h04FFFFFF; assign b = 32'h2FFFFFFF;

    #10 $fwrite(outfile,"\n2**-117 * 2**-33:");
    #10 assign a = 32'h05000000; assign b = 32'h2F000000;
    #10 assign a = 32'h057FFFFF; assign b = 32'h2F7FFFFF;

    #10 $fwrite(outfile,"\n2**-116 * 2**-34:");
    #10 assign a = 32'h05800000; assign b = 32'h2E800000;
    #10 assign a = 32'h05FFFFFF; assign b = 32'h2EFFFFFF;

    #10 $fwrite(outfile,"\n2**-115 * 2**-35:");
    #10 assign a = 32'h06000000; assign b = 32'h2E000000;
    #10 assign a = 32'h067FFFFF; assign b = 32'h2E7FFFFF;

    #10 $fwrite(outfile,"\n2**-114 * 2**-36:");
    #10 assign a = 32'h06800000; assign b = 32'h2D800000;
    #10 assign a = 32'h06FFFFFF; assign b = 32'h2DFFFFFF;

    #10 $fwrite(outfile,"\n2**-113 * 2**-37:");
    #10 assign a = 32'h07000000; assign b = 32'h2D000000;
    #10 assign a = 32'h077FFFFF; assign b = 32'h2D7FFFFF;

    #10 $fwrite(outfile,"\n2**-112 * 2**-38:");
    #10 assign a = 32'h07800000; assign b = 32'h2C800000;
    #10 assign a = 32'h07FFFFFF; assign b = 32'h2CFFFFFF;

    #10 $fwrite(outfile,"\n2**-111 * 2**-39:");
    #10 assign a = 32'h08000000; assign b = 32'h2C000000;
    #10 assign a = 32'h087FFFFF; assign b = 32'h2C7FFFFF;

    #10 $fwrite(outfile,"\n2**-110 * 2**-40:");
    #10 assign a = 32'h08800000; assign b = 32'h2B800000;
    #10 assign a = 32'h08FFFFFF; assign b = 32'h2BFFFFFF;

    #10 $fwrite(outfile,"\n2**-109 * 2**-41:");
    #10 assign a = 32'h09000000; assign b = 32'h2B000000;
    #10 assign a = 32'h097FFFFF; assign b = 32'h2B7FFFFF;

    #10 $fwrite(outfile,"\n2**-108 * 2**-42:");
    #10 assign a = 32'h09800000; assign b = 32'h2A800000;
    #10 assign a = 32'h09FFFFFF; assign b = 32'h2AFFFFFF;

    #10 $fwrite(outfile,"\n2**-107 * 2**-43:");
    #10 assign a = 32'h0A000000; assign b = 32'h2A000000;
    #10 assign a = 32'h0A7FFFFF; assign b = 32'h2A7FFFFF;

    #10 $fwrite(outfile,"\n2**-106 * 2**-44:");
    #10 assign a = 32'h0A800000; assign b = 32'h29800000;
    #10 assign a = 32'h0AFFFFFF; assign b = 32'h29FFFFFF;

    #10 $fwrite(outfile,"\n2**-105 * 2**-45:");
    #10 assign a = 32'h0B000000; assign b = 32'h29000000;
    #10 assign a = 32'h0B7FFFFF; assign b = 32'h297FFFFF;

    #10 $fwrite(outfile,"\n2**-104 * 2**-46:");
    #10 assign a = 32'h0B800000; assign b = 32'h28800000;
    #10 assign a = 32'h0BFFFFFF; assign b = 32'h28FFFFFF;

    #10 $fwrite(outfile,"\n2**-103 * 2**-47:");
    #10 assign a = 32'h0C000000; assign b = 32'h28000000;
    #10 assign a = 32'h0C7FFFFF; assign b = 32'h287FFFFF;

    #10 $fwrite(outfile,"\n2**-102 * 2**-48:");
    #10 assign a = 32'h0C800000; assign b = 32'h27800000;
    #10 assign a = 32'h0CFFFFFF; assign b = 32'h27FFFFFF;

    #10 $fwrite(outfile,"\n2**-101 * 2**-49:");
    #10 assign a = 32'h0D000000; assign b = 32'h27000000;
    #10 assign a = 32'h0D7FFFFF; assign b = 32'h277FFFFF;

    #10 $fwrite(outfile,"\n2**-100 * 2**-50:");
    #10 assign a = 32'h0D800000; assign b = 32'h26800000;
    #10 assign a = 32'h0DFFFFFF; assign b = 32'h26FFFFFF;

    #10 $fwrite(outfile,"\n2**-99 * 2**-51:");
    #10 assign a = 32'h0E000000; assign b = 32'h26000000;
    #10 assign a = 32'h0E7FFFFF; assign b = 32'h267FFFFF;

    #10 $fwrite(outfile,"\n2**-98 * 2**-52:");
    #10 assign a = 32'h0E800000; assign b = 32'h25800000;
    #10 assign a = 32'h0EFFFFFF; assign b = 32'h25FFFFFF;

    #10 $fwrite(outfile,"\n2**-97 * 2**-53:");
    #10 assign a = 32'h0F000000; assign b = 32'h25000000;
    #10 assign a = 32'h0F7FFFFF; assign b = 32'h257FFFFF;

    #10 $fwrite(outfile,"\n2**-96 * 2**-54:");
    #10 assign a = 32'h0F800000; assign b = 32'h24800000;
    #10 assign a = 32'h0FFFFFFF; assign b = 32'h24FFFFFF;

    #10 $fwrite(outfile,"\n2**-95 * 2**-55:");
    #10 assign a = 32'h10000000; assign b = 32'h24000000;
    #10 assign a = 32'h107FFFFF; assign b = 32'h247FFFFF;

    #10 $fwrite(outfile,"\n2**-94 * 2**-56:");
    #10 assign a = 32'h10800000; assign b = 32'h23800000;
    #10 assign a = 32'h10FFFFFF; assign b = 32'h23FFFFFF;

    #10 $fwrite(outfile,"\n2**-93 * 2**-57:");
    #10 assign a = 32'h11000000; assign b = 32'h23000000;
    #10 assign a = 32'h117FFFFF; assign b = 32'h237FFFFF;

    #10 $fwrite(outfile,"\n2**-92 * 2**-58:");
    #10 assign a = 32'h11800000; assign b = 32'h22800000;
    #10 assign a = 32'h11FFFFFF; assign b = 32'h22FFFFFF;

    #10 $fwrite(outfile,"\n2**-91 * 2**-59:");
    #10 assign a = 32'h12000000; assign b = 32'h22000000;
    #10 assign a = 32'h127FFFFF; assign b = 32'h227FFFFF;

    #10 $fwrite(outfile,"\n2**-90 * 2**-60:");
    #10 assign a = 32'h12800000; assign b = 32'h21800000;
    #10 assign a = 32'h12FFFFFF; assign b = 32'h21FFFFFF;

    #10 $fwrite(outfile,"\n2**-89 * 2**-61:");
    #10 assign a = 32'h13000000; assign b = 32'h21000000;
    #10 assign a = 32'h137FFFFF; assign b = 32'h217FFFFF;

    #10 $fwrite(outfile,"\n2**-88 * 2**-62:");
    #10 assign a = 32'h13800000; assign b = 32'h20800000;
    #10 assign a = 32'h13FFFFFF; assign b = 32'h20FFFFFF;

    #10 $fwrite(outfile,"\n2**-87 * 2**-63:");
    #10 assign a = 32'h14000000; assign b = 32'h20000000;
    #10 assign a = 32'h147FFFFF; assign b = 32'h207FFFFF;

    #10 $fwrite(outfile,"\n2**-86 * 2**-64:");
    #10 assign a = 32'h14800000; assign b = 32'h1F800000;
    #10 assign a = 32'h14FFFFFF; assign b = 32'h1FFFFFFF;

    #10 $fwrite(outfile,"\n2**-85 * 2**-65:");
    #10 assign a = 32'h15000000; assign b = 32'h1F000000;
    #10 assign a = 32'h157FFFFF; assign b = 32'h1F7FFFFF;

    #10 $fwrite(outfile,"\n2**-84 * 2**-66:");
    #10 assign a = 32'h15800000; assign b = 32'h1E800000;
    #10 assign a = 32'h15FFFFFF; assign b = 32'h1EFFFFFF;

    #10 $fwrite(outfile,"\n2**-83 * 2**-67:");
    #10 assign a = 32'h16000000; assign b = 32'h1E000000;
    #10 assign a = 32'h167FFFFF; assign b = 32'h1E7FFFFF;

    #10 $fwrite(outfile,"\n2**-82 * 2**-68:");
    #10 assign a = 32'h16800000; assign b = 32'h1D800000;
    #10 assign a = 32'h16FFFFFF; assign b = 32'h1DFFFFFF;

    #10 $fwrite(outfile,"\n2**-81 * 2**-69:");
    #10 assign a = 32'h17000000; assign b = 32'h1D000000;
    #10 assign a = 32'h177FFFFF; assign b = 32'h1D7FFFFF;

    #10 $fwrite(outfile,"\n2**-80 * 2**-70:");
    #10 assign a = 32'h17800000; assign b = 32'h1C800000;
    #10 assign a = 32'h17FFFFFF; assign b = 32'h1CFFFFFF;

    #10 $fwrite(outfile,"\n2**-79 * 2**-71:");
    #10 assign a = 32'h18000000; assign b = 32'h1C000000;
    #10 assign a = 32'h187FFFFF; assign b = 32'h1C7FFFFF;

    #10 $fwrite(outfile,"\n2**-78 * 2**-72:");
    #10 assign a = 32'h18800000; assign b = 32'h1B800000;
    #10 assign a = 32'h18FFFFFF; assign b = 32'h1BFFFFFF;

    #10 $fwrite(outfile,"\n2**-77 * 2**-73:");
    #10 assign a = 32'h19000000; assign b = 32'h1B000000;
    #10 assign a = 32'h197FFFFF; assign b = 32'h1B7FFFFF;

    #10 $fwrite(outfile,"\n2**-76 * 2**-74:");
    #10 assign a = 32'h19800000; assign b = 32'h1A800000;
    #10 assign a = 32'h19FFFFFF; assign b = 32'h1AFFFFFF;

    #10 $fwrite(outfile,"\n2**-75 * 2**-75:");
    #10 assign a = 32'h1A000000; assign b = 32'h1A000000;
    #10 assign a = 32'h1A7FFFFF; assign b = 32'h1A7FFFFF;

    #10 $fwrite(outfile,"\n2**-74 * 2**-76:");
    #10 assign a = 32'h1A800000; assign b = 32'h19800000;
    #10 assign a = 32'h1AFFFFFF; assign b = 32'h19FFFFFF;

    #10 $fwrite(outfile,"\n2**-73 * 2**-77:");
    #10 assign a = 32'h1B000000; assign b = 32'h19000000;
    #10 assign a = 32'h1B7FFFFF; assign b = 32'h197FFFFF;

    #10 $fwrite(outfile,"\n2**-72 * 2**-78:");
    #10 assign a = 32'h1B800000; assign b = 32'h18800000;
    #10 assign a = 32'h1BFFFFFF; assign b = 32'h18FFFFFF;

    #10 $fwrite(outfile,"\n2**-71 * 2**-79:");
    #10 assign a = 32'h1C000000; assign b = 32'h18000000;
    #10 assign a = 32'h1C7FFFFF; assign b = 32'h187FFFFF;

    #10 $fwrite(outfile,"\n2**-70 * 2**-80:");
    #10 assign a = 32'h1C800000; assign b = 32'h17800000;
    #10 assign a = 32'h1CFFFFFF; assign b = 32'h17FFFFFF;

    #10 $fwrite(outfile,"\n2**-69 * 2**-81:");
    #10 assign a = 32'h1D000000; assign b = 32'h17000000;
    #10 assign a = 32'h1D7FFFFF; assign b = 32'h177FFFFF;

    #10 $fwrite(outfile,"\n2**-68 * 2**-82:");
    #10 assign a = 32'h1D800000; assign b = 32'h16800000;
    #10 assign a = 32'h1DFFFFFF; assign b = 32'h16FFFFFF;

    #10 $fwrite(outfile,"\n2**-67 * 2**-83:");
    #10 assign a = 32'h1E000000; assign b = 32'h16000000;
    #10 assign a = 32'h1E7FFFFF; assign b = 32'h167FFFFF;

    #10 $fwrite(outfile,"\n2**-66 * 2**-84:");
    #10 assign a = 32'h1E800000; assign b = 32'h15800000;
    #10 assign a = 32'h1EFFFFFF; assign b = 32'h15FFFFFF;

    #10 $fwrite(outfile,"\n2**-65 * 2**-85:");
    #10 assign a = 32'h1F000000; assign b = 32'h15000000;
    #10 assign a = 32'h1F7FFFFF; assign b = 32'h157FFFFF;

    #10 $fwrite(outfile,"\n2**-64 * 2**-86:");
    #10 assign a = 32'h1F800000; assign b = 32'h14800000;
    #10 assign a = 32'h1FFFFFFF; assign b = 32'h14FFFFFF;

    #10 $fwrite(outfile,"\n2**-63 * 2**-87:");
    #10 assign a = 32'h20000000; assign b = 32'h14000000;
    #10 assign a = 32'h207FFFFF; assign b = 32'h147FFFFF;

    #10 $fwrite(outfile,"\n2**-62 * 2**-88:");
    #10 assign a = 32'h20800000; assign b = 32'h13800000;
    #10 assign a = 32'h20FFFFFF; assign b = 32'h13FFFFFF;

    #10 $fwrite(outfile,"\n2**-61 * 2**-89:");
    #10 assign a = 32'h21000000; assign b = 32'h13000000;
    #10 assign a = 32'h217FFFFF; assign b = 32'h137FFFFF;

    #10 $fwrite(outfile,"\n2**-60 * 2**-90:");
    #10 assign a = 32'h21800000; assign b = 32'h12800000;
    #10 assign a = 32'h21FFFFFF; assign b = 32'h12FFFFFF;

    #10 $fwrite(outfile,"\n2**-59 * 2**-91:");
    #10 assign a = 32'h22000000; assign b = 32'h12000000;
    #10 assign a = 32'h227FFFFF; assign b = 32'h127FFFFF;

    #10 $fwrite(outfile,"\n2**-58 * 2**-92:");
    #10 assign a = 32'h22800000; assign b = 32'h11800000;
    #10 assign a = 32'h22FFFFFF; assign b = 32'h11FFFFFF;

    #10 $fwrite(outfile,"\n2**-57 * 2**-93:");
    #10 assign a = 32'h23000000; assign b = 32'h11000000;
    #10 assign a = 32'h237FFFFF; assign b = 32'h117FFFFF;

    #10 $fwrite(outfile,"\n2**-56 * 2**-94:");
    #10 assign a = 32'h23800000; assign b = 32'h10800000;
    #10 assign a = 32'h23FFFFFF; assign b = 32'h10FFFFFF;

    #10 $fwrite(outfile,"\n2**-55 * 2**-95:");
    #10 assign a = 32'h24000000; assign b = 32'h10000000;
    #10 assign a = 32'h247FFFFF; assign b = 32'h107FFFFF;

    #10 $fwrite(outfile,"\n2**-54 * 2**-96:");
    #10 assign a = 32'h24800000; assign b = 32'h0F800000;
    #10 assign a = 32'h24FFFFFF; assign b = 32'h0FFFFFFF;

    #10 $fwrite(outfile,"\n2**-53 * 2**-97:");
    #10 assign a = 32'h25000000; assign b = 32'h0F000000;
    #10 assign a = 32'h257FFFFF; assign b = 32'h0F7FFFFF;

    #10 $fwrite(outfile,"\n2**-52 * 2**-98:");
    #10 assign a = 32'h25800000; assign b = 32'h0E800000;
    #10 assign a = 32'h25FFFFFF; assign b = 32'h0EFFFFFF;

    #10 $fwrite(outfile,"\n2**-51 * 2**-99:");
    #10 assign a = 32'h26000000; assign b = 32'h0E000000;
    #10 assign a = 32'h267FFFFF; assign b = 32'h0E7FFFFF;

    #10 $fwrite(outfile,"\n2**-50 * 2**-100:");
    #10 assign a = 32'h26800000; assign b = 32'h0D800000;
    #10 assign a = 32'h26FFFFFF; assign b = 32'h0DFFFFFF;

    #10 $fwrite(outfile,"\n2**-49 * 2**-101:");
    #10 assign a = 32'h27000000; assign b = 32'h0D000000;
    #10 assign a = 32'h277FFFFF; assign b = 32'h0D7FFFFF;

    #10 $fwrite(outfile,"\n2**-48 * 2**-102:");
    #10 assign a = 32'h27800000; assign b = 32'h0C800000;
    #10 assign a = 32'h27FFFFFF; assign b = 32'h0CFFFFFF;

    #10 $fwrite(outfile,"\n2**-47 * 2**-103:");
    #10 assign a = 32'h28000000; assign b = 32'h0C000000;
    #10 assign a = 32'h287FFFFF; assign b = 32'h0C7FFFFF;

    #10 $fwrite(outfile,"\n2**-46 * 2**-104:");
    #10 assign a = 32'h28800000; assign b = 32'h0B800000;
    #10 assign a = 32'h28FFFFFF; assign b = 32'h0BFFFFFF;

    #10 $fwrite(outfile,"\n2**-45 * 2**-105:");
    #10 assign a = 32'h29000000; assign b = 32'h0B000000;
    #10 assign a = 32'h297FFFFF; assign b = 32'h0B7FFFFF;

    #10 $fwrite(outfile,"\n2**-44 * 2**-106:");
    #10 assign a = 32'h29800000; assign b = 32'h0A800000;
    #10 assign a = 32'h29FFFFFF; assign b = 32'h0AFFFFFF;

    #10 $fwrite(outfile,"\n2**-43 * 2**-107:");
    #10 assign a = 32'h2A000000; assign b = 32'h0A000000;
    #10 assign a = 32'h2A7FFFFF; assign b = 32'h0A7FFFFF;

    #10 $fwrite(outfile,"\n2**-42 * 2**-108:");
    #10 assign a = 32'h2A800000; assign b = 32'h09800000;
    #10 assign a = 32'h2AFFFFFF; assign b = 32'h09FFFFFF;

    #10 $fwrite(outfile,"\n2**-41 * 2**-109:");
    #10 assign a = 32'h2B000000; assign b = 32'h09000000;
    #10 assign a = 32'h2B7FFFFF; assign b = 32'h097FFFFF;

    #10 $fwrite(outfile,"\n2**-40 * 2**-110:");
    #10 assign a = 32'h2B800000; assign b = 32'h08800000;
    #10 assign a = 32'h2BFFFFFF; assign b = 32'h08FFFFFF;

    #10 $fwrite(outfile,"\n2**-39 * 2**-111:");
    #10 assign a = 32'h2C000000; assign b = 32'h08000000;
    #10 assign a = 32'h2C7FFFFF; assign b = 32'h087FFFFF;

    #10 $fwrite(outfile,"\n2**-38 * 2**-112:");
    #10 assign a = 32'h2C800000; assign b = 32'h07800000;
    #10 assign a = 32'h2CFFFFFF; assign b = 32'h07FFFFFF;

    #10 $fwrite(outfile,"\n2**-37 * 2**-113:");
    #10 assign a = 32'h2D000000; assign b = 32'h07000000;
    #10 assign a = 32'h2D7FFFFF; assign b = 32'h077FFFFF;

    #10 $fwrite(outfile,"\n2**-36 * 2**-114:");
    #10 assign a = 32'h2D800000; assign b = 32'h06800000;
    #10 assign a = 32'h2DFFFFFF; assign b = 32'h06FFFFFF;

    #10 $fwrite(outfile,"\n2**-35 * 2**-115:");
    #10 assign a = 32'h2E000000; assign b = 32'h06000000;
    #10 assign a = 32'h2E7FFFFF; assign b = 32'h067FFFFF;

    #10 $fwrite(outfile,"\n2**-34 * 2**-116:");
    #10 assign a = 32'h2E800000; assign b = 32'h05800000;
    #10 assign a = 32'h2EFFFFFF; assign b = 32'h05FFFFFF;

    #10 $fwrite(outfile,"\n2**-33 * 2**-117:");
    #10 assign a = 32'h2F000000; assign b = 32'h05000000;
    #10 assign a = 32'h2F7FFFFF; assign b = 32'h057FFFFF;

    #10 $fwrite(outfile,"\n2**-32 * 2**-118:");
    #10 assign a = 32'h2F800000; assign b = 32'h04800000;
    #10 assign a = 32'h2FFFFFFF; assign b = 32'h04FFFFFF;

    #10 $fwrite(outfile,"\n2**-31 * 2**-119:");
    #10 assign a = 32'h30000000; assign b = 32'h04000000;
    #10 assign a = 32'h307FFFFF; assign b = 32'h047FFFFF;

    #10 $fwrite(outfile,"\n2**-30 * 2**-120:");
    #10 assign a = 32'h30800000; assign b = 32'h03800000;
    #10 assign a = 32'h30FFFFFF; assign b = 32'h03FFFFFF;

    #10 $fwrite(outfile,"\n2**-29 * 2**-121:");
    #10 assign a = 32'h31000000; assign b = 32'h03000000;
    #10 assign a = 32'h317FFFFF; assign b = 32'h037FFFFF;

    #10 $fwrite(outfile,"\n2**-28 * 2**-122:");
    #10 assign a = 32'h31800000; assign b = 32'h02800000;
    #10 assign a = 32'h31FFFFFF; assign b = 32'h02FFFFFF;

    #10 $fwrite(outfile,"\n2**-27 * 2**-123:");
    #10 assign a = 32'h32000000; assign b = 32'h02000000;
    #10 assign a = 32'h327FFFFF; assign b = 32'h027FFFFF;

    #10 $fwrite(outfile,"\n2**-26 * 2**-124:");
    #10 assign a = 32'h32800000; assign b = 32'h01800000;
    #10 assign a = 32'h32FFFFFF; assign b = 32'h01FFFFFF;

    #10 $fwrite(outfile,"\n2**-25 * 2**-125:");
    #10 assign a = 32'h33000000; assign b = 32'h01000000;
    #10 assign a = 32'h337FFFFF; assign b = 32'h017FFFFF;

    #10 $fwrite(outfile,"\n2**-24 * 2**-126:");
    #10 assign a = 32'h33800000; assign b = 32'h00800000;
    #10 assign a = 32'h33FFFFFF; assign b = 32'h00FFFFFF;

    #10 $fwrite(outfile,"\n2**-23 * 2**-127:");
    #10 assign a = 32'h34000000; assign b = 32'h00400000;
    #10 assign a = 32'h347FFFFF; assign b = 32'h007FFFFF;

    #10 $fwrite(outfile,"\n2**-22 * 2**-128:");
    #10 assign a = 32'h34800000; assign b = 32'h00200000;
    #10 assign a = 32'h34FFFFFF; assign b = 32'h003FFFFF;

    #10 $fwrite(outfile,"\n2**-21 * 2**-129:");
    #10 assign a = 32'h35000000; assign b = 32'h00100000;
    #10 assign a = 32'h357FFFFF; assign b = 32'h001FFFFF;

    #10 $fwrite(outfile,"\n2**-20 * 2**-130:");
    #10 assign a = 32'h35800000; assign b = 32'h00080000;
    #10 assign a = 32'h35FFFFFF; assign b = 32'h000FFFFF;

    #10 $fwrite(outfile,"\n2**-19 * 2**-131:");
    #10 assign a = 32'h36000000; assign b = 32'h00040000;
    #10 assign a = 32'h367FFFFF; assign b = 32'h0007FFFF;

    #10 $fwrite(outfile,"\n2**-18 * 2**-132:");
    #10 assign a = 32'h36800000; assign b = 32'h00020000;
    #10 assign a = 32'h36FFFFFF; assign b = 32'h0003FFFF;

    #10 $fwrite(outfile,"\n2**-17 * 2**-133:");
    #10 assign a = 32'h37000000; assign b = 32'h00010000;
    #10 assign a = 32'h377FFFFF; assign b = 32'h0001FFFF;

    #10 $fwrite(outfile,"\n2**-16 * 2**-134:");
    #10 assign a = 32'h37800000; assign b = 32'h00008000;
    #10 assign a = 32'h37FFFFFF; assign b = 32'h0000FFFF;

    #10 $fwrite(outfile,"\n2**-15 * 2**-135:");
    #10 assign a = 32'h38000000; assign b = 32'h00004000;
    #10 assign a = 32'h387FFFFF; assign b = 32'h00007FFF;

    #10 $fwrite(outfile,"\n2**-14 * 2**-136:");
    #10 assign a = 32'h38800000; assign b = 32'h00002000;
    #10 assign a = 32'h38FFFFFF; assign b = 32'h00003FFF;

    #10 $fwrite(outfile,"\n2**-13 * 2**-137:");
    #10 assign a = 32'h39000000; assign b = 32'h00001000;
    #10 assign a = 32'h397FFFFF; assign b = 32'h00001FFF;

    #10 $fwrite(outfile,"\n2**-12 * 2**-138:");
    #10 assign a = 32'h39800000; assign b = 32'h00000800;
    #10 assign a = 32'h39FFFFFF; assign b = 32'h00000FFF;

    #10 $fwrite(outfile,"\n2**-11 * 2**-139:");
    #10 assign a = 32'h3A000000; assign b = 32'h00000400;
    #10 assign a = 32'h3A7FFFFF; assign b = 32'h000007FF;

    #10 $fwrite(outfile,"\n2**-10 * 2**-140:");
    #10 assign a = 32'h3A800000; assign b = 32'h00000200;
    #10 assign a = 32'h3AFFFFFF; assign b = 32'h000003FF;

    #10 $fwrite(outfile,"\n2**-9 * 2**-141:");
    #10 assign a = 32'h3B000000; assign b = 32'h00000100;
    #10 assign a = 32'h3B7FFFFF; assign b = 32'h000001FF;

    #10 $fwrite(outfile,"\n2**-8 * 2**-142:");
    #10 assign a = 32'h3B800000; assign b = 32'h00000080;
    #10 assign a = 32'h3BFFFFFF; assign b = 32'h000000FF;

    #10 $fwrite(outfile,"\n2**-7 * 2**-143:");
    #10 assign a = 32'h3C000000; assign b = 32'h00000040;
    #10 assign a = 32'h3C7FFFFF; assign b = 32'h0000007F;

    #10 $fwrite(outfile,"\n2**-6 * 2**-144:");
    #10 assign a = 32'h3C800000; assign b = 32'h00000020;
    #10 assign a = 32'h3CFFFFFF; assign b = 32'h0000003F;

    #10 $fwrite(outfile,"\n2**-5 * 2**-145:");
    #10 assign a = 32'h3D000000; assign b = 32'h00000010;
    #10 assign a = 32'h3D7FFFFF; assign b = 32'h0000001F;

    #10 $fwrite(outfile,"\n2**-4 * 2**-146:");
    #10 assign a = 32'h3D800000; assign b = 32'h00000008;
    #10 assign a = 32'h3DFFFFFF; assign b = 32'h0000000F;

    #10 $fwrite(outfile,"\n2**-3 * 2**-147:");
    #10 assign a = 32'h3E000000; assign b = 32'h00000004;
    #10 assign a = 32'h3E7FFFFF; assign b = 32'h00000007;

    #10 $fwrite(outfile,"\n2**-2 * 2**-148:");
    #10 assign a = 32'h3E800000; assign b = 32'h00000002;
    #10 assign a = 32'h3EFFFFFF; assign b = 32'h00000003;


        
	// 100 test cases for arbitrary positive values 
    
	#10 $fwrite(outfile,"\n1. 21.33064 * 20.5429 = 438.193204456 (32'h43DB18BB):");
	#10 assign a = 32'h41AAA527; assign b = 32'h41A457DC;

	#10 $fwrite(outfile,"\n2. 34.64444 * 43.15594 = 1495.1133739736 (32'h44BAE3A1):");
	#10 assign a = 32'h420A93E8; assign b = 32'h422C9FAF;

	#10 $fwrite(outfile,"\n3. 49.82766 * 30.20129 = 1504.8596096814 (32'h44BC1B82):");
	#10 assign a = 32'h42474F86; assign b = 32'h41F19C3E;

	#10 $fwrite(outfile,"\n4. 40.57014 * 0.26181 = 10.6216683534 (32'h4129F25B):");
	#10 assign a = 32'h422247D3; assign b = 32'h3E860BF6;

	#10 $fwrite(outfile,"\n5. 25.23815 * 43.63195 = 1101.1896988925 (32'h4489A612):");
	#10 assign a = 32'h41C9E7BB; assign b = 32'h422E871E;

	#10 $fwrite(outfile,"\n6. 25.2234 * 19.16495 = 483.40519983 (32'h43F1B3DE):");
	#10 assign a = 32'h41C9C986; assign b = 32'h419951D1;

	#10 $fwrite(outfile,"\n7. 14.19121 * 46.42808 = 658.8706331768 (32'h4424B7B8):");
	#10 assign a = 32'h41630F32; assign b = 32'h4239B65B;

	#10 $fwrite(outfile,"\n8. 42.63086 * 3.388 = 144.43335368 (32'h43106EF0):");
	#10 assign a = 32'h422A8600; assign b = 32'h4058D4FE;

	#10 $fwrite(outfile,"\n9. 45.48003 * 43.29104 = 1968.8777979312 (32'h44F61C17):");
	#10 assign a = 32'h4235EB8D; assign b = 32'h422D2A06;

	#10 $fwrite(outfile,"\n10. 7.72687 * 23.83191 = 184.1460704217 (32'h43382565):");
	#10 assign a = 32'h40F74285; assign b = 32'h41BEA7C0;

	#10 $fwrite(outfile,"\n11. 21.75232 * 21.61989 = 470.2827656448 (32'h43EB2432):");
	#10 assign a = 32'h41AE04C0; assign b = 32'h41ACF589;

	#10 $fwrite(outfile,"\n12. 25.18067 * 10.34753 = 260.5577382451 (32'h43824764):");
	#10 assign a = 32'h41C97203; assign b = 32'h41258F7C;

	#10 $fwrite(outfile,"\n13. 5.3023 * 20.37289 = 108.023174647 (32'h42D80BDE):");
	#10 assign a = 32'h40A9AC71; assign b = 32'h41A2FBAE;

	#10 $fwrite(outfile,"\n14. 22.91847 * 6.14313 = 140.7911406111 (32'h430CCA88):");
	#10 assign a = 32'h41B75907; assign b = 32'h40C49485;

	#10 $fwrite(outfile,"\n15. 12.97748 * 40.27589 = 522.6795569572 (32'h4402AB7E):");
	#10 assign a = 32'h414FA3C2; assign b = 32'h42211A83;

	#10 $fwrite(outfile,"\n16. 0.87366 * 10.39747 = 9.0838536402 (32'h41115777):");
	#10 assign a = 32'h3F5FA82F; assign b = 32'h41265C0A;

	#10 $fwrite(outfile,"\n17. 12.38633 * 43.53808 = 539.2770264464 (32'h4406D1BB):");
	#10 assign a = 32'h41462E68; assign b = 32'h422E26FE;

	#10 $fwrite(outfile,"\n18. 37.29262 * 5.70071 = 212.5944117602 (32'h4354982B):");
	#10 assign a = 32'h42152BA5; assign b = 32'h40B66C37;

	#10 $fwrite(outfile,"\n19. 4.97839 * 20.2927 = 101.024974753 (32'h42CA0CC9):");
	#10 assign a = 32'h409F4EF9; assign b = 32'h41A25773;

	#10 $fwrite(outfile,"\n20. 7.05778 * 22.65633 = 159.9033927474 (32'h431FE745):");
	#10 assign a = 32'h40E1D955; assign b = 32'h41B5402A;

	#10 $fwrite(outfile,"\n21. 9.68317 * 10.04648 = 97.2817737416 (32'h42C29045):");
	#10 assign a = 32'h411AEE44; assign b = 32'h4120BE62;

	#10 $fwrite(outfile,"\n22. 2.41989 * 7.28356 = 17.6254140084 (32'h418D00D9):");
	#10 assign a = 32'h401ADF7A; assign b = 32'h40E912EC;

	#10 $fwrite(outfile,"\n23. 23.94216 * 12.64505 = 302.749810308 (32'h43975FFA):");
	#10 assign a = 32'h41BF898B; assign b = 32'h414A5220;

	#10 $fwrite(outfile,"\n24. 27.81376 * 34.64033 = 963.4778249408 (32'h4470DE95):");
	#10 assign a = 32'h41DE8295; assign b = 32'h420A8FB3;

	#10 $fwrite(outfile,"\n25. 30.18049 * 37.95293 = 1145.4380243357 (32'h448F2E04):");
	#10 assign a = 32'h41F171A5; assign b = 32'h4217CFCD;

	#10 $fwrite(outfile,"\n26. 49.27441 * 37.22778 = 1834.3768951098 (32'h44E54C10):");
	#10 assign a = 32'h424518FF; assign b = 32'h4214E93F;

	#10 $fwrite(outfile,"\n27. 44.1563 * 49.24738 = 2174.582085494 (32'h4507E950):");
	#10 assign a = 32'h4230A00D; assign b = 32'h4244FD51;

	#10 $fwrite(outfile,"\n28. 32.09347 * 48.74233 = 1564.3105055851 (32'h44C389F0):");
	#10 assign a = 32'h42005FB7; assign b = 32'h4242F825;

	#10 $fwrite(outfile,"\n29. 39.17404 * 8.02627 = 314.4214220308 (32'h439D35F1):");
	#10 assign a = 32'h421CB238; assign b = 32'h41006B9A;

	#10 $fwrite(outfile,"\n30. 35.90011 * 31.97838 = 1148.0273596218 (32'h448F80E0):");
	#10 assign a = 32'h420F99B6; assign b = 32'h41FFD3B9;

	#10 $fwrite(outfile,"\n31. 35.06143 * 10.46225 = 366.8214460175 (32'h43B76925):");
	#10 assign a = 32'h420C3EE8; assign b = 32'h41276560;

	#10 $fwrite(outfile,"\n32. 30.70528 * 45.72315 = 1403.942123232 (32'h44AF7E26):");
	#10 assign a = 32'h41F5A46A; assign b = 32'h4236E481;

	#10 $fwrite(outfile,"\n33. 42.95115 * 32.74506 = 1406.437983819 (32'h44AFCE04):");
	#10 assign a = 32'h422BCDFA; assign b = 32'h4202FAF1;

	#10 $fwrite(outfile,"\n34. 32.9529 * 41.20032 = 1357.670024928 (32'h44A9B571):");
	#10 assign a = 32'h4203CFC5; assign b = 32'h4224CD21;

	#10 $fwrite(outfile,"\n35. 40.35711 * 31.89863 = 1287.3365197593 (32'h44A0EAC5):");
	#10 assign a = 32'h42216DAE; assign b = 32'h41FF3065;

	#10 $fwrite(outfile,"\n36. 43.34325 * 36.3215 = 1574.291854875 (32'h44C4C957):");
	#10 assign a = 32'h422D5F7D; assign b = 32'h42114937;

	#10 $fwrite(outfile,"\n37. 20.46764 * 20.89584 = 427.6885306176 (32'h43D5D822):");
	#10 assign a = 32'h41A3BDBA; assign b = 32'h41A72AAE;

	#10 $fwrite(outfile,"\n38. 29.54474 * 22.89069 = 676.2994844706 (32'h4429132B):");
	#10 assign a = 32'h41EC5BA1; assign b = 32'h41B72022;

	#10 $fwrite(outfile,"\n39. 2.82972 * 6.3697 = 18.024467484 (32'h4190321C):");
	#10 assign a = 32'h40351A22; assign b = 32'h40CBD495;

	#10 $fwrite(outfile,"\n40. 42.86841 * 36.50752 = 1565.0193354432 (32'h44C3A09E):");
	#10 assign a = 32'h422B7940; assign b = 32'h421207B3;

	#10 $fwrite(outfile,"\n41. 16.74301 * 23.89115 = 400.0097633615 (32'h43C80140):");
	#10 assign a = 32'h4185F1AF; assign b = 32'h41BF2113;

	#10 $fwrite(outfile,"\n42. 0.83746 * 43.63108 = 36.5392842568 (32'h4212283A):");
	#10 assign a = 32'h3F5663C7; assign b = 32'h422E863A;

	#10 $fwrite(outfile,"\n43. 39.21982 * 41.2824 = 1619.088297168 (32'h44CA62D3):");
	#10 assign a = 32'h421CE118; assign b = 32'h4225212D;

	#10 $fwrite(outfile,"\n44. 19.95938 * 38.45888 = 767.6154002944 (32'h443FE763):");
	#10 assign a = 32'h419FACCF; assign b = 32'h4219D5E5;

	#10 $fwrite(outfile,"\n45. 41.49173 * 3.93543 = 163.2877989939 (32'h432349AD):");
	#10 assign a = 32'h4225F788; assign b = 32'h407BDE16;

	#10 $fwrite(outfile,"\n46. 25.52247 * 46.44446 = 1185.3773370162 (32'h44942C13):");
	#10 assign a = 32'h41CC2E05; assign b = 32'h4239C721;

	#10 $fwrite(outfile,"\n47. 2.84387 * 33.14339 = 94.2554925193 (32'h42BC82D0):");
	#10 assign a = 32'h403601F7; assign b = 32'h420492D5;

	#10 $fwrite(outfile,"\n48. 23.41243 * 46.24354 = 1082.6736432022 (32'h4487558E):");
	#10 assign a = 32'h41BB4CA8; assign b = 32'h4238F963;

	#10 $fwrite(outfile,"\n49. 36.84249 * 35.64268 = 1313.1650814732 (32'h44A42548):");
	#10 assign a = 32'h42135EB6; assign b = 32'h420E921B;

	#10 $fwrite(outfile,"\n50. 20.47048 * 15.54281 = 318.1687812488 (32'h439F159B):");
	#10 assign a = 32'h41A3C38B; assign b = 32'h4178AF5A;

	#10 $fwrite(outfile,"\n51. 3.1331 * 47.18922 = 147.848545182 (32'h4313D93A):");
	#10 assign a = 32'h404884B6; assign b = 32'h423CC1C3;

	#10 $fwrite(outfile,"\n52. 36.69063 * 10.31121 = 378.3247909623 (32'h43BD2993):");
	#10 assign a = 32'h4212C335; assign b = 32'h4124FAB7;

	#10 $fwrite(outfile,"\n53. 18.11037 * 34.65319 = 627.5820925803 (32'h441CE541):");
	#10 assign a = 32'h4190E20A; assign b = 32'h420A9CDE;

	#10 $fwrite(outfile,"\n54. 11.12172 * 32.84027 = 365.2402876644 (32'h43B69EC2):");
	#10 assign a = 32'h4131F291; assign b = 32'h42035C70;

	#10 $fwrite(outfile,"\n55. 18.43644 * 37.08091 = 683.6399723604 (32'h442AE8F5):");
	#10 assign a = 32'h41937DD4; assign b = 32'h421452DA;

	#10 $fwrite(outfile,"\n56. 22.27815 * 31.63234 = 704.710015371 (32'h44302D71):");
	#10 assign a = 32'h41B239A7; assign b = 32'h41FD0F08;

	#10 $fwrite(outfile,"\n57. 1.05437 * 19.71991 = 20.7920815067 (32'h41A6562F):");
	#10 assign a = 32'h3F86F599; assign b = 32'h419DC260;

	#10 $fwrite(outfile,"\n58. 14.24732 * 45.98826 = 655.2094564632 (32'h4423CD68):");
	#10 assign a = 32'h4163F506; assign b = 32'h4237F3FA;

	#10 $fwrite(outfile,"\n59. 27.77243 * 26.4894 = 735.675007242 (32'h4437EB33):");
	#10 assign a = 32'h41DE2DF0; assign b = 32'h41D3EA4B;

	#10 $fwrite(outfile,"\n60. 10.47222 * 24.35963 = 255.0994044786 (32'h437F1973):");
	#10 assign a = 32'h41278E37; assign b = 32'h41C2E086;

	#10 $fwrite(outfile,"\n61. 34.00533 * 36.47124 = 1240.2165517092 (32'h449B06EE):");
	#10 assign a = 32'h42080575; assign b = 32'h4211E28D;

	#10 $fwrite(outfile,"\n62. 16.9483 * 9.3881 = 159.11233523 (32'h431F1CC2):");
	#10 assign a = 32'h4187961E; assign b = 32'h411635A8;

	#10 $fwrite(outfile,"\n63. 20.07922 * 21.24932 = 426.6697711304 (32'h43D555BB):");
	#10 assign a = 32'h41A0A23E; assign b = 32'h41A9FE9B;

	#10 $fwrite(outfile,"\n64. 31.07165 * 48.34604 = 1502.191233766 (32'h44BBC61F):");
	#10 assign a = 32'h41F892BD; assign b = 32'h42416258;

	#10 $fwrite(outfile,"\n65. 39.58185 * 42.92577 = 1699.0813892745 (32'h44D4629B):");
	#10 assign a = 32'h421E53D0; assign b = 32'h422BB3FD;

	#10 $fwrite(outfile,"\n66. 40.79125 * 13.78852 = 562.45096645 (32'h440C9CDD):");
	#10 assign a = 32'h42232A3D; assign b = 32'h415C9DC7;

	#10 $fwrite(outfile,"\n67. 49.14914 * 14.31337 = 703.4898260018 (32'h442FDF59):");
	#10 assign a = 32'h424498B8; assign b = 32'h41650390;

	#10 $fwrite(outfile,"\n68. 48.90288 * 31.38267 = 1534.7029450896 (32'h44BFD67F):");
	#10 assign a = 32'h42439C8D; assign b = 32'h41FB0FB5;

	#10 $fwrite(outfile,"\n69. 15.58908 * 12.67054 = 197.5220617032 (32'h434585A6):");
	#10 assign a = 32'h41796CDF; assign b = 32'h414ABA88;

	#10 $fwrite(outfile,"\n70. 26.88205 * 21.83223 = 586.8950984715 (32'h4412B949):");
	#10 assign a = 32'h41D70E70; assign b = 32'h41AEA868;

	#10 $fwrite(outfile,"\n71. 2.54914 * 14.02421 = 35.7496746794 (32'h420EFFAB):");
	#10 assign a = 32'h4023251C; assign b = 32'h4160632A;

	#10 $fwrite(outfile,"\n72. 43.75462 * 40.77338 = 1784.0237480156 (32'h44DF00C3):");
	#10 assign a = 32'h422F04BB; assign b = 32'h422317F1;

	#10 $fwrite(outfile,"\n73. 44.94709 * 33.57958 = 1509.3044044222 (32'h44BCA9BE):");
	#10 assign a = 32'h4233C9D2; assign b = 32'h4206517D;

	#10 $fwrite(outfile,"\n74. 34.89081 * 21.61435 = 754.1421791235 (32'h443C8919):");
	#10 assign a = 32'h420B9030; assign b = 32'h41ACEA30;

	#10 $fwrite(outfile,"\n75. 22.92209 * 44.37212 = 1017.1017281308 (32'h447E4683):");
	#10 assign a = 32'h41B76071; assign b = 32'h42317D0D;

	#10 $fwrite(outfile,"\n76. 17.23063 * 18.77765 = 323.5507394195 (32'h43A1C67F):");
	#10 assign a = 32'h4189D855; assign b = 32'h419638A1;

	#10 $fwrite(outfile,"\n77. 41.55691 * 33.73578 = 1401.9547732398 (32'h44AF3E8E):");
	#10 assign a = 32'h42263A47; assign b = 32'h4206F170;

	#10 $fwrite(outfile,"\n78. 21.98198 * 49.15367 = 1080.4949908666 (32'h44870FD7):");
	#10 assign a = 32'h41AFDB18; assign b = 32'h42449D5C;

	#10 $fwrite(outfile,"\n79. 47.05271 * 37.76279 = 1776.8416066609 (32'h44DE1AEE):");
	#10 assign a = 32'h423C35FA; assign b = 32'h42170D19;

	#10 $fwrite(outfile,"\n80. 4.62627 * 5.6165 = 25.983445455 (32'h41CFDE19):");
	#10 assign a = 32'h40940A67; assign b = 32'h40B3BA5E;

	#10 $fwrite(outfile,"\n81. 34.37219 * 49.44189 = 1699.4260370391 (32'h44D46DA2):");
	#10 assign a = 32'h42097D1F; assign b = 32'h4245C47F;

	#10 $fwrite(outfile,"\n82. 39.03477 * 5.93127 = 231.5257602579 (32'h43678698):");
	#10 assign a = 32'h421C239B; assign b = 32'h40BDCCF7;

	#10 $fwrite(outfile,"\n83. 41.19118 * 46.17379 = 1901.9528951722 (32'h44EDBE7E):");
	#10 assign a = 32'h4224C3C5; assign b = 32'h4238B1F6;

	#10 $fwrite(outfile,"\n84. 25.77959 * 3.21197 = 82.8032696923 (32'h42A59B46):");
	#10 assign a = 32'h41CE3C9A; assign b = 32'h404D90EB;

	#10 $fwrite(outfile,"\n85. 26.54989 * 35.74749 = 949.0919272761 (32'h446D45E2):");
	#10 assign a = 32'h41D4662D; assign b = 32'h420EFD6E;

	#10 $fwrite(outfile,"\n86. 36.00473 * 45.33666 = 1632.3342024018 (32'h44CC0AB2):");
	#10 assign a = 32'h421004D8; assign b = 32'h423558BD;

	#10 $fwrite(outfile,"\n87. 39.56187 * 41.37242 = 1636.7703016254 (32'h44CC98A6):");
	#10 assign a = 32'h421E3F5B; assign b = 32'h42257D5C;

	#10 $fwrite(outfile,"\n88. 27.1526 * 45.38667 = 1232.366095842 (32'h449A0BB7):");
	#10 assign a = 32'h41D93886; assign b = 32'h42358BF3;

	#10 $fwrite(outfile,"\n89. 16.60735 * 38.43071 = 638.2322517185 (32'h441F8EDD):");
	#10 assign a = 32'h4184DBDA; assign b = 32'h4219B90C;

	#10 $fwrite(outfile,"\n90. 39.24198 * 43.26909 = 1697.9647643982 (32'h44D43EDF):");
	#10 assign a = 32'h421CF7CA; assign b = 32'h422D138C;

	#10 $fwrite(outfile,"\n91. 43.69209 * 28.91979 = 1263.5660674611 (32'h449DF21D):");
	#10 assign a = 32'h422EC4B3; assign b = 32'h41E75BBB;

	#10 $fwrite(outfile,"\n92. 33.67568 * 11.04147 = 371.8290104496 (32'h43B9EA1D):");
	#10 assign a = 32'h4206B3E5; assign b = 32'h4130A9DC;

	#10 $fwrite(outfile,"\n93. 11.60812 * 18.15786 = 210.7786178232 (32'h4352C753):");
	#10 assign a = 32'h4139BADC; assign b = 32'h4191434C;

	#10 $fwrite(outfile,"\n94. 2.02512 * 45.7331 = 92.615015472 (32'h42B93AE3):");
	#10 assign a = 32'h40019B91; assign b = 32'h4236EEB2;

	#10 $fwrite(outfile,"\n95. 38.28653 * 1.00493 = 38.4752825929 (32'h4219E6B0):");
	#10 assign a = 32'h42192568; assign b = 32'h3F80A18C;

	#10 $fwrite(outfile,"\n96. 29.86433 * 29.91165 = 893.2913864445 (32'h445F52A6):");
	#10 assign a = 32'h41EEEA26; assign b = 32'h41EF4B0F;

	#10 $fwrite(outfile,"\n97. 31.81767 * 19.2722 = 613.196499774 (32'h44194C93):");
	#10 assign a = 32'h41FE8A97; assign b = 32'h419A2D77;

	#10 $fwrite(outfile,"\n98. 9.08456 * 39.8139 = 361.691763384 (32'h43B4D88C):");
	#10 assign a = 32'h41115A5C; assign b = 32'h421F416F;

	#10 $fwrite(outfile,"\n99. 26.88495 * 19.37034 = 520.770622383 (32'h44023152):");
	#10 assign a = 32'h41D71461; assign b = 32'h419AF675;

	#10 $fwrite(outfile,"\n100. 24.47553 * 39.96817 = 978.2421438801 (32'h44748F7F):");
	#10 assign a = 32'h41C3CDE3; assign b = 32'h421FDF68;


	// 100 test cases for arbitrary number which results in negative product
	
	
	#10 $fwrite(outfile,"\n1. -24.08734 * 9.70874 = -233.8577213516 (32'hC369DB94):");
	#10 assign a = 32'hC1C0B2DF; assign b = 32'h411B5700;

	#10 $fwrite(outfile,"\n2. 39.68895 * -40.36841 = -1602.1798060695 (32'hC4C845C1):");
	#10 assign a = 32'h421EC17C; assign b = 32'hC2217940;

	#10 $fwrite(outfile,"\n3. 25.14409 * -29.41898 = -739.7134808282 (32'hC438EDAA):");
	#10 assign a = 32'h41C92719; assign b = 32'hC1EB5A12;

	#10 $fwrite(outfile,"\n4. 13.89973 * -5.4128 = -75.236458544 (32'hC2967911):");
	#10 assign a = 32'h415E654B; assign b = 32'hC0AD35A8;

	#10 $fwrite(outfile,"\n5. -33.00473 * 45.31553 = -1495.6268324569 (32'hC4BAF40F):");
	#10 assign a = 32'hC20404D8; assign b = 32'h4235431A;

	#10 $fwrite(outfile,"\n6. 29.13623 * -33.04188 = -962.7158153124 (32'hC470ADD0):");
	#10 assign a = 32'h41E91700; assign b = 32'hC2042AE3;

	#10 $fwrite(outfile,"\n7. 15.82525 * -3.67219 = -58.1133247975 (32'hC268740B):");
	#10 assign a = 32'h417D3439; assign b = 32'hC06B0529;

	#10 $fwrite(outfile,"\n8. 10.73159 * -42.08689 = -451.6592478551 (32'hC3E1D462):");
	#10 assign a = 32'h412BB498; assign b = 32'hC22858FA;

	#10 $fwrite(outfile,"\n9. -9.36422 * 25.95852 = -243.0812921544 (32'hC37314D0):");
	#10 assign a = 32'hC115D3D8; assign b = 32'h41CFAB0D;

	#10 $fwrite(outfile,"\n10. -16.86712 * 45.27534 = -763.6645928208 (32'hC43EEA89):");
	#10 assign a = 32'hC186EFDD; assign b = 32'h423519F3;

	#10 $fwrite(outfile,"\n11. -17.30248 * 1.75171 = -30.3089272408 (32'hC1F278AF):");
	#10 assign a = 32'hC18A6B7B; assign b = 32'h3FE03809;

	#10 $fwrite(outfile,"\n12. 1.72397 * -11.80573 = -20.3527243481 (32'hC1A2D261):");
	#10 assign a = 32'h3FDCAB0D; assign b = 32'hC13CE445;

	#10 $fwrite(outfile,"\n13. -18.14455 * 0.88663 = -16.0875023665 (32'hC180B334):");
	#10 assign a = 32'hC191280A; assign b = 32'h3F62FA2F;

	#10 $fwrite(outfile,"\n14. -34.75394 * 40.16125 = -1395.761672825 (32'hC4AE7860):");
	#10 assign a = 32'hC20B0409; assign b = 32'h4220A51F;

	#10 $fwrite(outfile,"\n15. 13.64221 * -10.95636 = -149.4689639556 (32'hC315780E):");
	#10 assign a = 32'h415A467E; assign b = 32'hC12F4D40;

	#10 $fwrite(outfile,"\n16. -18.26764 * 14.42982 = -263.5987570248 (32'hC383CCA4):");
	#10 assign a = 32'hC1922420; assign b = 32'h4166E08B;

	#10 $fwrite(outfile,"\n17. -2.61035 * 2.92411 = -7.6329505385 (32'hC0F44121):");
	#10 assign a = 32'hC0270FF9; assign b = 32'h403B249E;

	#10 $fwrite(outfile,"\n18. 32.24892 * -32.05179 = -1033.6356115668 (32'hC4813457):");
	#10 assign a = 32'h4200FEE5; assign b = 32'hC2003508;

	#10 $fwrite(outfile,"\n19. 23.38834 * -30.11501 = -704.3400929834 (32'hC43015C4):");
	#10 assign a = 32'h41BB1B52; assign b = 32'hC1F0EB8A;

	#10 $fwrite(outfile,"\n20. 31.49139 * -8.53128 = -268.6618656792 (32'hC38654B8):");
	#10 assign a = 32'h41FBEE5E; assign b = 32'hC108801F;

	#10 $fwrite(outfile,"\n21. -42.87891 * 32.12414 = -1377.4481078874 (32'hC4AC2E57):");
	#10 assign a = 32'hC22B8401; assign b = 32'h42007F1F;

	#10 $fwrite(outfile,"\n22. 24.52666 * -2.30563 = -56.5494030958 (32'hC2623297):");
	#10 assign a = 32'h41C4369A; assign b = 32'hC0138F71;

	#10 $fwrite(outfile,"\n23. 12.77918 * -24.97868 = -319.2070478824 (32'hC39F9A81):");
	#10 assign a = 32'h414C7785; assign b = 32'hC1C7D456;

	#10 $fwrite(outfile,"\n24. -49.32923 * 29.57981 = -1459.1492508463 (32'hC4B664C7):");
	#10 assign a = 32'hC2455122; assign b = 32'h41ECA373;

	#10 $fwrite(outfile,"\n25. 20.92851 * -2.83008 = -59.2293575808 (32'hC26CEADD):");
	#10 assign a = 32'h41A76D97; assign b = 32'hC0352008;

	#10 $fwrite(outfile,"\n26. 31.38654 * -39.76905 = -1248.212878587 (32'hC49C06D0):");
	#10 assign a = 32'h41FB17A2; assign b = 32'hC21F1382;

	#10 $fwrite(outfile,"\n27. -48.50048 * 33.88058 = -1643.2243926784 (32'hC4CD672E):");
	#10 assign a = 32'hC242007E; assign b = 32'h420785B7;

	#10 $fwrite(outfile,"\n28. 4.64667 * -0.42591 = -1.9790632197 (32'hBFFD51F2):");
	#10 assign a = 32'h4094B185; assign b = 32'hBEDA10E0;

	#10 $fwrite(outfile,"\n29. -26.93604 * 46.00219 = -1239.1168299276 (32'hC49AE3BD):");
	#10 assign a = 32'hC1D77D03; assign b = 32'h4238023E;

	#10 $fwrite(outfile,"\n30. 45.14711 * -12.90427 = -582.5904971597 (32'hC411A5CB):");
	#10 assign a = 32'h423496A4; assign b = 32'hC14E77E4;

	#10 $fwrite(outfile,"\n31. 30.11844 * -33.00231 = -993.9780935964 (32'hC4787E99):");
	#10 assign a = 32'h41F0F291; assign b = 32'hC204025E;

	#10 $fwrite(outfile,"\n32. -48.55444 * 28.37263 = -1377.6171609772 (32'hC4AC33C0):");
	#10 assign a = 32'hC24237BF; assign b = 32'h41E2FB25;

	#10 $fwrite(outfile,"\n33. 9.24154 * -4.39532 = -40.6195255928 (32'hC2227A65):");
	#10 assign a = 32'h4113DD59; assign b = 32'hC08CA676;

	#10 $fwrite(outfile,"\n34. 48.24496 * -24.89117 = -1200.8735010032 (32'hC4961BF4):");
	#10 assign a = 32'h4240FAD7; assign b = 32'hC1C7211E;

	#10 $fwrite(outfile,"\n35. -22.70072 * 47.62937 = -1081.2209921464 (32'hC4872712):");
	#10 assign a = 32'hC1B59B13; assign b = 32'h423E847A;

	#10 $fwrite(outfile,"\n36. 11.39819 * -15.79263 = -180.0073973397 (32'hC33401E5):");
	#10 assign a = 32'h41365EFC; assign b = 32'hC17CAE9D;

	#10 $fwrite(outfile,"\n37. -49.47983 * 37.70944 = -1865.8566805952 (32'hC4E93B6A):");
	#10 assign a = 32'hC245EB59; assign b = 32'h4216D677;

	#10 $fwrite(outfile,"\n38. -14.99581 * 38.15092 = -572.1039476452 (32'hC40F06A7):");
	#10 assign a = 32'hC16FEED6; assign b = 32'h42189A8B;

	#10 $fwrite(outfile,"\n39. -25.1868 * 6.66969 = -167.988148092 (32'hC327FCF7):");
	#10 assign a = 32'hC1C97E91; assign b = 32'h40D56E1A;

	#10 $fwrite(outfile,"\n40. 10.58873 * -47.36583 = -501.5439850959 (32'hC3FAC5A1):");
	#10 assign a = 32'h41296B70; assign b = 32'hC23D769C;

	#10 $fwrite(outfile,"\n41. -25.96895 * 31.5402 = -819.06587679 (32'hC44CC437):");
	#10 assign a = 32'hC1CFC069; assign b = 32'h41FC5254;

	#10 $fwrite(outfile,"\n42. 29.27558 * -37.13947 = -1087.2795251426 (32'hC487E8F2):");
	#10 assign a = 32'h41EA3463; assign b = 32'hC2148ED1;

	#10 $fwrite(outfile,"\n43. -24.27169 * 34.82012 = -845.1431584028 (32'hC453492A):");
	#10 assign a = 32'hC1C22C6C; assign b = 32'h420B47CE;

	#10 $fwrite(outfile,"\n44. -31.91277 * 4.58709 = -146.3867481393 (32'hC3126302):");
	#10 assign a = 32'hC1FF4D5A; assign b = 32'h4092C971;

	#10 $fwrite(outfile,"\n45. -31.33261 * 49.07298 = -1537.5845438778 (32'hC4C032B5):");
	#10 assign a = 32'hC1FAA92F; assign b = 32'h42444ABB;

	#10 $fwrite(outfile,"\n46. -25.08921 * 8.29753 = -208.1784726513 (32'hC3502DB0):");
	#10 assign a = 32'hC1C8B6B4; assign b = 32'h4104C2AF;

	#10 $fwrite(outfile,"\n47. 20.72629 * -7.34089 = -152.1494149981 (32'hC3182640):");
	#10 assign a = 32'h41A5CF71; assign b = 32'hC0EAE892;

	#10 $fwrite(outfile,"\n48. 5.45039 * -39.32339 = -214.3278116221 (32'hC35653EB):");
	#10 assign a = 32'h40AE6998; assign b = 32'hC21D4B27;

	#10 $fwrite(outfile,"\n49. -26.21147 * 14.26138 = -373.8117340286 (32'hC3BAE7E7):");
	#10 assign a = 32'hC1D1B117; assign b = 32'h41642E9D;

	#10 $fwrite(outfile,"\n50. -49.57105 * 28.29323 = -1402.5251189915 (32'hC4AF50CE):");
	#10 assign a = 32'hC24648C1; assign b = 32'h41E25889;

	#10 $fwrite(outfile,"\n51. -32.81433 * 27.97196 = -917.8811261868 (32'hC4657864):");
	#10 assign a = 32'hC20341E0; assign b = 32'h41DFC693;

	#10 $fwrite(outfile,"\n52. 35.99579 * -22.95868 = -826.4158239572 (32'hC44E9A9D):");
	#10 assign a = 32'h420FFBB0; assign b = 32'hC1B7AB60;

	#10 $fwrite(outfile,"\n53. -29.46755 * 0.89466 = -26.363438283 (32'hC1D2E852):");
	#10 assign a = 32'hC1EBBD8B; assign b = 32'h3F650870;

	#10 $fwrite(outfile,"\n54. -3.71517 * 15.69692 = -58.3167262764 (32'hC2694454):");
	#10 assign a = 32'hC06DC558; assign b = 32'h417B2696;

	#10 $fwrite(outfile,"\n55. -3.35408 * 3.63901 = -12.2055306608 (32'hC14349DB):");
	#10 assign a = 32'hC056A93F; assign b = 32'h4068E58A;

	#10 $fwrite(outfile,"\n56. -22.86962 * 13.45381 = -307.6835222522 (32'hC399D77E):");
	#10 assign a = 32'hC1B6F4FB; assign b = 32'h415742CE;

	#10 $fwrite(outfile,"\n57. -39.69023 * 1.61463 = -64.0850360649 (32'hC2802B8A):");
	#10 assign a = 32'hC21EC2CC; assign b = 32'h3FCEAC32;

	#10 $fwrite(outfile,"\n58. -2.1082 * 46.13302 = -97.257632764 (32'hC2C283E8):");
	#10 assign a = 32'hC006ECC0; assign b = 32'h42388836;

	#10 $fwrite(outfile,"\n59. 33.18911 * -2.38845 = -79.2705297795 (32'hC29E8A83):");
	#10 assign a = 32'h4204C1A6; assign b = 32'hC018DC5D;

	#10 $fwrite(outfile,"\n60. -41.24005 * 7.45634 = -307.499834417 (32'hC399BFFB):");
	#10 assign a = 32'hC224F5D0; assign b = 32'h40EE9A56;

	#10 $fwrite(outfile,"\n61. -22.42197 * 35.84799 = -803.7825563403 (32'hC448F215):");
	#10 assign a = 32'hC1B36032; assign b = 32'h420F6457;

	#10 $fwrite(outfile,"\n62. 32.84439 * -46.76826 = -1536.0749710614 (32'hC4C00266):");
	#10 assign a = 32'h420360A8; assign b = 32'hC23B12B3;

	#10 $fwrite(outfile,"\n63. -36.87875 * 37.01143 = -1364.9352741125 (32'hC4AA9DEE):");
	#10 assign a = 32'hC21383D7; assign b = 32'h42140BB4;

	#10 $fwrite(outfile,"\n64. -46.55347 * 4.86961 = -226.6972430467 (32'hC362B27F):");
	#10 assign a = 32'hC23A36C1; assign b = 32'h409BD3D8;

	#10 $fwrite(outfile,"\n65. -19.87995 * 48.48509 = -963.8811649455 (32'hC470F865):");
	#10 assign a = 32'hC19F0A23; assign b = 32'h4241F0BB;

	#10 $fwrite(outfile,"\n66. 28.74483 * -42.5763 = -1223.848505529 (32'hC498FB27):");
	#10 assign a = 32'h41E5F569; assign b = 32'hC22A4E22;

	#10 $fwrite(outfile,"\n67. -23.22222 * 37.03883 = -860.1238588026 (32'hC45707ED):");
	#10 assign a = 32'hC1B9C71B; assign b = 32'h421427C3;

	#10 $fwrite(outfile,"\n68. 31.49206 * -37.80892 = -1190.6807771752 (32'hC494D5C9):");
	#10 assign a = 32'h41FBEFBD; assign b = 32'hC2173C56;

	#10 $fwrite(outfile,"\n69. 23.66528 * -5.56974 = -131.8094566272 (32'hC303CF39):");
	#10 assign a = 32'h41BD527E; assign b = 32'hC0B23B4F;

	#10 $fwrite(outfile,"\n70. 18.70853 * -11.59864 = -216.9935043992 (32'hC358FE56):");
	#10 assign a = 32'h4195AB12; assign b = 32'hC1399408;

	#10 $fwrite(outfile,"\n71. -46.90349 * 40.60363 = -1904.4519536687 (32'hC4EE0E76):");
	#10 assign a = 32'hC23B9D2C; assign b = 32'h42226A1E;

	#10 $fwrite(outfile,"\n72. -38.48848 * 36.54848 = -1406.6954415104 (32'hC4AFD641):");
	#10 assign a = 32'hC219F434; assign b = 32'h421231A5;

	#10 $fwrite(outfile,"\n73. -35.94549 * 24.9961 = -898.497062589 (32'hC4609FD0):");
	#10 assign a = 32'hC20FC82F; assign b = 32'h41C7F803;

	#10 $fwrite(outfile,"\n74. -10.63884 * 13.86851 = -147.5448589284 (32'hC3138B7C):");
	#10 assign a = 32'hC12A38B0; assign b = 32'h415DE56B;

	#10 $fwrite(outfile,"\n75. 15.07057 * -11.38878 = -171.6354062046 (32'hC32BA2AA):");
	#10 assign a = 32'h4171210E; assign b = 32'hC1363871;

	#10 $fwrite(outfile,"\n76. 16.52899 * -37.15618 = -614.1541276582 (32'hC41989DD):");
	#10 assign a = 32'h41843B5F; assign b = 32'hC2149FEE;

	#10 $fwrite(outfile,"\n77. 0.80359 * -36.55308 = -29.3736895572 (32'hC1EAFD51):");
	#10 assign a = 32'h3F4DB813; assign b = 32'hC212365B;

	#10 $fwrite(outfile,"\n78. -41.89969 * 19.85991 = -832.1240724279 (32'hC45007F1):");
	#10 assign a = 32'hC2279948; assign b = 32'h419EE118;

	#10 $fwrite(outfile,"\n79. 1.91459 * -38.27958 = -73.2897010722 (32'hC2929454):");
	#10 assign a = 32'h3FF51149; assign b = 32'hC2191E4A;

	#10 $fwrite(outfile,"\n80. -45.75987 * 11.04314 = -505.3326507918 (32'hC3FCAA94):");
	#10 assign a = 32'hC2370A1B; assign b = 32'h4130B0B4;

	#10 $fwrite(outfile,"\n81. -11.44875 * 26.83386 = -307.214154675 (32'hC3999B69):");
	#10 assign a = 32'hC1372E14; assign b = 32'h41D6ABBF;

	#10 $fwrite(outfile,"\n82. 30.78432 * -30.64707 = -943.4492099424 (32'hC46BDCC0):");
	#10 assign a = 32'h41F6464A; assign b = 32'hC1F52D33;

	#10 $fwrite(outfile,"\n83. -43.76411 * 1.82722 = -79.9666570742 (32'hC29FEEEE):");
	#10 assign a = 32'hC22F0E73; assign b = 32'h3FE9E258;

	#10 $fwrite(outfile,"\n84. 5.62132 * -10.87361 = -61.1240413652 (32'hC2747F05):");
	#10 assign a = 32'h40B3E1DA; assign b = 32'hC12DFA4E;

	#10 $fwrite(outfile,"\n85. -28.14317 * 2.4959 = -70.242538003 (32'hC28C7C2E):");
	#10 assign a = 32'hC1E12536; assign b = 32'h401FBCD3;

	#10 $fwrite(outfile,"\n86. 20.70638 * -38.2462 = -791.940350756 (32'hC445FC2F):");
	#10 assign a = 32'h41A5A6AB; assign b = 32'hC218FC1C;

	#10 $fwrite(outfile,"\n87. -20.51153 * 1.85713 = -38.0925777089 (32'hC2185ECD):");
	#10 assign a = 32'hC1A4179D; assign b = 32'h3FEDB670;

	#10 $fwrite(outfile,"\n88. -20.21325 * 49.08421 = -992.1514077825 (32'hC47809B1):");
	#10 assign a = 32'hC1A1B4BC; assign b = 32'h4244563B;

	#10 $fwrite(outfile,"\n89. -6.08138 * 24.50871 = -149.0467788198 (32'hC3150BFA):");
	#10 assign a = 32'hC0C29AAA; assign b = 32'h41C411D7;

	#10 $fwrite(outfile,"\n90. -44.05106 * 47.08264 = -2074.0401995984 (32'hC501A0A5):");
	#10 assign a = 32'hC2303449; assign b = 32'h423C54A0;

	#10 $fwrite(outfile,"\n91. 34.54522 * -25.53593 = -882.1443197546 (32'hC45C893D):");
	#10 assign a = 32'h420A2E4E; assign b = 32'hC1CC4996;

	#10 $fwrite(outfile,"\n92. 16.47062 * -34.05595 = -560.922611189 (32'hC40C3B0C):");
	#10 assign a = 32'h4183C3D4; assign b = 32'hC208394B;

	#10 $fwrite(outfile,"\n93. 20.60761 * -48.17666 = -992.8058203826 (32'hC4783393):");
	#10 assign a = 32'h41A4DC63; assign b = 32'hC240B4E6;

	#10 $fwrite(outfile,"\n94. -15.89547 * 3.36165 = -53.4350067255 (32'hC255BD72):");
	#10 assign a = 32'hC17E53D8; assign b = 32'h40572546;

	#10 $fwrite(outfile,"\n95. -41.21247 * 10.38786 = -428.1093686142 (32'hC3D60E00):");
	#10 assign a = 32'hC224D992; assign b = 32'h412634AD;

	#10 $fwrite(outfile,"\n96. -16.85257 * 5.24768 = -88.4368945376 (32'hC2B0DFB1):");
	#10 assign a = 32'hC186D210; assign b = 32'h40A7ECFF;

	#10 $fwrite(outfile,"\n97. -19.35663 * 19.47545 = -376.9790797335 (32'hC3BC7D52):");
	#10 assign a = 32'hC19ADA61; assign b = 32'h419BCDB9;

	#10 $fwrite(outfile,"\n98. 5.78907 * -29.1212 = -168.584665284 (32'hC32895AD):");
	#10 assign a = 32'h40B94010; assign b = 32'hC1E8F838;

	#10 $fwrite(outfile,"\n99. 2.02924 * -33.04937 = -67.0651035788 (32'hC2862155):");
	#10 assign a = 32'h4001DF11; assign b = 32'hC204328E;

	#10 $fwrite(outfile,"\n100. 0.2789 * -23.78231 = -6.632886259 (32'hC0D4409B):");
	#10 assign a = 32'h3E8ECBFB; assign b = 32'hC1BE422C;

    #10 $fwrite(outfile,"\n97.67 * 107.58:10507.3386 (46242D5B)");
    #10 assign a = 32'h42C3570A; assign b = 32'h42D728F6;
   // #10 assign a = 32'h3F7FFFFF; assign b = 32'h00000001;

//    #10 $fwrite(outfile,"\n20 * 20:"); // 1.0100000000 * 2**4 or 0x4D00
//    #10 assign a = 16'h4D00; assign b = 16'h4D00; // 1.1001000000 x 2**8 or 0x5E40
//
//    #10 $fwrite(outfile,"\n400 * PI:"); // PI = 1.1001001000 * 2**1
//    #10 assign a = 16'h5E40; assign b = 16'h4248; // 1.0011101000 * 2**10 or 0x64E8

    #20 $fwrite(outfile,"\nEnd of tests : %t", $time);
    #20 //$stop;
        $finish;
  end

always @(a or b) begin
        // Log the results to the file
	 #1
        $fwrite(outfile,"\n p (%x %b) = a (%x) * b (%x)", p, flags, a, b);
  
	end


  fp_mul #(NEXP, NSIG) inst1(
  .a(a),
  .b(b),
  .p(p),
  .pFlags(flags)
  );
  
endmodule
	
