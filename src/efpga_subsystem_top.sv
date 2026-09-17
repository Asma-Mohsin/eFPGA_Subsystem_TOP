`timescale 1ns / 1ps

module efpga_subsystem_top #(
    parameter int NUM_SLOTS        = 1,
    parameter int AXI_ID_WIDTH     = 8,
    parameter logic [31:0] HW_VERSION = 32'hFAB00001
) (
    // Global Clock & Synchronized System Resets (from Top Level)
    input  logic                                clk_i,
    input  logic                                rstn_i,      // Synchronized Active-Low Reset
    input  logic                                rst_i,       // Synchronized Active-High Reset

    // =========================================================================
    // 1. AXI4-Lite Slave: Global Manager Interface
    // =========================================================================
    input  logic [31:0]                         s_axil_mgr_awaddr,
    input  logic [2:0]                          s_axil_mgr_awprot,
    input  logic                                s_axil_mgr_awvalid,
    output logic                                s_axil_mgr_awready,
    input  logic [31:0]                         s_axil_mgr_wdata,
    input  logic [3:0]                          s_axil_mgr_wstrb,
    input  logic                                s_axil_mgr_wvalid,
    output logic                                s_axil_mgr_wready,
    output logic [1:0]                          s_axil_mgr_bresp,
    output logic                                s_axil_mgr_bvalid,
    input  logic                                s_axil_mgr_bready,
    input  logic [31:0]                         s_axil_mgr_araddr,
    input  logic [2:0]                          s_axil_mgr_arprot,
    input  logic                                s_axil_mgr_arvalid,
    output logic                                s_axil_mgr_arready,
    output logic [31:0]                         s_axil_mgr_rdata,
    output logic [1:0]                          s_axil_mgr_rresp,
    output logic                                s_axil_mgr_rvalid,
    input  logic                                s_axil_mgr_rready,

    // =========================================================================
    // 2. AXI4-Lite Slave: Slot Control Interface (Array)
    // =========================================================================
    input  logic [NUM_SLOTS*32-1:0]             s_axil_ctrl_awaddr,
    input  logic [NUM_SLOTS*3-1:0]              s_axil_ctrl_awprot,
    input  logic [NUM_SLOTS-1:0]                s_axil_ctrl_awvalid,
    output logic [NUM_SLOTS-1:0]                s_axil_ctrl_awready,
    input  logic [NUM_SLOTS*32-1:0]             s_axil_ctrl_wdata,
    input  logic [NUM_SLOTS*4-1:0]              s_axil_ctrl_wstrb,
    input  logic [NUM_SLOTS-1:0]                s_axil_ctrl_wvalid,
    output logic [NUM_SLOTS-1:0]                s_axil_ctrl_wready,
    output logic [NUM_SLOTS*2-1:0]              s_axil_ctrl_bresp,
    output logic [NUM_SLOTS-1:0]                s_axil_ctrl_bvalid,
    input  logic [NUM_SLOTS-1:0]                s_axil_ctrl_bready,
    input  logic [NUM_SLOTS*32-1:0]             s_axil_ctrl_araddr,
    input  logic [NUM_SLOTS*3-1:0]              s_axil_ctrl_arprot,
    input  logic [NUM_SLOTS-1:0]                s_axil_ctrl_arvalid,
    output logic [NUM_SLOTS-1:0]                s_axil_ctrl_arready,
    output logic [NUM_SLOTS*32-1:0]             s_axil_ctrl_rdata,
    output logic [NUM_SLOTS*2-1:0]              s_axil_ctrl_rresp,
    output logic [NUM_SLOTS-1:0]                s_axil_ctrl_rvalid,
    input  logic [NUM_SLOTS-1:0]                s_axil_ctrl_rready,

    // =========================================================================
    // 3. AXI4 Full Master: Slot DMA Interface (Array)
    // =========================================================================
    output logic [NUM_SLOTS*AXI_ID_WIDTH-1:0]   m_axi_dma_awid,
    output logic [NUM_SLOTS*32-1:0]             m_axi_dma_awaddr,
    output logic [NUM_SLOTS*8-1:0]              m_axi_dma_awlen,
    output logic [NUM_SLOTS*3-1:0]              m_axi_dma_awsize,
    output logic [NUM_SLOTS*2-1:0]              m_axi_dma_awburst,
    output logic [NUM_SLOTS-1:0]                m_axi_dma_awlock,
    output logic [NUM_SLOTS*4-1:0]              m_axi_dma_awcache,
    output logic [NUM_SLOTS*3-1:0]              m_axi_dma_awprot,
    output logic [NUM_SLOTS-1:0]                m_axi_dma_awvalid,
    input  logic [NUM_SLOTS-1:0]                m_axi_dma_awready,
    output logic [NUM_SLOTS*32-1:0]             m_axi_dma_wdata,
    output logic [NUM_SLOTS*4-1:0]              m_axi_dma_wstrb,
    output logic [NUM_SLOTS-1:0]                m_axi_dma_wlast,
    output logic [NUM_SLOTS-1:0]                m_axi_dma_wvalid,
    input  logic [NUM_SLOTS-1:0]                m_axi_dma_wready,
    input  logic [NUM_SLOTS*AXI_ID_WIDTH-1:0]   m_axi_dma_bid,
    input  logic [NUM_SLOTS*2-1:0]              m_axi_dma_bresp,
    input  logic [NUM_SLOTS-1:0]                m_axi_dma_bvalid,
    output logic [NUM_SLOTS-1:0]                m_axi_dma_bready,
    output logic [NUM_SLOTS*AXI_ID_WIDTH-1:0]   m_axi_dma_arid,
    output logic [NUM_SLOTS*32-1:0]             m_axi_dma_araddr,
    output logic [NUM_SLOTS*8-1:0]              m_axi_dma_arlen,
    output logic [NUM_SLOTS*3-1:0]              m_axi_dma_arsize,
    output logic [NUM_SLOTS*2-1:0]              m_axi_dma_arburst,
    output logic [NUM_SLOTS-1:0]                m_axi_dma_arlock,
    output logic [NUM_SLOTS*4-1:0]              m_axi_dma_arcache,
    output logic [NUM_SLOTS*3-1:0]              m_axi_dma_arprot,
    output logic [NUM_SLOTS-1:0]                m_axi_dma_arvalid,
    input  logic [NUM_SLOTS-1:0]                m_axi_dma_arready,
    input  logic [NUM_SLOTS*AXI_ID_WIDTH-1:0]   m_axi_dma_rid,
    input  logic [NUM_SLOTS*32-1:0]             m_axi_dma_rdata,
    input  logic [NUM_SLOTS*2-1:0]              m_axi_dma_rresp,
    input  logic [NUM_SLOTS-1:0]                m_axi_dma_rlast,
    input  logic [NUM_SLOTS-1:0]                m_axi_dma_rvalid,
    output logic [NUM_SLOTS-1:0]                m_axi_dma_rready,

    // =========================================================================
    // 4. External Padring PMOD Interface (24 Wires)
    // =========================================================================
    input  logic [7:0]                          pmod_io_i,
    output logic [7:0]                          pmod_io_o,
    output logic [7:0]                          pmod_io_oe_o,

    // =========================================================================
    // 5. Interrupt Lines to CPU / SoC (5 Lines)
    // =========================================================================
    output logic [3:0]                          efpga_usr_irq_o,
    output logic [NUM_SLOTS-1:0]                efpga_fault_irq_o
);

    // =========================================================================
    // Internal Boundary Signals (Connector <-> Wrapper)
    // =========================================================================
    logic [NUM_SLOTS*32-1:0]            axil_ctrl_m_awaddr, axil_ctrl_m_wdata, axil_ctrl_m_araddr, axil_ctrl_m_rdata;
    logic [NUM_SLOTS*4-1:0]             axil_ctrl_m_wstrb;
    logic [NUM_SLOTS*3-1:0]             axil_ctrl_m_awprot, axil_ctrl_m_arprot;
    logic [NUM_SLOTS*2-1:0]             axil_ctrl_m_bresp, axil_ctrl_m_rresp;
    logic [NUM_SLOTS-1:0]               axil_ctrl_m_awvalid, axil_ctrl_m_awready, axil_ctrl_m_wvalid, axil_ctrl_m_wready, axil_ctrl_m_bvalid, axil_ctrl_m_bready;
    logic [NUM_SLOTS-1:0]               axil_ctrl_m_arvalid, axil_ctrl_m_arready, axil_ctrl_m_rvalid, axil_ctrl_m_rready;

    logic [NUM_SLOTS*32-1:0]            axi4_dma_s_awaddr, axi4_dma_s_wdata, axi4_dma_s_araddr, axi4_dma_s_rdata;
    logic [NUM_SLOTS*4-1:0]             axi4_dma_s_wstrb, axi4_dma_s_awcache, axi4_dma_s_arcache;
    logic [NUM_SLOTS*3-1:0]             axi4_dma_s_awsize, axi4_dma_s_arsize, axi4_dma_s_awprot, axi4_dma_s_arprot;
    logic [NUM_SLOTS*2-1:0]             axi4_dma_s_awburst, axi4_dma_s_arburst, axi4_dma_s_bresp, axi4_dma_s_rresp;
    logic [NUM_SLOTS*AXI_ID_WIDTH-1:0]  axi4_dma_s_awid, axi4_dma_s_bid, axi4_dma_s_arid, axi4_dma_s_rid;
    logic [NUM_SLOTS*8-1:0]             axi4_dma_s_awlen, axi4_dma_s_arlen;
    logic [NUM_SLOTS-1:0]               axi4_dma_s_awvalid, axi4_dma_s_awready, axi4_dma_s_wvalid, axi4_dma_s_wready, axi4_dma_s_bvalid, axi4_dma_s_bready;
    logic [NUM_SLOTS-1:0]               axi4_dma_s_arvalid, axi4_dma_s_arready, axi4_dma_s_rvalid, axi4_dma_s_rready, axi4_dma_s_wlast, axi4_dma_s_rlast;
    logic [NUM_SLOTS-1:0]               axi4_dma_s_awlock, axi4_dma_s_arlock;

    logic [31:0]                        efpga_config_data;
    logic                               efpga_config_we;
    logic                               efpga_soft_reset;
    logic                               efpga_com_active;
    logic [NUM_SLOTS-1:0][31:0]         slot_i_top_arr;
    logic [NUM_SLOTS-1:0][31:0]         slot_o_top_arr;

    
endmodule