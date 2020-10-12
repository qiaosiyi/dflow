`timescale 1ns/1ps
/**********************************************************************************
 * DFLOW proj verilog module: a2sbus.v                                            *
 *                                                                                *
 *                                                                                *
 *                                                                                *
 * Copyright 2020 XJTU QSY.                                                       *
 * Description:                                                                   *
 * AXI-Stream-BUS 2 simple-BUS.                                                   *
 **********************************************************************************/
module a2sbus #(
        parameter           TDATA_WIDTH         = 256
        ) (
        input                                  ACLK,
        input                                  ARESETN,

        input                                  S_AXIS_TVALID,
        input           [TDATA_WIDTH-1 : 0]    S_AXIS_TDATA,
        input       [(TDATA_WIDTH/8)-1 : 0]    S_AXIS_TKEEP,
        input                                  S_AXIS_TLAST,
        output reg                             S_AXIS_TREADY,

        output reg                             M_SBUS_VALID,
        output reg      [TDATA_WIDTH-1 : 0]    M_SBUS_TDATA,
        output reg  [(TDATA_WIDTH/8)-1 : 0]    M_SBUS_TKEEP,
        output reg                  [7 : 0]    M_SBUS_CTL //普通数据包FF开头，每一级都递减1，包结尾用01，
        );

    reg                             [7 : 0]    CTL_counter;
    wire                [TDATA_WIDTH-1 : 0]    S_AXIS_TDATA_C;
    wire            [(TDATA_WIDTH/8)-1 : 0]    S_AXIS_TKEEP_C;

    assign S_AXIS_TDATA_C = {S_AXIS_TDATA[ 7 : 0 ], S_AXIS_TDATA[ 15 : 8 ], S_AXIS_TDATA[ 23 : 16 ], 
                             S_AXIS_TDATA[ 31 : 24 ], S_AXIS_TDATA[ 39 : 32 ], S_AXIS_TDATA[ 47 : 40 ], 
                             S_AXIS_TDATA[ 55 : 48 ], S_AXIS_TDATA[ 63 : 56 ], S_AXIS_TDATA[ 71 : 64 ], 
                             S_AXIS_TDATA[ 79 : 72 ], S_AXIS_TDATA[ 87 : 80 ], S_AXIS_TDATA[ 95 : 88 ], 
                             S_AXIS_TDATA[ 103 : 96 ], S_AXIS_TDATA[ 111 : 104 ], S_AXIS_TDATA[ 119 : 112 ], 
                             S_AXIS_TDATA[ 127 : 120 ], S_AXIS_TDATA[ 135 : 128 ], S_AXIS_TDATA[ 143 : 136 ], 
                             S_AXIS_TDATA[ 151 : 144 ], S_AXIS_TDATA[ 159 : 152 ], S_AXIS_TDATA[ 167 : 160 ], 
                             S_AXIS_TDATA[ 175 : 168 ], S_AXIS_TDATA[ 183 : 176 ], S_AXIS_TDATA[ 191 : 184 ], 
                             S_AXIS_TDATA[ 199 : 192 ], S_AXIS_TDATA[ 207 : 200 ], S_AXIS_TDATA[ 215 : 208 ], 
                             S_AXIS_TDATA[ 223 : 216 ], S_AXIS_TDATA[ 231 : 224 ], S_AXIS_TDATA[ 239 : 232 ], 
                             S_AXIS_TDATA[ 247 : 240 ], S_AXIS_TDATA[ 255 : 248 ]};

    assign S_AXIS_TKEEP_C = {S_AXIS_TKEEP[ 0 ], S_AXIS_TKEEP[ 1 ], S_AXIS_TKEEP[ 2 ], S_AXIS_TKEEP[ 3 ], 
                             S_AXIS_TKEEP[ 4 ], S_AXIS_TKEEP[ 5 ], S_AXIS_TKEEP[ 6 ], S_AXIS_TKEEP[ 7 ], 
                             S_AXIS_TKEEP[ 8 ], S_AXIS_TKEEP[ 9 ], S_AXIS_TKEEP[ 10 ], S_AXIS_TKEEP[ 11 ], 
                             S_AXIS_TKEEP[ 12 ], S_AXIS_TKEEP[ 13 ], S_AXIS_TKEEP[ 14 ], S_AXIS_TKEEP[ 15 ], 
                             S_AXIS_TKEEP[ 16 ], S_AXIS_TKEEP[ 17 ], S_AXIS_TKEEP[ 18 ], S_AXIS_TKEEP[ 19 ], 
                             S_AXIS_TKEEP[ 20 ], S_AXIS_TKEEP[ 21 ], S_AXIS_TKEEP[ 22 ], S_AXIS_TKEEP[ 23 ], 
                             S_AXIS_TKEEP[ 24 ], S_AXIS_TKEEP[ 25 ], S_AXIS_TKEEP[ 26 ], S_AXIS_TKEEP[ 27 ], 
                             S_AXIS_TKEEP[ 28 ], S_AXIS_TKEEP[ 29 ], S_AXIS_TKEEP[ 30 ], S_AXIS_TKEEP[ 31 ]};

    always @(posedge ACLK) begin
        if (~ARESETN) begin
            S_AXIS_TREADY <= 1;
            CTL_counter <= 8'hFF;
            M_SBUS_VALID <= 0;
            M_SBUS_TDATA <= 0;
            M_SBUS_TKEEP <= 0;
            M_SBUS_CTL <= 0;
        end else begin
            if (S_AXIS_TVALID) begin
                M_SBUS_VALID <= 1;
                M_SBUS_TDATA <= S_AXIS_TDATA_C;
                M_SBUS_TKEEP <= S_AXIS_TKEEP_C;
                if (S_AXIS_TLAST) begin
                    M_SBUS_CTL <= 8'h01;
                    CTL_counter <= 8'hFF;
                end else begin
                    M_SBUS_CTL <= CTL_counter;
                    CTL_counter <= CTL_counter - 1;
                end
            end else begin
                M_SBUS_VALID <= 0;
                M_SBUS_TDATA <= 0;
                M_SBUS_TKEEP <= 0;
                M_SBUS_CTL <= 0;
            end
        end
    end


endmodule
