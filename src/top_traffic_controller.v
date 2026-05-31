`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer        : M.V.S.Charith
// Project Name    : FPGA Based Smart Traffic Light Controller
// Module Name     : top_traffic_controller
// Design Name     : Top Level Traffic Controller Integration Module
// Target Devices  : Artix-7 FPGA
// Tool Versions   : Vivado 2024.x
//
// Description:
//
// Top-level integration module for the Smart Traffic Light Controller.
//
// This module connects:
// - Clock enable/tick generator
// - Timer counter module
// - FSM-based traffic controller
//
// Features Supported:
// - Normal traffic sequencing
// - Pedestrian crossing requests
// - Emergency vehicle override
// - Night mode blinking operation
//
// Dependencies:
// - traffic_fsm.v
// - timer_counter.v
// - clock_enable_generator.v
//
// Notes:
// - Generates slow timing ticks for FSM timing control
// - Integrates timer and FSM control logic
// - Designed for FPGA implementation and simulation
//
//////////////////////////////////////////////////////////////////////////////////

module top_traffic_controller#(parameter COUNT_STOP=100000000)(
input clk, 
input reset,
input pedestrian_request,
input emergency_request, 
input night_mode,
output [2:0] main_traffic_lights,
output [2:0] side_traffic_lights,
output [6:0] Time,
output ped_crossing_enable
);

wire [6:0] count_duration;
wire count_enable;
wire tick;
wire count_done;
wire timer_reset;

clock_enable_generator#(.COUNT_STOP(COUNT_STOP)) tick_gen( .clk_in(clk), .reset(reset), .tick(tick));

timer_counter count( .clk(clk), .reset(reset), .timer_reset(timer_reset), .count_enable(count_enable), .count_duration(count_duration), .tick(tick), .count_done(count_done), .Time(Time));

traffic_fsm fsm( .clk(clk), .reset(reset), .count_done(count_done), .pedestrian_request(pedestrian_request), .emergency_request(emergency_request), .night_mode(night_mode), .timer_enable(count_enable), .timer_reset(timer_reset), .ped_crossing_enable(ped_crossing_enable), .count_duration(count_duration), .main_traffic_lights(main_traffic_lights), .side_traffic_lights(side_traffic_lights));

endmodule
