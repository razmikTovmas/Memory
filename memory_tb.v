module memory_tb;
  // Parameters
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 16;
  parameter RAM_DEPTH  = 1 << ADDR_WIDTH;

  // Error counter
  integer error_count;
  // Internal variables
  reg write_enable, reset, current_err;

  reg  [ADDR_WIDTH - 1 : 0] address;
  reg  [ADDR_WIDTH - 1 : 0] pattern;
  reg  [DATA_WIDTH - 1 : 0] data_from_mem;
  reg  [DATA_WIDTH - 1 : 0] data;
  wire [DATA_WIDTH - 1 : 0] data_input;
  wire [DATA_WIDTH - 1 : 0] data_output;
  wire                      clk;

  assign data_input = data;

  integer test_address;

  initial
    begin
    error_count = 0;
    $display("========================\n");
    $display("====> RESET MEMORY <====\n");
    $display("========================\n");
      reset = 1'b1;
      #50;
      reset = 1'b0;
      #50;
    pattern = 8'b0;
    for(test_address = 0; test_address < RAM_DEPTH; test_address = test_address + 1)
        begin
      write_mem(test_address, pattern);
    end
      $display ("====> START TEST BENCH <====\n");
      current_err = 1'b0;
      pattern     = 8'b0;

      for(test_address = 0; test_address < RAM_DEPTH; test_address = test_address + 1)
        begin
      pattern = ~pattern;

          write_mem(test_address, pattern);
        read_mem(test_address);
          compare_data(pattern, data_from_mem);

      if(current_err)
            begin
        $display("ERROR: Failed to read from address '%0d'", test_address);
              $display ("Expected data = %d, actual data = %d.\n", pattern, data_from_mem);
        error_count = error_count + 1;
          end
      else
      begin
        $display("PASSED: Read from address '%0d' sucseed.", test_address);
          end
    end
    $display("Test compleated with %0d errors.", error_count);
    if (error_count)
    begin
      $display("==========> TEST FAILED <==========");
    end else
    begin
      $display("==========> TEST PASSED <==========");
    end
  end

  task write_mem;
    input [ADDR_WIDTH - 1 : 0] my_mem_addr;
    input [DATA_WIDTH - 1 : 0] my_mem_data;
    begin
      write_enable = 1;
      address    = my_mem_addr;
      #100;
      data       = my_mem_data;
    write_enable = 0;
    end
  endtask

  task read_mem;
    input [ADDR_WIDTH - 1 : 0] my_mem_addr;
    begin
      address      = my_mem_addr;
      write_enable = 0;
      #100;
      data_from_mem = data_output;
    end
  endtask

  task compare_data;
    input [DATA_WIDTH - 1 : 0] reference_data;
    input [DATA_WIDTH - 1 : 0] actual_data;
    begin
      if(reference_data !== actual_data)
        begin
          current_err = 1;
        end
      else
        current_err = 0;
    end
  endtask

  clock u_clock(.clk(clk));

  memory #(DATA_WIDTH, ADDR_WIDTH, RAM_DEPTH) u_memory
                                                 (.address(address),
                                                  .data_input(data_input),
                                                  .write_enable(write_enable),
                                                  .reset(reset),
                                              .clk(clk),
                                              .data_output(data_output)
                                                  );
endmodule