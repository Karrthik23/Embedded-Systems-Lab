module TopEntity (
    input clk,
    output reg led1 = 1,
    output reg led2 = 0,
    output reg led3 = 0
);
  reg [31:0] count = 0;
  always @(posedge clk) begin
    if (count == 99999999) begin  //Time is up
      count <= 0;  //Reset count register
      led1   <= ~led1;  //Toggle led (in each second)
      led2   <= ~led2;  //Toggle led (in each second)
      led3   <= ~led3;  //Toggle led (in each second)
    end else begin
      count <= count + 1;  //Counts 100MHz clock
    end
  end
endmodule
