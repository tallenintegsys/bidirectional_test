`timescale 1ns / 1ps

module usb_top (
	input		clk48,
	input		usr_btn,	// SW0,
	output		rst_n,
	output 		rgb_led0_r,	// [0:0]LED,
	output 		rgb_led0_g,	// [0:0]LED,
	output 		rgb_led0_b,	// [0:0]LED,
	input		gpio_12,	// 1 = input 0 = output on gpio_13
	inout		gpio_13,	// Hi-Z test port
	inout		gpio_a3		// Hi-Z test port (using primitive)
);

wire red, blu;

assign rgb_led0_r = ~red;
assign rgb_led0_g = 1'b1;
assign rgb_led0_b = ~blu;
assign gpio_13 = gpio_12 ? 1'bz : ~counter[22];
assign red = gpio_13; 	// if gpio_12 == input then led = off

/* ICE40
SB_IO #(
	.PIN_TYPE(6'b 1010_01),
	.PULLUP(1'b 0)
) io_pin (
	.PACKAGE_PIN (gpio_a3),			// User’s Pin signal name
	.LATCH_INPUT_VALUE (rgb_led0_b),	// Latches/holds the Input value
	.CLOCK_ENABLE (1'b1),			// Clock Enable common to input and output clock
	.INPUT_CLK (clk_48),			// Clock for the input registers
	.OUTPUT_CLK (clk_48),			// Clock for the output registers
	.OUTPUT_ENABLE (gpio_12),		// Output Pin Tristate/Enable control
	.D_OUT_0 (~counter[22])		// Data 0 – out to Pin/Rising clk edge
	.D_OUT_1 (~counter[22]),		// Data 1 - out to Pin/Falling clk edge
	.D_IN_0 (d_in_0),			// Data 0 - Pin input/Rising clk edge
	.D_IN_1 (d_in_1)			// Data 1 – Pin input/Falling clk edge
); // synthesis DRIVE_STRENGTH= x2
*/ 

/* ECP5 (e.g. Orangecrab) */
TRELLIS_IO #(
	.DIR("BIDIR")
) io_pin (
	.B (gpio_a3),
	.I (~counter[23]),
	.T (gpio_12),
	.O (blu)
);

reg     [26:0] counter = 0;
always @(posedge clk48) begin
	counter <= counter + 1;
end

// Reset logic on button press. this will enter the bootloader
reg reset_sr = 1'b1;
always @(posedge clk48) begin
	reset_sr <= {usr_btn};
end
assign rst_n = reset_sr;

endmodule
