module or1200_memory_path (
    input clk, rst,
    input  [31:0] virtual_pc,
    input         interrupt_req,
    input         interrupt_enable,
    output [31:0] fetched_instr,
    output        cache_hit,
    output        page_fault,
    output        in_handler,
    output [31:0] next_pc
);

wire [31:0] physical_addr;

mmu MMU (
    .clk(clk), .rst(rst),
    .virtual_addr(virtual_pc),
    .physical_addr(physical_addr),
    .page_fault(page_fault)
);

instruction_cache ICACHE (
    .clk(clk), .rst(rst),
    .addr(physical_addr),
    .instr(fetched_instr),
    .hit(cache_hit)
);

interrupt_unit INTR (
    .clk(clk), .rst(rst),
    .interrupt_req(interrupt_req),
    .interrupt_enable(interrupt_enable),
    .current_pc(virtual_pc),
    .next_pc(next_pc),
    .in_handler(in_handler),
    .saved_pc()
);

endmodule
