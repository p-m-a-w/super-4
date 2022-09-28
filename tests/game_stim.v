`include "src/game.v"
`timescale 1 us/1 ns

module game_stim;
    localparam period = 1;
    reg clk, rst;

    reg red_toggle;
    reg [3:0] max_clicks, click;
    wire [6:0] out_status;
    wire [7:0] out_position;
    wire [1:0] out_player_sel, out_red_light;

    game i_game(
        out_player_sel, out_position, out_status, out_red_light,
        max_clicks, red_toggle, click,
        clk, rst
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
        red_toggle <= 0;
        rst <= 1;
        #10;
        rst <= 0;
        #1000000;
        $finish;
	end
endmodule