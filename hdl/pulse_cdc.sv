module pulse_cdc(
  input   logic i_pulse_aclk,
  input   logic i_aclk,

  output  logic o_pulse_bclk,
  input   logic i_bclk 
);
  logic pulse_toggle_aclk = 1'b0;
  logic pulse_toggle_cdc;
  logic pulse_toggle_bclk;
  logic pulse_toggle_prev_bclk;

  // i_aclk domain
  always @(posedge i_aclk) begin
    pulse_toggle_aclk <= pulse_toggle_aclk ^ i_pulse_aclk;  // toggles whenever i_pulse_aclk is asserted
  end

  // i_bclk domain
  always @(posedge i_bclk) begin
    pulse_toggle_cdc        <= pulse_toggle_aclk;  // sample pulse_toggle from i_aclk to metastable cdc register
    pulse_toggle_bclk       <= pulse_toggle_cdc;   // sample metastable pulse_toggle_cdc into stable i_bclk register
    pulse_toggle_prev_bclk  <= pulse_toggle_bclk;  // shift out previous value for edge detection
  end

  assign o_pulse_bclk = pulse_toggle_bclk ^ pulse_toggle_prev_bclk;  // create pulse in i_bclk domain

endmodule