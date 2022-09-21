`include "src/game_logic.v"
module game (
    output [1:0] output_player,
    output [2:0] position,
    output [3:0] status_code,

    input [4:0] max_clicks, 
    input [2:0] max_steps,
    input red_toggle,
    input [3:0] click,

    input clk, rst
);

reg win, red;
reg [1:0] current_player;
reg [13:0] counter;
reg enables [3:0];
wire [3:0] status_codes [3:0];
wire [2:0] positions [3:0];

generate
    genvar i;
    for (i=0; i<4; i=i+1) begin
        game_logic i_game_logic(.clk(clk), .rst(rst), 
            .red(red),
            .win(win),
            .max_clicks(max_clicks), 
            .max_steps(max_steps), 
            .click(click[i]), 
            .enable(current_player == i && enables[i]), 
            .position(positions[i]), 
            .status_code(status_codes[i])
        );
    end
endgenerate

always @(posedge rst) begin
    current_player <= 0;
    counter <= 0;
    red <= 0;
    win <= 0;

    enables[0] <= 1;
    enables[1] <= 1;
    enables[2] <= 1;
    enables[3] <= 1;
end

assign position = positions[current_player];
assign status_code = status_codes[current_player]; 
assign output_player = current_player;
always @(posedge clk) begin
    if (counter == 10000) begin // scale freq down to 100Hz
        counter <= 0;
        current_player <= current_player + 1;
    end
    else counter <= counter + 1;

    if (status_code[2] && status_code != 4'b1000 && enables[current_player]) begin
        enables[current_player] <= 0;
        win <= 1;
    end

    if (win) win <= 0;
end

endmodule