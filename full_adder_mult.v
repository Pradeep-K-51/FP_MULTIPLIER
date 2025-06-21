
module mul_usg #(parameter N = 11) (
    input [N-1:0] A,
    input [N-1:0] B,
    output [2*N-1:0] Z
);
    wire [N-1:0] pp [N-1:0];
    wire [2*N-1:0] shifted_pp [N-1:0];
    wire [2*N-1:0] acc [0:N-1];

    genvar i;

    // Generate partial products
    generate
        for (i = 0; i < N; i = i + 1) begin : partial_products
            assign pp[i] = A & {N{B[i]}};
            assign shifted_pp[i] = {{(2*N-N){1'b0}}, pp[i]} << i;
        end
    endgenerate

    // First stage: assign first shifted partial product
    assign acc[0] = shifted_pp[0];

    // Accumulate the rest
    generate
        for (i = 1; i < N; i = i + 1) begin : accumulate
            adder_full #(2*N) adder (
                .A(acc[i-1]),
                .B(shifted_pp[i]),
                .Sum(acc[i])
            );
        end
    endgenerate

    // Final product
    assign Z = acc[N-1];
endmodule


// Full Adder module for adding two N-bit numbers
module adder_full #(parameter WIDTH = 20) (
    input [WIDTH-1:0] A,      // First operand
    input [WIDTH-1:0] B,      // Second operand
    output [WIDTH-1:0] Sum    // Sum of A and B
);
    wire [WIDTH-1:0] carry;   // Carry bits for the full adder

    // Instantiate full adders for each bit
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : full_adder_block
            if (i == 0) begin
                full_adder fa (.a(A[i]), .b(B[i]), .cin(1'b0), .sum(Sum[i]), .cout(carry[i]));
            end else begin
                full_adder fa (.a(A[i]), .b(B[i]), .cin(carry[i-1]), .sum(Sum[i]), .cout(carry[i]));
            end
        end
    endgenerate
endmodule

// Full Adder
module full_adder (
    input a,        // Bit a of the first number
    input b,        // Bit b of the second number
    input cin,      // Carry input
    output sum,     // Sum output
    output cout     // Carry output
);
    assign sum = a ^ b ^ cin;  // Sum is XOR of a, b, and carry input
    assign cout = (a & b) | (b & cin) | (a & cin); // Carry is the OR of bitwise ANDs
endmodule

