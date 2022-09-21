`include "src/game_logic.v"
`timescale 1 ns/100 ps

module game_logic_stim;
    localparam period = 10;
    reg clk, click, rst, red, win, enable;
    reg [4:0] max_clicks;
    reg [2:0] max_steps;
    wire [3:0] status_code;
    wire [2:0] position;
    game_logic GameLogic(.clk(clk), .rst(rst), 
        .red(red),
        .win(win),
        .max_clicks(max_clicks), 
        .max_steps(max_steps), 
        .click(click), 
        .enable(enable), 
        .position(position), 
        .status_code(status_code)
    );

    always begin
        click = 1'b0;
        #period;
        click = 1'b1;
        #period;
    end

    always begin
        clk = 1'b0;
        #1;
        clk = 1'b1;
        #1;
    end

    initial begin
		$dumpfile("game_logic_stim.vcd");
		$dumpvars(0, game_logic_stim);
        max_clicks <= 10;
        max_steps <= 10;
        enable <= 1;
        red <= 0;
        win <= 1;
        rst <= 1;
        #1;
        rst <= 0;
        #10000;
        $finish;
	end
endmodule