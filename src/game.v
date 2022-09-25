`include "src/game_logic.v"

module game ( output_player, position, status_code,
 max_clicks,  max_steps, red_toggle, click,
 clk, rst
);

output [1:0] output_player;
output [3:0] status_code, position;

input [3:0] max_clicks, max_steps, click;
input red_toggle;

input clk, rst;

reg win, red;
reg [1:0] current_player;
reg [3:0] out_position, out_status_code, enables;
reg [13:0] counter;
wire [3:0] status_code_a, status_code_b, status_code_c, status_code_d;
wire [3:0] position_a, position_b, position_c, position_d;

game_logic i_game_logic_a(.clk(clk), .rst(rst), 
            .red(red),
            .win(win),
            .max_clicks(max_clicks), 
            .max_steps(max_steps), 
            .click(click[0]), 
            .enable(enables[0]), 
            .position(position_a), 
            .status_code(status_code_a)
        );

game_logic i_game_logic_b(.clk(clk), .rst(rst), 
            .red(red),
            .win(win),
            .max_clicks(max_clicks), 
            .max_steps(max_steps), 
            .click(click[1]), 
            .enable(enables[1]), 
            .position(position_b), 
            .status_code(status_code_b)
        );

game_logic i_game_logic_c(.clk(clk), .rst(rst), 
            .red(red),
            .win(win),
            .max_clicks(max_clicks), 
            .max_steps(max_steps), 
            .click(click[2]), 
            .enable(enables[2]), 
            .position(position_c), 
            .status_code(status_code_c)
        );

game_logic i_game_logic_d(.clk(clk), .rst(rst), 
            .red(red),
            .win(win),
            .max_clicks(max_clicks), 
            .max_steps(max_steps), 
            .click(click[3]), 
            .enable(enables[3]), 
            .position(position_d), 
            .status_code(status_code_d)
        );

always @(posedge rst) begin
    current_player <= 0;
    counter <= 0;
    red <= 0;
    win <= 0;

    enables[0] <= 1;
    enables[1] <= 1;
    enables[2] <= 1;
    enables[3] <= 1;
    out_position <= 0;
    out_status_code <= 0;
end

assign position = out_position;
assign status_code = out_status_code;
assign output_player = current_player;
always @(posedge clk) begin
    if (counter == 9999) begin // TODO: scale freq down 1MHz to 100Hz
        if (out_status_code > 4'b1000 && enables[current_player]) begin
            enables[current_player] <= 0;
            win <= 1;
        end
        current_player <= current_player + 1;
        counter <= 0;
    end
    else begin
        /* Array replacement */
        if (current_player == 0) begin
            out_status_code <= status_code_a;
            out_position <= position_a;
        end
        else if (current_player == 1) begin
            out_status_code <= status_code_b;
            out_position <= position_b;
        end
        else if (current_player == 2) begin
            out_status_code <= status_code_c;
            out_position <= position_c;
        end
        else if (current_player == 3) begin
            out_status_code <= status_code_d;
            out_position <= position_d;
        end

        if (win) win <= 0;
        counter <= counter + 1;
    end
end

endmodule