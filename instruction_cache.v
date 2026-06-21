module instruction_cache (
    input clk, rst,
    input  [31:0] addr,
    output reg [31:0] instr,
    output reg hit
);

parameter CACHE_LINES = 8;
parameter TAG_BITS = 27;

reg              valid [0:CACHE_LINES-1];
reg [TAG_BITS-1:0] tag   [0:CACHE_LINES-1];
reg [31:0]       data  [0:CACHE_LINES-1];

reg [31:0] main_mem [0:63];

wire [2:0] index = addr[4:2];
wire [26:0] addr_tag = addr[31:5];

integer i;
initial begin
    for (i = 0; i < CACHE_LINES; i = i + 1) valid[i] = 0;
    main_mem[0] = {6'b000000, 5'd1, 5'd2, 5'd3, 5'd0, 6'b100000}; // ADD x3,x1,x2
    main_mem[1] = {6'b000000, 5'd3, 5'd1, 5'd5, 5'd0, 6'b100010}; // SUB x5,x3,x1
    main_mem[2] = 32'b0;
    main_mem[3] = 32'b0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < CACHE_LINES; i = i + 1) valid[i] <= 0;
    end else begin
        if (valid[index] && tag[index] == addr_tag) begin
            instr <= data[index];
            hit   <= 1;
        end else begin
            data[index]  <= main_mem[addr[31:2]];
            tag[index]   <= addr_tag;
            valid[index] <= 1;
            instr        <= main_mem[addr[31:2]];
            hit          <= 0;
        end
    end
end

endmodule
