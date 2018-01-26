`timescale 1ns / 1ps
`default_nettype none

module hdr();
    // Clock
    reg clk;
    
    // RAM variables
    reg ramWe;
    reg [7:0] ramData;
    reg [20:0] ramAddr;
    wire [7:0] ramQ; 
        
    // Warp variables
    reg [9:0] i;
    reg [9:0] j;
    wire [20:0] warpOut;
    reg [7:0] pix;
    
    // Loop variables
    integer k;
    integer f;
    
    // Clock
    initial begin
        clk = 0;
    end
    always #1 clk = ~clk;

    
    // Wires in the modules
    warpModule warp(.clk(clk), .j(j), .i(i), .out(warpOut));
    ramModule ram_TB(.clk(clk), .we(ramWe), .data(ramData), .addr(ramAddr), .q(ramQ));
    
    // Main loop
    always begin
        i = 0;
        j = 0;
        for (k = 0; k < 640*480; k = k + 1) begin
            @(posedge clk)
            // Read in pixel at address k
            ramWe = 0;
            ramAddr = k;
            pix = ramQ;		// Stores the pixel value
        
            // Move that pixel to a new location
            @(posedge clk)
            ramWe = 1;
            ramAddr = 400000 + warpOut;
            ramData = pix;

            j = j + 1;
            if (j < 639) begin
                j = 0;
                i = i + 1;
            end
        end
		
		
		

        // Outputs image
        f = $fopen("output.txt","w");
        ramWe = 0;
        for (k = 0; k < 640*480; k = k + 1) begin
            @(posedge clk)
            ramAddr = k + (400000);
            $fwrite(f,"%b\n",ramQ);
        end
        $finish;
    end
endmodule
