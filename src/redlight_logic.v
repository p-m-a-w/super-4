module redlight_logic (
    out_red_light,
    red_toggle,
    clk, rst
);

/*
Redlight code:
10: RED
11: YELLOW
01: GREEN
*/

output [1:0] out_red_light;
input red_toggle, clk, rst;

reg red_clicked, red_light;

assign out_red_light = red_light;
always @(posedge clk) begin
    if (rst) begin
        red_light <= 2'b01;
        red_clicked <= 0;
    end
    else begin
        if (!red_clicked && red_toggle) red_clicked <= 1;
        else if (red_clicked && !red_toggle) begin
            if (red_light == 2'b01) red_light <= 2'b11;
            else if (red_light == 2'b11) red_light <= 2'b10;
            else red_light <= 2'b01;
            red_clicked <= 0;
        end
    end
end
    
endmodule