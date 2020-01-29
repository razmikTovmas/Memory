module clock (clk);

  output clk;

  reg clk_reg;
  assign clk = clk_reg;

  always
  begin
    clk_reg=0;
    #50;
    clk_reg=1;
    #50;
  end
endmodule