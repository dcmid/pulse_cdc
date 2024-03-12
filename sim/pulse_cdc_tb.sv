`include "../hdl/pulse_cdc.sv"

module pulse_cdc_tb;

  logic pulse_aclk = 0;
  logic aclk = 0;
  logic pulse_bclk;
  logic bclk = 0;

  pulse_cdc dut(
    .i_pulse_aclk(pulse_aclk),
    .i_aclk(aclk),
    
    .o_pulse_bclk(pulse_bclk),
    .i_bclk(bclk)
  );

  localparam ACLK_PERIOD = 12;
  always #(ACLK_PERIOD/2) aclk = ~aclk;
  localparam BCLK_PERIOD = 20;
  always #(BCLK_PERIOD/2) bclk = ~bclk;

  task gen_pulse; 
    begin
      pulse_aclk <= 1'b1;
      @(posedge aclk);
      pulse_aclk <= 1'b0;
    end
  endtask

  initial begin
    $dumpfile("pulse_cdc_tb.vcd");
    $dumpvars(0, pulse_cdc_tb);
  end

  //aclk
  initial begin
    repeat(4) @(posedge aclk);
    gen_pulse();
    @(posedge aclk);
    // repeat(20) @(posedge aclk);
    // $finish(2);
  end

  //bclk domain
  initial begin
    wait(pulse_bclk == 1'b1)
    @(posedge bclk)
    @(posedge bclk)
    assert (pulse_bclk == 1'b0);
    $display(pulse_bclk);
    repeat(4) @(posedge bclk);
    $finish(2);
  end

endmodule