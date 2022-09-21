module game_logic (
    output [2:0] position,
    output [3:0] status_code,

    input [4:0] max_clicks, 
    input [2:0] max_steps,
    input clk, enable, click, red, win, rst
);

reg clicked;
reg [4:0] total_clicks;
reg [3:0] status;
reg [2:0] total_steps;
reg [1:0] wining_place;

/*
Status code:
0xxx: OK to click
1xxx: !OK to click
*/

always @(posedge rst) begin
    clicked <= 0;
    total_clicks <= 0;
    total_steps <= 0;
    wining_place <= 2'b01;
    status <= 4'b1000;
end

always @(posedge win) begin
    wining_place <= wining_place + 1;
end

assign position = total_steps;
assign status_code = status;
always @(posedge clk) begin
    if (!status[3] && enable) begin
        if (clicked) begin
            if (!red) total_clicks <= total_clicks + 1;
            else status <= 4'b1000;
            clicked <= 0;
        end

        if (total_clicks >= max_clicks) begin
            total_clicks <= 0;
            total_steps <= total_steps + 1;
        end

        if (total_steps >= max_steps) begin
            status <= wining_place;
            status[3] <= 1;
        end
    end
end

always @(posedge click) begin
    clicked <= 1;
end
    
endmodule