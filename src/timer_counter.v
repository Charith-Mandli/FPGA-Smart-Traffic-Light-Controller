`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer        : M.V.S.Charith
// Project Name    : FPGA Based Smart Traffic Light Controller
// Module Name     : timer_counter
// Design Name     : Traffic Timing Counter Module
// Target Devices  : Artix-7 FPGA
// Tool Versions   : Vivado 2024.x
//
// Description:
//
// Programmable timer counter module used for FSM state timing.
//
// This module:
// - Counts timing intervals based on external tick pulses
// - Generates count_done pulse on timer completion
// - Supports synchronous timer reset
// - Provides remaining countdown time output
//
// Features:
// - Configurable timing duration
// - Tick-based counting operation
// - One-cycle completion pulse generation
// - Countdown-style time display output
//
// Dependencies:
// - clock_enable_generator.v
// - traffic_fsm.v
//
// Notes:
// - Counter increments only when count_enable and tick are active
// - count_done is asserted for one clock cycle
// - Time output shows remaining state duration
//
//////////////////////////////////////////////////////////////////////////////////

module timer_counter(
    input clk,
    input reset,
    input timer_reset,
    input count_enable,
    input [6:0] count_duration,
    input tick,
    output count_done,
    output [6:0] Time
    );
    
    reg [6:0] count; 
    reg done_reg;
    
    always @(posedge clk) begin
        if(reset || timer_reset) begin
            count <= 0;
            done_reg <= 1'b0;
        end else begin
            if(count_enable && count<count_duration && tick) begin
                count <= count+1; 
                done_reg <= 1'b0;
            end else if(count_enable && tick) begin 
                done_reg <= 1'b1;
            end else
                done_reg <= 1'b0;
        end
    end
    
    assign Time = count_duration-count;
    assign count_done = done_reg;
    
endmodule
