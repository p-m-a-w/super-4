module game_logic (
    position, status_code,

    max_clicks, max_steps, enable, click, red, win, clk, rst
);

output [3:0] position, status_code;

input [3:0] max_clicks, max_steps;
input clk, enable, click, red, win, rst;

reg clicked;
reg [3:0] total_clicks, status, total_steps;
reg [2:0] wining_place;

/*
Status code:
0xxx: !OK to display
1xxx: OK to display
*/

always @(posedge rst) begin
    clicked <= 0;
    total_clicks <= 0;
    total_steps <= 0;
    wining_place <= 3'b001;
    status <= 4'b1000;
end

always @(posedge win) begin
    wining_place <= wining_place + 1;
end

assign position = total_steps;
assign status_code = status;
always @(posedge clk) begin
    if (enable && status[3] && clicked) begin
        if (!red) total_clicks <= total_clicks + 1;
        else status <= 4'b0000;
        clicked <= 0;
    end

    if (enable && total_steps >= max_steps) begin
        status[0] <= wining_place[0];
        status[1] <= wining_place[1];
        status[2] <= wining_place[2];
        status[3] <= 1;
    end

    if (total_clicks >= max_clicks) begin
        total_clicks <= 0;
        total_steps <= total_steps + 1;
    end
end

always @(posedge click) begin
    clicked <= 1;
end
    
endmodule