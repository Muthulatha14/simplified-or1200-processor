module tb_or1200_memory_path;

reg clk, rst, interrupt_req, interrupt_enable;
reg [31:0] virtual_pc;
wire [31:0] fetched_instr, next_pc;
wire cache_hit, page_fault, in_handler;

or1200_memory_path UUT (
    .clk(clk), .rst(rst),
    .virtual_pc(virtual_pc),
    .interrupt_req(interrupt_req),
    .interrupt_enable(interrupt_enable),
    .fetched_instr(fetched_instr),
    .cache_hit(cache_hit),
    .page_fault(page_fault),
    .in_handler(in_handler),
    .next_pc(next_pc)
);

always #5 clk = ~clk;

initial begin
    clk = 0; rst = 1;
    interrupt_req = 0; interrupt_enable = 1;
    virtual_pc = 0;
    #10 rst = 0;

    virtual_pc = 0;
    #10 $display("VA=%0d | instr=%h | cache_hit=%b page_fault=%b (expect MISS, no fault)",
                   virtual_pc, fetched_instr, cache_hit, page_fault);

    #10 $display("VA=%0d | instr=%h | cache_hit=%b page_fault=%b (expect HIT, no fault)",
                   virtual_pc, fetched_instr, cache_hit, page_fault);

    virtual_pc = {24'd10, 8'h00};
    #10 $display("VA=%h | page_fault=%b (expect FAULT)", virtual_pc, page_fault);

    virtual_pc = 20;
    interrupt_req = 1;
    #10 $display("INTERRUPT during fetch | next_pc=%h | in_handler=%b", next_pc, in_handler);

    $finish;
end

endmodule
