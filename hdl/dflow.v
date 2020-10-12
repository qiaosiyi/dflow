`timescale 1ns/1ps
/**********************************************************************************
 * DFLOW proj verilog module: dflow.v                                             *
 *                                                                                *
 *                                                                                *
 *                                                                                *
 * Copyright 2020 XJTU QSY.                                                       *
 * Description:                                                                   *
 * dflow function core.                                                           *
 **********************************************************************************/
module dflow #(
        parameter           TDATA_WIDTH         = 256
        ) (
        input                                  ACLK,
        input                                  ARESETN,

        input                                  S_SBUS_VALID,
        input           [TDATA_WIDTH-1 : 0]    S_SBUS_TDATA,
        input       [(TDATA_WIDTH/8)-1 : 0]    S_SBUS_TKEEP,
        input                                  S_SBUS_CTL,

        output reg                             M_SBUS_VALID,
        output reg      [TDATA_WIDTH-1 : 0]    M_SBUS_TDATA,
        output reg  [(TDATA_WIDTH/8)-1 : 0]    M_SBUS_TKEEP,
        output reg                  [7 : 0]    M_SBUS_CTL 
        );

    reg                              [31:0]    SIP;
    reg                              [31:0]    DIP;
    reg                              [15:0]    SPORT;
    reg                              [15:0]    DPORT;
    reg                               [7:0]    P;
    reg                              [16:0]    length;
    reg                                        tuple_valid;
    reg                                        ipv4;

    


    always @(posedge ACLK) begin
        if (~ARESETN) begin
            SIP <= 0;
            DIP <= 0;
            SPORT <= 0;
            DPORT <= 0;
            P <= 0;
            length <= 0;
            tuple_valid <= 0;
            ipv4 <= 0;
        end else begin
            if (S_SBUS_VALID) begin
                if (S_SBUS_CTL == 8'FF )begin
                  if (S_SBUS_TDATA[159:144] == 16'h0800)begin //ipv4 packet
                    SIP <= S_SBUS_TDATA[47:16];
                    P <= S_SBUS_TDATA[71:64];
                    DIP <= {S_SBUS_TDATA[15:0],16'h0000};
                    ipv4 <= 1; 
                    length <= S_SBUS_TDATA[127:112]+14;
                  end else begin
                    ipv4 <= 0;
                  end
                end

                if (ipv4 && S_SBUS_CTL == 8'FE)begin
                  DIP[15:0] <= S_SBUS_TDATA[255:240];
                  SPORT <= S_SBUS_TDATA[239:224];
                  DPORT <= S_SBUS_TDATA[223:208];
                end

                if (ipv4 && S_SBUS_CTL == 8'01)begin
                  tuple_valid <= 1;
                end
            end else begin
                tuple_valid <= 0;
            end
        end
    end


endmodule
