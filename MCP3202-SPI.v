// So... this is my first attempt ever at an SPI protocol in any platform, I chose the MCP 3202, as it was avaliable at SEGOR!
// It'd be nice if I could have a clk module for this project and other projects!
// So this will have the clk module and the SPI module
// 8-bit resolution

module clk_gen 
(
    input clk,
    input [7:0] counter,
    input [7:0] on_time,
    input enable,

    output new_clk
);

reg [7:0] loop_counter = 8'h00;
reg on_state = 0;


always @(posedge clk)
    begin
        if(enable)
            begin
                if(loop_counter < counter)
                    begin
                        loop_counter <= loop_counter + 1'b1;
                        on_state <= (loop_counter < on_time);
                    end
                else
                    begin
                        loop_counter <= 8'h00;
                        on_state <= 0;
                    end
            end

        else 
            begin
                loop_counter <= 8'h00;
                on_state <= 1'h0;
            end
    end
assign new_clk = on_state;

endmodule



// So it looks like the MCP 3202 has 3 input lines and one output line
// The board will be the master, peripheral the slave
// Let's try to run at 50k for now, 10kHz is the minimum speed
// Din (MOSI) - 4-bit sting (setup_string), start, single/diff mode, odd/sign, MSBF
// Dout (MISO) - returns 12 bit string, with one null bit first
// CS - When pulled low, clk and transmission starts
// state machine?

module MCP3202_SPI
(
    input [3:0] start_settings,
    input clk, //General clk, 25Mhz
    input miso,
    input en,

    output cs,
    output clk_out, //Clk for IC
    output mosi,
    output [11:0] output_string, //total string
    output o_DV
);


//states
parameter initialize = 3'b000;
parameter transmit = 3'b001;
parameter recieve = 3'b010;

reg r_clk_en = 0;
wire clk_en;
assign clk_en = r_clk_en;

clk_gen clock_generation (clk, 8'd500, 8'd250, clk_en, clk_out);

// need a counter to keep track of where it is in the conversion
// one cycle is 17 bits, 4 init bits, 1 null bit, 12 other bits
// at 50khz, period is 20us

reg [11:0] one_period_counter;
always @(posedge clk)
    begin
        if (en)
            begin
                
            end
    end

endmodule