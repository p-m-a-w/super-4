`include "src/game.v"
`timescale 1 us/1 ns

module game_stim;
    localparam period = 1;
    reg clk, rst;

    reg red_toggle;
    reg [4:0] max_clicks;
    reg [2:0] max_steps;
    reg [3:0] click;
    wire [3:0] status_code;
    wire [2:0] position;
    wire [1:0] output_player;

    game i_game(.clk(clk), .rst(rst), 
        .max_clicks(max_clicks),
        .max_steps(max_steps),
        .click(click),
        .output_player(output_player), 
        .position(position), 
        .status_code(status_code)
    );
    

    always begin
        click[0] = 1;
        #30;
        click[0] = 0;
        #30;
    end
    always begin
        click[1] = 1;
        #40;
        click[1] = 0;
        #40;
    end
    always begin
        click[2] = 1;
        #50;
        click[2] = 0;
        #50;
    end
    always begin
        click[3] = 1;
        #60;
        click[3] = 0;
        #70;
    end

    always begin
        clk = 1'b0;
        #1;
        clk = 1'b1;
        #1;
    end

    initial begin
		$dumpfile("game_stim.vcd");
		$dumpvars(0, game_stim);
        max_clicks <= 10;
        max_steps <= 10;
        red_toggle <= 0;
        rst <= 1;
        #1;
        rst <= 0;
        #1000000;
        $finish;
	end
endmodule