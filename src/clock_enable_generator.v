`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer        : M.V.S.Charith
// Project Name    : FPGA Based Smart Traffic Light Controller
// Module Name     : clock_enable_generator
// Design Name     : Clock Enable / Tick Generator
// Target Devices  : Artix-7 FPGA
// Tool Versions   : Vivado 2024.x
//
// Description:
//
// Generates a periodic single-clock-cycle tick pulse from the
// high-frequency FPGA system clock.
//
// Functionality:
// - Divides the input clock using a programmable counter
// - Generates a one-cycle tick pulse after COUNT_STOP cycles
// - Used as a slow timing reference for FSM state timing
// - Enables simulation acceleration by reducing COUNT_STOP
//
// Dependencies:
// - None
//
// Notes:
// - COUNT_STOP controls tick generation interval
// - For hardware implementation:
//       COUNT_STOP = FPGA_Clock_Frequency × Desired_Time
// - For simulation, smaller COUNT_STOP values are used
//   to speed up verification
//
//////////////////////////////////////////////////////////////////////////////////

module clock_enable_generator #(parameter COUNT_STOP=100000000) (
    input clk_in,
    input reset,
    output tick
    );
    
    reg tick_reg;
    reg [$clog2(COUNT_STOP)-1:0] count;
    
    always @(posedge clk_in) begin
        if(reset) begin
            count <= 0;
            tick_reg <= 0;
        end else begin
                 
            if(count==COUNT_STOP-1) begin
                count <= 0;
                tick_reg <= 1;
            end else begin
                count <= count+1;
                tick_reg <= 0;
            end
        end
    end
    
    assign tick = tick_reg;
     
endmodule
