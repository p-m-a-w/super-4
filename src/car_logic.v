module car_logic (
    out_position, out_finished,

    max_clicks, max_steps, 
    enable, click, red,
    clk, rst
);

output [3:0] out_position;
output out_finished;

input [3:0] max_clicks, max_steps;
input enable, click, red, clk, rst;

reg clicked, finished;
reg [3:0] total_clicks, total_steps;

assign out_position = total_steps;
assign out_finished = finished;
always @(posedge clk) begin
    if (rst) begin
        finished <= 0;
        clicked <= 0;
        total_clicks <= 0;
        total_steps <= 0;
    end
    else if (!clicked && click) begin
        clicked <= 1;
    end
    else if (clicked && !click) begin
        if (enable && clicked) begin
            if (!red) total_clicks <= total_clicks + 1;
            else finished <= 1;
        end
        
        if (total_steps >= max_steps) begin
            finished <= 1;
        end

        if (total_clicks >= max_clicks) begin
            total_clicks <= 0;
            total_steps <= total_steps + 1;
        end
        clicked <= 0;
    end
end
    
endmodule