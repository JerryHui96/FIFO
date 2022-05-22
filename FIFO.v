// Jerry Xu

module FIFO(
    input clk, rst, data_push, data_pull,
    input [16:0] data_in,
    output stop_empty, stop_full,
    output [16:0] data_out
);

reg [16:0] mem [0:7];
reg [2:0] ptr_write, ptr_read;
reg full, empty;
reg [16:0] out;

assign stop_empty = empty;
assign stop_full = full;
assign data_out = out;   //Simulate SA0 in output pin 15

always @ (posedge clk) begin
    if (rst) begin
        mem [0] <= 0;
        mem [1] <= 0;
        mem [2] <= 0;
        mem [3] <= 0;
        mem [4] <= 0;
        mem [5] <= 0;
        mem [6] <= 0;
        mem [7] <= 0;
        {full, out} <= 0;
        {ptr_write, ptr_read} <= 0;
        empty <= 1;
    end
    else begin
        if(data_pull && ~empty) begin
            full <= 0;
            out <= mem[{ptr_read[2], 0, ptr_read[0]}];  //Simulate SA0 at Pin 1 for ptr_read counter
            mem[ptr_read] <= 0;
            ptr_read = ptr_read + 1;
            //empty <= (ptr_read == ptr_write)? 1:0;
            empty <= (ptr_read == ptr_write)? 1:0;
        end
        if(data_push && ~full) begin
            empty <= 0;
            mem[ptr_write] <= data_in;
            ptr_write = ptr_write + 1;
            //full <= (ptr_write == ptr_read) ? 1:0;
            full <= (ptr_write == ptr_read) ? 1:0;
        end
    end
end

endmodule


