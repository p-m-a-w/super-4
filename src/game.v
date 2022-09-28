module game ( 
    out_player_sel, out_position, out_status, out_red_light,
    max_clicks, red_toggle, click,
    clk, rst
);

output [1:0] out_player_sel, out_red_light;
output [6:0] out_status;
output [7:0] out_position;

input red_toggle, clk, rst;
input [3:0] max_clicks, click;

reg [1:0] out_player_sel;
reg [2:0] current_status;
reg [7:0] counter;
wire [3:0] status, s_a, s_b, s_c, s_d;
wire [2:0] position, pos_a, pos_b, pos_c, pos_d;


redlight_logic logic_rl(
    .out_red_light(out_red_light),
    .red_toggle(red_toggle),
    .clk(clk), .rst(rst)
);

sseg_decoder status_dec(
    out_status,
    status,
    clk
);

binary_comparator pos_dec(
    out_position,
    position,
    clk
);

pos_mux mux_a(
    position,
    pos_a, pos_b, pos_c, pos_d, out_player_sel,
    clk
);

status_mux mux_b(
    status,
    s_a, s_b, s_c, s_d, out_player_sel,
    clk
);

car_logic car_a(
    pos_a, s_a,
    out_player_sel == 2'b00, current_status, max_clicks, click[0], red,
    clk, rst
);

car_logic car_b(
    pos_b, s_b,
    out_player_sel == 2'b01, current_status, max_clicks, click[1], red,
    clk, rst
);

car_logic car_c(
    pos_c, s_c,
    out_player_sel == 2'b10, current_status, max_clicks, click[2], red,
    clk, rst
);

car_logic car_d(
    pos_d, s_d,
    out_player_sel == 2'b11, current_status, max_clicks, click[3], red,
    clk, rst
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_player_sel = 2'b00;
        current_status = 3'b001;
        counter = 0;
    end
    else begin
        if (counter == 8'b11111111) out_player_sel = out_player_sel + 1;
        if (status == current_status) current_status = current_status + 1;
        counter = counter + 1;
    end
end

endmodule

module pos_mux(
    out,
    in_a, in_b, in_c, in_d, sel,
    clk
);
    output [2:0] out;
    input clk;
    input [1:0] sel;
    input [2:0] in_a, in_b, in_c, in_d;
    reg [2:0] out;
    always @(posedge clk) begin
             if (sel == 2'b00) out = in_a; // TODO: initial
        else if (sel == 2'b01) out = in_b;
        else if (sel == 2'b10) out = in_c;
                         else  out = in_d; // TODO: defeat
    end
endmodule

module status_mux(
    out,
    status_a, status_b, status_c, status_d, sel,
    clk
);
    output [3:0] out;
    input clk;
    input [1:0] sel;
    input [3:0] status_a, status_b, status_c, status_d;
    reg [3:0] out;
    always @(posedge clk) begin
             if (sel == 2'b00) out = status_a; // TODO: initial
        else if (sel == 2'b01) out = status_b;
        else if (sel == 2'b10) out = status_c;
                         else  out = status_d; // TODO: defeat
    end
endmodule

module car_logic (
    out_position, out_status,

    enable, status, max_clicks, click, red,
    clk, rst
);

output [3:0] out_status;
output [2:0] out_position;

input enable, click, red, clk, rst;
input [2:0] status;
input [3:0] max_clicks;

reg clicked, stop;
reg [3:0] total_clicks, out_status, current_status;
reg [2:0] out_position, total_steps;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_status = 4'b0000;
        out_position = 3'b000;

        clicked = 1'b0;
        total_clicks = 0;
        total_steps = 0;
        stop = 0;
        current_status = 0;
    end
    else begin
        if (!enable) begin
            out_status = 0;
            out_position = 0;
        end
        else begin
            out_status = current_status;
            out_position = total_steps;
        end

        if (!clicked && click && !stop) begin
            clicked = 1;
        end
        else if (clicked && !click) begin
            if (red) begin
                stop = 1;
                current_status = 4'b1000;
            end
            else if (total_steps >= 7) begin
                stop = 1;
                current_status = status;
            end
            else if (total_clicks >= max_clicks) begin
                total_clicks <= 0;
                total_steps <= total_steps + 1;
            end
            else total_clicks = total_clicks + 1;
            clicked = 0;
        end
    end
end
    
endmodule

module sseg_decoder(
    out,
    in,
    clk
);
    output [6:0] out;
    input [3:0] in;
    input clk;
    reg [6:0] out;
    always @(posedge clk) begin
             if (in == 4'b0000) out = 7'b0000000; // TODO: initial
        else if (in == 4'b0001) out = 7'b0110000;
        else if (in == 4'b0010) out = 7'b1101101;
        else if (in == 4'b0011) out = 7'b1111001;
        else if (in == 4'b0100) out = 7'b0110011;
                          else  out = 7'b0000001; // TODO: defeat
    end
endmodule

module binary_comparator(
    out,
    in,
    clk
);
    output [7:0] out;
    input [2:0] in;
    input clk;
    reg [7:0] out;
    always @(posedge clk) begin
             if (in == 0) out = 8'b00000001;
        else if (in == 1) out = 8'b00000011;
        else if (in == 2) out = 8'b00000111;
        else if (in == 3) out = 8'b00001111;
        else if (in == 4) out = 8'b00011111;
        else if (in == 5) out = 8'b00111111;
        else if (in == 6) out = 8'b01111111;
        else if (in == 7) out = 8'b11111111;
    end
endmodule

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
