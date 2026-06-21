module mmu (
    input clk, rst,
    input  [31:0] virtual_addr,
    output reg [31:0] physical_addr,
    output reg page_fault
);

parameter PAGE_SIZE_BITS = 8;
parameter NUM_PAGES = 16;

reg              page_valid [0:NUM_PAGES-1];
reg [23:0]       phys_page  [0:NUM_PAGES-1];

wire [3:0]  vpn    = virtual_addr[31:PAGE_SIZE_BITS];
wire [PAGE_SIZE_BITS-1:0] offset = virtual_addr[PAGE_SIZE_BITS-1:0];

integer i;
initial begin
    for (i = 0; i < NUM_PAGES; i = i + 1) page_valid[i] = 0;
    page_valid[0] = 1; phys_page[0] = 24'd5;
    page_valid[1] = 1; phys_page[1] = 24'd2;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        physical_addr <= 0;
        page_fault    <= 0;
    end else begin
        if (page_valid[vpn]) begin
            physical_addr <= {phys_page[vpn], offset};
            page_fault    <= 0;
        end else begin
            physical_addr <= 32'b0;
            page_fault    <= 1;
        end
    end
end

endmodule
