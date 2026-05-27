#define NOC_MEM_BASE             0x00080000
#define NOC_NODES                16
#define MEM_MAPPED_REGS          NOC_NODES
#define NI_MEM_DATA_BYTES        4
#define NI_MEM_DEPTH             4096
#define NI_MEM_SECTION_SIZE      ((NI_MEM_DEPTH / MEM_MAPPED_REGS) * NI_MEM_DATA_BYTES)

// TX region
#define ID_REG_BASE              (NOC_MEM_BASE)
#define NOC_TXMAPPED_REGS_BASE   (ID_REG_BASE + NI_MEM_DATA_BYTES)
#define NOC_TXMAPPED_REGS_END    (NOC_TXMAPPED_REGS_BASE + MEM_MAPPED_REGS * NI_MEM_DATA_BYTES - 1)
#define NI_TX_MEM_BASE           (NOC_TXMAPPED_REGS_END + 1)
#define NI_MEM_SECTIONS_BASE     (NI_TX_MEM_BASE)
#define NI_TX_MEM_END            (NI_TX_MEM_BASE + NI_MEM_DEPTH * NI_MEM_DATA_BYTES - 1)

// RX region
#define NOC_RXMAPPED_REGS_BASE   (NI_TX_MEM_END + 1)
#define NOC_RXMAPPED_REGS_END    (NOC_RXMAPPED_REGS_BASE + MEM_MAPPED_REGS * NI_MEM_DATA_BYTES - 1)
#define NI_RXMEM_BASE            (NOC_RXMAPPED_REGS_END + 1)
#define NI_RXMEM_SECTIONS_BASE   (NI_RXMEM_BASE)
#define NI_RXMEM_END             (NI_RXMEM_BASE + NI_MEM_DEPTH * NI_MEM_DATA_BYTES - 1)

#define BYTE unsigned char
#include <stdint.h>

volatile uint32_t *ID_REG = (volatile uint32_t*)ID_REG_BASE;

//TX REGION

volatile uint32_t* TX_REGS[16] = {
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x00),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x04),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x08),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x0C),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x10),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x14),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x18),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x1C),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x20),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x24),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x28),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x2C),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x30),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x34),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x38),
    (volatile uint32_t*)(NOC_TXMAPPED_REGS_BASE + 0x3C)
};

volatile uint32_t* TX_MEM_SECTION[16] = {
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 0 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 1 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 2 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 3 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 4 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 5 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 6 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 7 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 8 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 9 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 10 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 11 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 12 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 13 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 14 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_MEM_SECTIONS_BASE + 15 * NI_MEM_SECTION_SIZE),
};


//RX REGION
volatile uint32_t* RX_REGS[16] = {
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x00),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x04),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x08),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x0C),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x10),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x14),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x18),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x1C),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x20),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x24),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x28),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x2C),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x30),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x34),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x38),
    (volatile uint32_t*)(NOC_RXMAPPED_REGS_BASE + 0x3C)
};

volatile uint32_t* RX_MEM_SECTION[16] = {
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 0 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 1 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 2 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 3 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 4 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 5 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 6 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 7 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 8 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 9 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 10 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 11 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 12 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 13 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 14 * NI_MEM_SECTION_SIZE),
    (volatile uint32_t*)(NI_RXMEM_SECTIONS_BASE + 15 * NI_MEM_SECTION_SIZE),
};

uint32_t read_reg(uint8_t reg)
{
    return *TX_REGS[reg];
}

uint32_t read_rx_reg(uint8_t reg){
    return *RX_REGS[reg];
}

void read_data(uint32_t node, uint32_t* buffer, uint32_t len)
{
    for(uint32_t i =0; i< len ; i++){
        buffer[i] = RX_MEM_SECTION[node][i];
    }
}

uint32_t read_data_single(uint32_t node, uint32_t offset)
{
    
    return RX_MEM_SECTION[node][offset];
    
}

void send_data(uint32_t node)
{
    *TX_REGS[node] |= 0x2;
}

uint32_t get_hart_id()
{
    return *ID_REG;
}

void poll_on_sent(int node){
    volatile BYTE* reg_bytes = (volatile BYTE*)TX_REGS[node];
    while(!(reg_bytes[0] & 0x1)){;}
}

void poll_on_receive(uint8_t node){
    volatile BYTE* reg_bytes = (volatile BYTE*)RX_REGS[node];
    while(!(reg_bytes[0] & 0x1)){;}
}

void write_data(uint32_t node, uint32_t* data,uint32_t len)
{
    volatile uint16_t* reg_bytes = (volatile uint16_t*)TX_REGS[node];
    reg_bytes[1] = len;
    for (uint32_t i = 0; i < len; i++) {
        TX_MEM_SECTION[node][i] = data[i];
    }
}

void write_data_single(uint32_t node, uint32_t data, uint32_t offset)
{
    volatile uint16_t* reg_bytes = (volatile uint16_t*)TX_REGS[node];
    reg_bytes[1] = 1;
    TX_MEM_SECTION[node][offset] = data;
}

void wfi()
{
    while(1) {;}
}