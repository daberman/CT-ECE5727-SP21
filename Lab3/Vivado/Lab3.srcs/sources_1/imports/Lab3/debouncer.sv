module debouncer #(
    parameter SIM_ONLY = 0,
    parameter DB_TIME  = 1000,
    parameter IS_ASYNC = 1'b1
    )(
    input   clk,
    input   rst,
    input   i_sig,
    output  o_sig
);

localparam DB_TIME_I = SIM_ONLY ? 5 : DB_TIME;

integer counter;
logic   sig, db_sig;

(* ASYNC_REG = "TRUE" *) logic [1:0] sync;

assign sig = IS_ASYNC ? sync[1] : i_sig;

assign o_sig = db_sig;

always_ff @(posedge clk) begin

    sync[1] <= sync[0];
    sync[0] <= i_sig;

    if (db_sig != sig) begin
        if (counter == DB_TIME_I-1) begin
            db_sig  <= sig;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end else begin
        counter <= 0;
    end

    // Reset
    if (rst) begin
        counter <= 0;
        db_sig  <= 1'b0;
    end
end

endmodule