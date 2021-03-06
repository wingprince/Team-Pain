`timescale 1ns / 1ps
//`include "direction.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:03:00 10/21/2012 
// Design Name: 
// Module Name:    pulseout 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pulseout(
		input CLK,
		input [4:0] MC1,
		input [4:0] MC2,
		output reg PWM_MC1,
		output reg PWM_MC2
    );

	//Variable decleration
	reg [20:0] count,refresh;
	wire [21:0] pulse1,pulse2;
	reg [4:0] MC1State, MC2State;

	initial begin
		MC1State = 0;
		MC2State = 0;
		count = 0;
		PWM_MC1 = 0;
		PWM_MC2 = 0;
		refresh = 800000; //refresh = CLK_RATE/91 //Refresh of signal in Mode 2, 11 ms
	end
	
	//Modulate the Transmitted Pulse to Achieve a Specified Power for Motor #1
	PulseModulation1 mc1mod(
			.CLK(CLK),
			.ModInfo(MC1),
			.State(MC1State),
			.Pulse(pulse1)
			);

	//Modulate the Transmitted Pulse to Achieve a Specified Power for Motor #2
	PulseModulation2 mc2mod(
				.CLK(CLK),
				.ModInfo(MC2),
				.State(MC2State),
				.Pulse(pulse2)
				);
				
	always @(posedge CLK) begin
		count <= count + 1;
		
		if(count >= refresh)begin //11 ms Refresh Rate
			count[20:0] <= 0;

			if(MC1State == 23) //State Reset for Motor #1
				MC1State <= 0;
			else 
				MC1State <= MC1State + 1;
			
			if(MC2State == 23) //State Reset for Motor #2
				MC2State <= 0;
			else 
				MC2State <= MC2State + 1;
		end else begin
			count <= count + 1;
		end
		
		//Signal to Motor #1
		if(count <= pulse1) 
			PWM_MC1 <= 1;
		else 
			PWM_MC1 <= 0;
		
		//Signal to Motor #2
		if(count <= pulse2) 
			PWM_MC2 <= 1;
		else 
			PWM_MC2 <= 0;
	end

endmodule


