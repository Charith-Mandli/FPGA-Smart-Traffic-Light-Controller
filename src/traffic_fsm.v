`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer        : M.V.S.Charith
// Project Name    : FPGA Based Smart Traffic Light Controller
// Module Name     : traffic_fsm
// Design Name     : Finite State Machine Based Traffic Controller
// Target Devices  : Artix-7 FPGA
// Tool Versions   : Vivado 2024.x
//
// Description:
//
// Main FSM controller for the Smart Traffic Light System.
//
// This module controls:
// - Normal traffic signal sequencing
// - Pedestrian crossing requests
// - Emergency vehicle priority handling
// - All-red transition safety states
// - Night mode blinking operation
// - Timer control and duration selection
//
// Features:
// - FSM-based modular traffic control
// - Priority-based request servicing
// - Emergency override support
// - Pedestrian request latching
// - Safe yellow/all-red transitions
// - Night mode blinking using dedicated states
// - One-hot encoded traffic light outputs
//
// State Flow:
// MAIN_GREEN -> MAIN_YELLOW -> ALL_RED_1 ->
// SIDE_GREEN -> SIDE_YELLOW -> ALL_RED_2 -> MAIN_GREEN
//
// Additional States:
// - PEDESTRIAN_CROSSING
// - EMERGENCY
// - NIGHT_MODE_HIGH
// - NIGHT_MODE_LOW
//
// Dependencies:
// - timer_counter.v
// - top_traffic_controller.v
//
// Notes:
// - Emergency requests have highest priority
// - Pedestrian requests are latched until serviced
// - Night mode overrides normal traffic operation
// - Traffic outputs use one-hot encoding:
//       [2] = Green
//       [1] = Yellow
//       [0] = Red
//
//////////////////////////////////////////////////////////////////////////////////

module traffic_fsm(
    input clk,
    input reset,
    input count_done,
    input pedestrian_request,
    input emergency_request,
    input night_mode,
    output timer_enable,
    output timer_reset,
    output ped_crossing_enable,
    output [6:0] count_duration,
    output [2:0] main_traffic_lights,
    output [2:0] side_traffic_lights
    );
    
    parameter STATE_WIDTH =4;
    parameter MAIN_GREEN=0, MAIN_YELLOW=1, ALL_RED_1=2, SIDE_GREEN=3, SIDE_YELLOW=4, ALL_RED_2=5, PEDESTRIAN_CROSSING=6, EMERGENCY=7, NIGHT_MODE_HIGH=8, NIGHT_MODE_LOW=9;
  
    parameter MAIN_GREEN_COUNT=10, SIDE_GREEN_COUNT=7, YELLOW_COUNT=3, ALL_RED_COUNT=1, CROSSING_COUNT=3, EMERGENCY_GREEN_COUNT=5, BLINK_COUNT=1;
    
    reg [STATE_WIDTH-1:0] state, next_state, return_state, prev_state;
    reg enable_reg, reset_reg, ped_req_reg, emer_req_reg;
    reg [6:0] count_dur_reg;
    
    always @(*) begin
        enable_reg = 1'b1;
        next_state = state;
        reset_reg = 1'b0;
        count_dur_reg = ALL_RED_COUNT; 
        
        case(state)
            MAIN_GREEN: begin
                
                if(night_mode) begin
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    next_state = MAIN_YELLOW;
                    reset_reg = 1'b1;
                end else begin
                    next_state = MAIN_GREEN;
                    reset_reg = 1'b0;
                end
                
                count_dur_reg = MAIN_GREEN_COUNT; 
            end 
            MAIN_YELLOW: begin 
                
                if(night_mode) begin
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    next_state = ALL_RED_1;
                    reset_reg = 1'b1;
                end else begin
                    next_state = MAIN_YELLOW;
                    reset_reg = 1'b0;
                end
                
                count_dur_reg = YELLOW_COUNT;  
            end 
            ALL_RED_1: begin 
                
                if(night_mode) begin
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b1;
                end else if(emer_req_reg) begin
                    next_state = EMERGENCY;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    next_state = SIDE_GREEN;
                    reset_reg = 1'b1;
                end else if(ped_req_reg) begin
                    next_state = PEDESTRIAN_CROSSING;
                    reset_reg = 1'b1;
                end else begin
                    next_state = ALL_RED_1;
                    reset_reg = 1'b0;
                end
                
                count_dur_reg = ALL_RED_COUNT;  
            end
            SIDE_GREEN: begin 
                
                if(night_mode) begin
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b1;
                end else if(emer_req_reg) begin
                    next_state = SIDE_YELLOW;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    next_state = SIDE_YELLOW;
                    reset_reg = 1'b1;
                end else begin
                    next_state = SIDE_GREEN;
                    reset_reg = 1'b0;
                end
                
                count_dur_reg = SIDE_GREEN_COUNT; 
            end 
            SIDE_YELLOW: begin 
                
                if(night_mode) begin
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    next_state = ALL_RED_2;
                    reset_reg = 1'b1;
                end else begin
                    next_state = SIDE_YELLOW;
                    reset_reg = 1'b0;
                end
                 
                count_dur_reg = YELLOW_COUNT; 
            end 
            ALL_RED_2: begin 
                
                if(night_mode) begin
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b1;
                end else if(emer_req_reg) begin
                    next_state = EMERGENCY;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    next_state = MAIN_GREEN;
                    reset_reg = 1'b1;
                end else if(ped_req_reg) begin
                    next_state = PEDESTRIAN_CROSSING;
                    reset_reg = 1'b1;
                end else begin
                    next_state = ALL_RED_2;
                    reset_reg = 1'b0;
                end
                 
                count_dur_reg = ALL_RED_COUNT; 
            end 
            PEDESTRIAN_CROSSING: begin
                
                if(night_mode) begin
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b1;
                end else if(emer_req_reg) begin
                    next_state = EMERGENCY;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    if(return_state==ALL_RED_1)
                        next_state = SIDE_GREEN;
                    else
                        next_state = MAIN_GREEN;
                    reset_reg = 1'b1;
                end else begin
                    next_state = PEDESTRIAN_CROSSING;
                    reset_reg = 1'b0;
                end
                 
                count_dur_reg = CROSSING_COUNT; 
            end
            EMERGENCY: begin
                
                if(night_mode) begin
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    if(prev_state==ALL_RED_1) begin
                        next_state = MAIN_YELLOW;
                        reset_reg = 1'b1;
                    end else if(prev_state==PEDESTRIAN_CROSSING) begin
                        if(return_state==ALL_RED_1) begin
                            next_state = MAIN_YELLOW;
                            reset_reg = 1'b1;
                        end else begin
                            next_state = MAIN_GREEN; 
                            reset_reg = 1'b0;
                        end
                    end else if(prev_state==ALL_RED_2) begin
                        next_state = MAIN_GREEN;
                        reset_reg = 1'b0;
                    end else begin
                        next_state = MAIN_YELLOW;
                        reset_reg = 1'b1;
                    end
                end else begin
                    next_state = EMERGENCY;
                    reset_reg = 1'b0;
                end
                
                count_dur_reg = EMERGENCY_GREEN_COUNT; 
            end
            NIGHT_MODE_HIGH: begin
            
                if(!night_mode) begin
                    next_state = prev_state;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    next_state = NIGHT_MODE_LOW;
                    reset_reg = 1'b1;
                end else begin 
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b0;
                end
                
                count_dur_reg = BLINK_COUNT;
            end
            NIGHT_MODE_LOW: begin
            
                if(!night_mode) begin
                    next_state = prev_state;
                    reset_reg = 1'b1;
                end else if(count_done) begin
                    next_state = NIGHT_MODE_HIGH;
                    reset_reg = 1'b1;
                end else begin
                    next_state = NIGHT_MODE_LOW;
                    reset_reg = 1'b0;
                end
                
                count_dur_reg = BLINK_COUNT;
            end
            default: begin
                next_state = ALL_RED_2;
                reset_reg = 1'b0;
                count_dur_reg = ALL_RED_COUNT;
            end
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            state <= ALL_RED_2;
            prev_state <= ALL_RED_2;
            return_state <= ALL_RED_2;
            ped_req_reg <= 1'b0;
            emer_req_reg <= 1'b0;
        end else begin
            state <= next_state;
            
            if((state!=EMERGENCY)&&(state!=NIGHT_MODE_LOW)&&(state!=NIGHT_MODE_HIGH))
                prev_state <= state;
                
            if((state==ALL_RED_1) || (state==ALL_RED_2))
                return_state <= state;
            
            if(pedestrian_request)
                ped_req_reg <= 1'b1;
            else if((state==PEDESTRIAN_CROSSING) && count_done)
                ped_req_reg <= 1'b0;
                
            if(emergency_request) begin
                if(state==MAIN_GREEN) begin
                    if(!count_done)
                        emer_req_reg <= 1'b0;
                    else
                        emer_req_reg <= 1'b1;
                end else
                    emer_req_reg <= 1'b1;
            end else if((state==EMERGENCY) && count_done)
                emer_req_reg <= 1'b0;
        end
    end
    
    assign count_duration = count_dur_reg;
    assign timer_enable = enable_reg;
    assign timer_reset = reset_reg;
    
    assign ped_crossing_enable = (state==PEDESTRIAN_CROSSING);
    
    //Traffic light outputs are 3 bit with Green, Yellow, Red as one-hot encoded;
    
    assign main_traffic_lights[2] = ((state==MAIN_GREEN) || (state==EMERGENCY));
    assign main_traffic_lights[1] = ((state==MAIN_YELLOW) || (state==NIGHT_MODE_HIGH));
    assign main_traffic_lights[0] = ((state==SIDE_GREEN) || (state==SIDE_YELLOW) || (state==ALL_RED_1) || (state==ALL_RED_2) || (state==PEDESTRIAN_CROSSING));
    
    assign side_traffic_lights[2] = (state==SIDE_GREEN);
    assign side_traffic_lights[1] = (state==SIDE_YELLOW);
    assign side_traffic_lights[0] = ((state==MAIN_GREEN) || (state==MAIN_YELLOW)|| (state==ALL_RED_1) || (state==ALL_RED_2) || (state==PEDESTRIAN_CROSSING) || (state==EMERGENCY) || (state==NIGHT_MODE_HIGH));
    
endmodule
