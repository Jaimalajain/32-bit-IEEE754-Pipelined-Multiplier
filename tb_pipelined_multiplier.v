`timescale 1ns / 1ps

module tb_multiplier();
    reg clk;
    reg rst;
    reg [31:0] A, B;
    wire [31:0] F;

    // Multiplier Connect kiya
    pipelined_multiplier uut (
        .clk(clk), .rst(rst), .A(A), .B(B), .F(F)
    );

    // 50MHz Clock (10ns high, 10ns low)
    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        // --- System Reset ---
        rst = 1; A = 0; B = 0;
        @(posedge clk); // 1 clock cycle wait
        #5 rst = 0;     // Edge se 5ns baad reset hatao (Safe timing)

        // --- Test Case 1: 2.0 * 1.5 = 3.0 ---
        @(posedge clk);
        #2; // Clock edge ke thoda baad data change karo
        A = 32'h40000000; // 2.0
        B = 32'h3fc00000; // 1.5
        
        // --- 4 Cycles wait for Pipeline Latency ---
        repeat(4) @(posedge clk);
        
        #5; // Output settle hone ka wait
        $display("Result at 4th Cycle: %h", F);
        if (F == 32'h40400000) 
            $display("SUCCESS: 2.0 * 1.5 = 3.0");
        else 
            $display("FAILED: Expected 40400000, Got %h", F);

        #100;
        $finish;
    end
endmodule
