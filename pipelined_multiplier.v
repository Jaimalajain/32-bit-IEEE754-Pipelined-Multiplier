`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 21:16:01
// Design Name: 
// Module Name: pipelined_multiplier
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


module pipelined_multiplier(
    input clk,
    input rst,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] F
    );

    // --- STAGE 1 REGISTERS ---
    reg sign1;
    reg [7:0] exp1;
    reg [47:0] mant_prod1;

    // --- STAGE 2 REGISTERS ---
    reg sign2;
    reg [8:0] exp2; // Extra bit for overflow/underflow
    reg [47:0] mant_prod2;

    // --- STAGE 3 REGISTERS ---
    reg sign3;
    reg [8:0] exp3;
    reg [47:0] mant_prod3;

    // --- STAGE 1: Input Extraction & Sign Calculation ---
    reg [7:0] exp_b1; 

    // Stage 1 block mein:
    always @(posedge clk) begin
        if (rst) begin
            // ... reset logic ...
            exp_b1 <= 0;
        end else begin
            sign1 <= A[31] ^ B[31];
            mant_prod1 <= {1'b1, A[22:0]} * {1'b1, B[22:0]};
            exp1 <= A[30:23];
            exp_b1 <= B[30:23]; // B ko yahan save karna zaroori hai!
        end
    end


    // --- STAGE 2: Exponent Addition ---
    always @(posedge clk) begin
        if (rst) begin
            sign2 <= 0;
            exp2 <= 0;
            mant_prod2 <= 0;
        end else begin
            sign2 <= sign1;
            mant_prod2 <= mant_prod1;
            // Exponents add karke BIAS (127) subtract karna 
           exp2 <= exp1 + exp_b1 - 8'd127; 
        end
    end

    // --- STAGE 3: Partial Product Processing ---
    always @(posedge clk) begin
        if (rst) begin
            sign3 <= 0;
            exp3 <= 0;
            mant_prod3 <= 0;
        end else begin
            sign3 <= sign2;
            exp3 <= exp2;
            mant_prod3 <= mant_prod2; // Accumulating results [cite: 65]
        end
    end

    // --- STAGE 4: Normalization & Final Result ---
    always @(posedge clk) begin
        if (rst) begin
            F <= 0;
        end else begin
            // Normalization: Agar mantissa overflow kare toh exponent shift [cite: 77, 78]
            if (mant_prod3[47]) begin
                F <= {sign3, exp3[7:0] + 1'b1, mant_prod3[45:23]};
            end else begin
                F <= {sign3, exp3[7:0], mant_prod3[44:22]}; // Final combining [cite: 79]
            end
        end
    end
endmodule
