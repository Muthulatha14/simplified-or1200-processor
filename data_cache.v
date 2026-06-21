module data_cache (
    input clk, rst,
    input  [31:0] addr,
    input  [31:0] write_data,
    input         mem_read,
    input         mem_write,
    output reg [31:0] read_data,
    output reg         hit
);

parameter CACHE_LINES = 8;

reg                valid [0:CACHE_LINES-1];
reg [26:0]         tag   [0:CACHE_LINES-1];
reg [31:0]         data  [0:CACHE_LINES-1];

reg [31:0] main_mem [0:63];

wire [2:0]  index    = addr[4:2];
wire [26:0] addr_tag = addr[31:5];

integer i;
initial begin
    for (i = 0; i < CACHE_LINES; i = i + 1) valid[i] = 0;
    for (i = 0; i < 64; i = i + 1) main_mem[i] = 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < CACHE_LINES; i = i + 1) valid[i] <= 0;
    end
    else if (mem_write) begin
        data[index]          <= write_data;
        tag[index]           <= addr_tag;
        valid[index]         <= 1;
        main_mem[addr[31:2]] <= write_data;
        hit                  <= valid[index] && (tag[index] == addr_tag);
    end
    else if (mem_read) begin
        if (valid[index] && tag[index] == addr_tag) begin
            read_data <= data[index];
            hit       <= 1;
        end else begin
            data[index]  <= main_mem[addr[31:2]];
            tag[index]   <= addr_tag;
            valid[index] <= 1;
            read_data    <= main_mem[addr[31:2]];
            hit          <= 0;
        end
    end
end

endmodule
