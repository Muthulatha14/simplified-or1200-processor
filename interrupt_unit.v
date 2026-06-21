module interrupt_unit (
    input clk, rst,
    input         interrupt_req,
    input         interrupt_enable,
    input  [31:0] current_pc,
    output reg [31:0] next_pc,
    output reg         in_handler,
    output reg [31:0] saved_pc
);

parameter HANDLER_ADDR = 32'h00000100;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        next_pc    <= 0;
        in_handler <= 0;
        saved_pc   <= 0;
    end
    else if (interrupt_req && interrupt_enable && !in_handler) begin
        saved_pc   <= current_pc;
        next_pc    <= HANDLER_ADDR;
        in_handler <= 1;
    end
    else if (in_handler) begin
        next_pc    <= saved_pc + 4;
        in_handler <= 0;
    end
    else begin
        next_pc    <= current_pc + 4;
    end
end

endmodule
