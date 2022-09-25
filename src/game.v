`include "src/car_logic.v"
`include "src/redlight_logic.v"

module game ( 
    out_player_sel, out_position, out_status_code, out_red_light,
    max_clicks, max_steps, red_toggle, clicks,
    clk, rst
);


/*
Status code:
0xxx: !OK to display
1xxx: OK to display
*/

output [1:0] out_player_sel, out_red_light;
output [3:0] out_status_code, out_position;

input [3:0] max_clicks, max_steps, clicks;
input red_toggle;

input clk, rst;

reg [1:0] current_player;
reg [1:0] counter;
wire finished_a, finished_b, finished_c, finished_d;
wire [3:0] position_a, position_b, position_c, position_d;
reg [3:0] int_position, int_status_code, enables, places, status_a, status_b, status_c, status_d;

redlight_logic logic_rl(
    .out_red_light(out_red_light),
    .red_toggle(red_toggle),
    .clk(clk), .rst(rst)
);
car_logic logic_pa(
    .out_position(position_a), .out_finished(finished_a),

    .max_clicks(max_clicks), .max_steps(max_steps), 
    .enable(enables[0]), .click(clicks[0]), .red(out_red_light == 2'b10),
    .clk(clk), .rst(rst)
);
car_logic logic_pb(
    .out_position(position_b), .out_finished(finished_b),

    .max_clicks(max_clicks), .max_steps(max_steps), 
    .enable(enables[1]), .click(clicks[1]), .red(out_red_light == 2'b10),
    .clk(clk), .rst(rst)
);
car_logic logic_pc(
    .out_position(position_c), .out_finished(finished_c),

    .max_clicks(max_clicks), .max_steps(max_steps), 
    .enable(enables[2]), .click(clicks[2]), .red(out_red_light == 2'b10),
    .clk(clk), .rst(rst)
);
car_logic logic_pd(
    .out_position(position_d), .out_finished(finished_d),

    .max_clicks(max_clicks), .max_steps(max_steps), 
    .enable(enables[3]), .click(clicks[3]), .red(out_red_light == 2'b10),
    .clk(clk), .rst(rst)
);

assign out_position = int_position;
assign out_status_code = int_status_code;
assign out_player_sel = current_player;
always @(posedge clk) begin
    if (rst) begin
        current_player <= 0;
        counter <= 0;

        places <= 4'b1001;
        status_a <= 4'b1000;
        status_b <= 4'b1000;
        status_c <= 4'b1000;
        status_d <= 4'b1000;
        enables <= 4'b1111;
        int_position <= 0;
        int_status_code <= 0;
    end
    else begin
        if (counter == 1) begin
            if (current_player == 0) begin
                int_position <= position_a;
                int_status_code <= status_a;
                if (enables[0]) begin
                    if (out_red_light == 2'b10 && finished_a) begin
                        status_a <= 4'b0000;
                        enables[0] <= 0;
                    end
                    else if (out_red_light != 2'b10 && finished_a) begin
                        status_a <= places; 
                        places <= places + 1;
                        enables[0] <= 0;
                    end
                    else status_a <= status_a;
                end
            end
            else if (current_player == 1) begin
                int_position <= position_b;
                int_status_code <= status_b;
                if (enables[1]) begin
                    if (out_red_light == 2'b10 && finished_b) begin
                        status_b <= 4'b0000;
                        enables[1] <= 0;
                    end
                    else if (out_red_light != 2'b10 && finished_b) begin
                        status_b <= places; 
                        places <= places + 1;
                        enables[1] <= 0;
                    end
                    else status_b <= status_b;
                end
            end
            else if (current_player == 2) begin
                int_position <= position_c;
                int_status_code <= status_c;
                if (enables[2]) begin
                    if (out_red_light == 2'b10 && finished_c) begin
                        status_c <= 4'b0000;
                        enables[2] <= 0;
                    end
                    else if (out_red_light != 2'b10 && finished_c) begin
                        status_c <= places; 
                        places <= places + 1;
                        enables[2] <= 0;
                    end
                    else status_c <= status_c;
                end
            end
            else if (current_player == 3) begin
                int_position <= position_d;
                int_status_code <= status_d;
                if (enables[3]) begin 
                    if (out_red_light == 2'b10 && finished_d) begin
                        status_d <= 4'b0000;
                        enables[3] <= 0;
                    end
                    else if (out_red_light != 2'b10 && finished_d) begin
                        status_d <= places; 
                        places <= places + 1;
                        enables[3] <= 0;
                    end
                    else status_d <= status_d;
                end
            end
            current_player <= current_player + 1;
            counter <= 0;
        end
        else counter <= counter + 1;
    end
end

endmodule