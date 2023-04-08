`timescale 1ns / 1ps

module usb_top (
	input		clk48,
	input		usr_btn,	// SW0,
	output		rst_n,
	output 		rgb_led0_r,	// [0:0]LED,
	output 		rgb_led0_g,	// [0:0]LED,
	output 		rgb_led0_b,	// [0:0]LED,
	input		gpio_12,	// 0 = input 1 = output on gpio_13
	inout		gpio_13,	// Hi-Z test port
//	inout		usb_d_p,	// SITE "N1"
//	inout		usb_d_n,	// SITE "M2"
//	output		usb_pullup,	// SITE "N2"
);



//assign usb_d_p = usb_tx_en ? (usb_tx_se0 ? 1'b0 : usb_tx_j) : 1'bz;	// go hi-z if we're not tx'ing
//assign usb_d_n = usb_tx_en ? (usb_tx_se0 ? 1'b0 : !usb_tx_j) : 1'bz;	// go hi-z if we're not tx'ing


//SB_IO #(
//	.PIN_TYPE(6'b 1010_01),
//	.PULLUP(1'b 0)
//) raspi_io [8:0] (
//	.PACKAGE_PIN(iopin),
//	.OUTPUT_ENABLE(dout_en),
//	.D_OUT_0(dout),
//	.D_IN_0(din)
//);

assign rgb_led0_g = 1'b1;
assign rgb_led0_b = 1'b1;

assign gpio_13 = gpio_12 ? ~counter[22] : 1'bz;
assign rgb_led0_r = gpio_12 ? 1'b1 : ~gpio_13; 	// if gpio_12 == input then led = off

reg     [26:0] counter = 0;
always @(posedge clk48) begin
	counter <= counter + 1;
end

// Reset logic on button press.
// this will enter the bootloader
reg reset_sr = 1'b1;
always @(posedge clk48) begin
	reset_sr <= {usr_btn};
end
assign rst_n = reset_sr;

endmodule
