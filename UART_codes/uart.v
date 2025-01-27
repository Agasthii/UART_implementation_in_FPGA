module uart(
    input wire [15:0] data_in,   // 8-bit input data to be transmitted
    input wire Tx_en,           // Enable signal for transmitter
    input wire clear,           // Not used in this instantiation (consider removal if not required)
    input wire clk_50m,         // System clock at 50 MHz
    input wire Rx,              // Received serial data input
    input wire Rx_en,           // Enable signal for receiver  
    input wire ready_clr,       // Signal to clear the ready state
    output wire Tx,             // Transmitted serial data output
    output wire Tx_busy,        // Signal indicating transmitter is busy
    output wire ready,          // Signal to indicate data is ready to be read
    output wire [15:0] data_out // 8-bit output data received
);

    // Internal connections for baud rate enable signals
    wire Txclk_en, Rxclk_en;

    // Instantiate the baud rate generator
    baudrate uart_baud(
        .clk_50m(clk_50m),
        .Rxclk_en(Rxclk_en),    // Enable signal for the receiver clock
        .Txclk_en(Txclk_en)     // Enable signal for the transmitter clock
    );

    // Instantiate the transmitter module
    transmitter uart_Tx(
        .data_in(data_in),
        .Tx_en(Tx_en),
        .clk_50m(clk_50m),
        .clken(Txclk_en),       // Use Tx clock enable for transmitter operation
        .Tx(Tx),
        .Tx_busy(Tx_busy)
    );

    // Instantiate the receiver module
    receiver uart_Rx(
        .Rx(Rx),
        .Rx_en(Rx_en),
        .ready(ready),
        .ready_clr(ready_clr),
        .clk_50m(clk_50m),
        .clken(Rxclk_en),       // Use Rx clock enable for receiver operation
        .data(data_out)
    );

endmodule
