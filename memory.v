module memory #(parameter DATA_WIDTH = 8,
        ADDR_WIDTH = 16,
        RAM_DEPTH = 1 <<  ADDR_WIDTH
        )
(
  address,
  data_input,
  write_enable,
  reset,
  clk,
  data_output
);

  // Ports
  input  [ADDR_WIDTH - 1 : 0] address;
  input  [DATA_WIDTH - 1 : 0] data_input;
  input                       write_enable;
  input			              reset;
  input                       clk;

  output [DATA_WIDTH - 1 : 0] data_output;

  // Internal registers
  reg [DATA_WIDTH - 1 : 0] data_out_r;
  reg [DATA_WIDTH - 1 : 0] ram [RAM_DEPTH - 1 : 0];

  // Output
  assign data_output = data_out_r;

  // Reset Block
  integer i;
  always @(posedge clk)
  begin : MEM_RESET
    if(reset)
  begin
    for (i = 0; i < RAM_DEPTH; i = i + 1)
    begin
      ram[i] = DATA_WIDTH{1'b0};
    end
  end
  end

  // Write Block
  always @ (posedge clk)
  begin : MEM_WRITE
    if (write_enable && !reset)
    begin
      ram[address] <= data_input;
    end
  end

  // Read Block
  always @ (posedge clk)
  begin : MEM_READ
    if (!write_enable && !reset)
  begin
      data_out_r <= ram[address];
    end
  end
endmodule // memory
