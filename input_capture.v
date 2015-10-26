module input_capture(
    input clk,
    input rst,
    output [3:0] channel,
    input new_sample,
    input [9:0] sample,
    input [3:0] sample_channel,
    output [7:0] led
  );
   
  assign channel = 4'd0; // only read A0
   
  reg [9:0] sample_d, sample_q;
  wire pwm;
   
  pwm #(.CTR_LEN(10)) led_pwm ( // 10bit PWM
    .clk(clk),
    .rst(rst),
    .compare(sample_q),
    .pwm(pwm)
  );
   
  assign led = {8{pwm}}; // duplicate the PWM signal to each LED
   
  always @(*) begin //it just waits for a new sample
    sample_d = sample_q;
     
    if (new_sample && sample_channel == 4'd0) // valid sample
      sample_d = sample; //<--- this is where the data comes from.
  end
   
  always @(posedge clk) begin //on the positive edge of the clock,
    if (rst) begin //if reset set it to zero,
      sample_q <= 10'd0;
    end else begin//otherwise sample that data
      sample_q <= sample_d;
    end
  end
   
endmodule