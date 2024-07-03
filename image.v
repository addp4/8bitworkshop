`include "hvsync_generator.v"

module image_top(clk, reset, hsync, vsync, rgb);

  input clk, reset;
  output hsync, vsync;
  output [31:0] rgb;
  wire display_on;
  wire [9:0] hpos;
  wire [9:0] vpos;
  reg [7:0] bitmap[64000*3-1:0];

  // https://8bitworkshop.com/docs/posts/2019/the-mango-one-6502-computer.html#the-monitor-rom
  initial begin
    $readmemh("mario.hex", bitmap);
  end

  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(0),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );

  reg [23:0] rgb_data;
  reg [17:0] index, shift=0, shifth;
  always @(posedge vsync) shift <= (shift > 319 ? 0 : shift + 8);
  assign shifth = shift + {9'h0,hpos[9:1]};
  assign index = ({10'h0,vpos[8:1]} * 320 + 
                  (shifth < 320 ? shifth : shifth-320)) * 3;

  always @(posedge clk) begin
    if (display_on) begin
      rgb_data <= {bitmap[index+2], bitmap[index+1], bitmap[index]};
    end else
      rgb_data <= 0;
  end
  assign rgb[23:0] = rgb_data[23:0];
  assign rgb[31:24] = 8'hff;

endmodule

