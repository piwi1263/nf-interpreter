/*
//
// Copyright (c) 2019 The nanoFramework project contributors
// Portions Copyright (c) 2006..2018 Giovanni Di Sirio. All rights reserved.
// See LICENSE file in the project root for full license information.
//
*/

/*
 * STM32H743x generic setup.
 * 
 * AXI SRAM     - BSS, Data, Heap.
 * SRAM1+SRAM2  - None.
 * SRAM3        - NOCACHE, ETH.
 * SRAM4        - None.
 * DTCM-RAM     - Main Stack, Process Stack.
 * ITCM-RAM     - None.
 * BCKP SRAM    - None.
 */

MEMORY
{
    flash       : org = 0x08000000, len = 128k    /* space reserved for nanoBooter (1st sector 0x08000000 to 0x0801FFFF) */
    flash_itcm  : org = 0x00000000, len = 0       
    config      : org = 0x08020000, len = 128k    /* space reserved for configuration block */
    deployment  : org = 0x00000000, len = 0       /* space reserved for application deployment */
    ramvt       : org = 0x00000000, len = 0       /* initial RAM address is reserved for a copy of the vector table */
    ram0        : org = 0x24000000, len = 512k    /* AXI SRAM */
    ram1        : org = 0x30000000, len = 256k    /* AHB SRAM1+SRAM2 */
    ram2        : org = 0x30000000, len = 288k    /* AHB SRAM1+SRAM2+SRAM3 */
    ram3        : org = 0x30040000, len = 32k     /* AHB SRAM3 */
    ram4        : org = 0x38000000, len = 64k     /* AHB SRAM4 */
    ram5        : org = 0x20000000, len = 128k    /* DTCM-RAM */
    ram6        : org = 0x00000000, len = 64k     /* ITCM-RAM */
    ram7        : org = 0x38800000, len = 4k      /* BCKP SRAM */
}

/* For each data/text section two region are defined, a virtual region
   and a load region (_LMA suffix).*/

/* Flash region to be used for exception vectors.*/
REGION_ALIAS("VECTORS_FLASH", flash);
REGION_ALIAS("VECTORS_FLASH_LMA", flash);

/* Flash region to be used for constructors and destructors.*/
REGION_ALIAS("XTORS_FLASH", flash);
REGION_ALIAS("XTORS_FLASH_LMA", flash);

/* Flash region to be used for code text.*/
REGION_ALIAS("TEXT_FLASH", flash);
REGION_ALIAS("TEXT_FLASH_LMA", flash);

/* Flash region to be used for read only data.*/
REGION_ALIAS("RODATA_FLASH", flash);
REGION_ALIAS("RODATA_FLASH_LMA", flash);

/* Flash region to be used for various.*/
REGION_ALIAS("VARIOUS_FLASH", flash);
REGION_ALIAS("VARIOUS_FLASH_LMA", flash);

/* Flash region to be used for RAM(n) initialization data.*/
REGION_ALIAS("RAM_INIT_FLASH_LMA", flash);

/* RAM region to be used for Main stack. This stack accommodates the processing
   of all exceptions and interrupts.*/
REGION_ALIAS("MAIN_STACK_RAM", ram5);

/* RAM region to be used for the process stack. This is the stack used by
   the main() function.*/
REGION_ALIAS("PROCESS_STACK_RAM", ram5);

/* RAM region to be used for data segment.*/
REGION_ALIAS("DATA_RAM", ram0);
REGION_ALIAS("DATA_RAM_LMA", flash);

/* RAM region to be used for BSS segment.*/
REGION_ALIAS("BSS_RAM", ram0);

/* RAM region to be used for the default heap.*/
REGION_ALIAS("HEAP_RAM", ram0);


/* rules inclusion.*/
INCLUDE rules_stacks.ld

/*===========================================================================*/
/* Custom sections for STM32H7xx.                                            */
/* SRAM3 is assumed to be marked non-cacheable using MPU.                    */
/*===========================================================================*/

/* RAM region to be used for nocache segment.*/
REGION_ALIAS("NOCACHE_RAM", ram3);

/* RAM region to be used for eth segment.*/
REGION_ALIAS("ETH_RAM", ram3);

SECTIONS
{
    /* Special section for non cache-able areas.*/
    .nocache (NOLOAD) : ALIGN(4)
    {
        __nocache_base__ = .;
        *(.nocache)
        *(.nocache.*)
        *(.bss.__nocache_*)
        . = ALIGN(4);
        __nocache_end__ = .;
    } > NOCACHE_RAM

    /* Special section for Ethernet DMA non cache-able areas.*/
    .eth (NOLOAD) : ALIGN(4)
    {
        __eth_base__ = .;
        *(.eth)
        *(.eth.*)
        *(.bss.__eth_*)
        . = ALIGN(4);
        __eth_end__ = .;
    } > ETH_RAM
}

/* Code rules inclusion.*/
INCLUDE rules_code.ld

/* Data rules inclusion.*/
INCLUDE rules_data.ld

/* Memory rules inclusion.*/
INCLUDE rules_memory.ld
