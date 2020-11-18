//
// Copyright (c) 2019 The nanoFramework project contributors
// See LICENSE file in the project root for full license information.
//

#include <nanoHAL_Types.h>
#include <nanoPAL_BlockStorage.h>

// 128kB block
const BlockRange BlockRange1[] = 
{
    { BlockRange_BLOCKTYPE_BOOTSTRAP ,   0, 0 },            // 0x08000000 nanoBooter          
};

//128kB block
const BlockRange BlockRange2[] = 
{
    ///////////////////////////////////////////////////////////////////////////////////////
    // because this target is using a configuration block need to add the
    // configuration manager files to the CMake and call ConfigurationManager_Initialize()
    // in nanoBooter so the configuration can be managed when in booter mode
    ///////////////////////////////////////////////////////////////////////////////////////
    { BlockRange_BLOCKTYPE_CONFIG    ,   0, 0 }             // 0x08020000 configuration block          
    ///////////////////////////////////////////////////////////////////////////////////////
};

// 128kB blocks
const BlockRange BlockRange3[] =
{
    { BlockRange_BLOCKTYPE_CODE      ,   0, 2 }             // 0x08040000 nanoCLR  
};

// 128kB blocks
const BlockRange BlockRange4[] =
{
    { BlockRange_BLOCKTYPE_DEPLOYMENT,   0, 2 }             // 0x080A0000 deployment  
};

const BlockRegionInfo BlockRegions[] = 
{
    {
        (0),                                // no attributes for this region
        0x08000000,                         // start address for block region
        1,                                  // total number of blocks in this region
        0x20000,                            // total number of bytes per block
        ARRAYSIZE_CONST_EXPR(BlockRange1),
        BlockRange1,
    },

    {
        (0),                                // no attributes for this region
        0x08020000,                         // start address for block region
        1,                                  // total number of blocks in this region
        0x20000,                            // total number of bytes per block
        ARRAYSIZE_CONST_EXPR(BlockRange2),
        BlockRange2,
    },

    {
        (0),                                // no attributes for this region
        0x08040000,                         // start address for block region
        3,                                  // total number of blocks in this region
        0x20000,                            // total number of bytes per block
        ARRAYSIZE_CONST_EXPR(BlockRange3),
        BlockRange3,
    },

    {
        (0),                                // no attributes for this region
        0x080A0000,                         // start address for block region
        3,                                  // total number of blocks in this region
        0x20000,                            // total number of bytes per block
        ARRAYSIZE_CONST_EXPR(BlockRange4),
        BlockRange4,
    },
};

const DeviceBlockInfo Device_BlockInfo =
{
    (MediaAttribute_SupportsXIP),
    2,                                      // UINT32 BytesPerSector
    ARRAYSIZE_CONST_EXPR(BlockRegions),     // UINT32 NumRegions;
    (BlockRegionInfo*)BlockRegions,         // const BlockRegionInfo* pRegions;
};

MEMORY_MAPPED_NOR_BLOCK_CONFIG Device_BlockStorageConfig =
{
    { // BLOCK_CONFIG
        {
            0,          // GPIO_PIN             Pin;
            false,      // BOOL                 ActiveState;
        },

        (DeviceBlockInfo*)&Device_BlockInfo,    // BlockDeviceinfo
    },

    { // CPU_MEMORY_CONFIG
        0,                          // UINT8  CPU_MEMORY_CONFIG::ChipSelect;
        true,                       // UINT8  CPU_MEMORY_CONFIG::ReadOnly;
        0,                          // UINT32 CPU_MEMORY_CONFIG::WaitStates;
        0,                          // UINT32 CPU_MEMORY_CONFIG::ReleaseCounts;
        16,                         // UINT32 CPU_MEMORY_CONFIG::BitWidth;
        0x08000000,                 // UINT32 CPU_MEMORY_CONFIG::BaseAddress;
        0x00100000,                 // UINT32 CPU_MEMORY_CONFIG::SizeInBytes;
        0,                          // UINT8  CPU_MEMORY_CONFIG::XREADYEnable 
        0,                          // UINT8  CPU_MEMORY_CONFIG::ByteSignalsForRead 
        0,                          // UINT8  CPU_MEMORY_CONFIG::ExternalBufferEnable
    },

    0,                              // UINT32 ChipProtection;
    0,                              // UINT32 ManufacturerCode;
    0,                              // UINT32 DeviceCode;
};

BlockStorageDevice    Device_BlockStorage;
