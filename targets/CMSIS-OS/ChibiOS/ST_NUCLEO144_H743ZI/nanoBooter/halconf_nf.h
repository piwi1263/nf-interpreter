//
// Copyright (c) 2019 The nanoFramework project contributors
// See LICENSE file in the project root for full license information.
//

#ifndef _HALCONF_NF_H_
#define _HALCONF_NF_H_

// enables STM32 Flash driver
#if !defined(HAL_NF_USE_STM32_FLASH) 
#define HAL_NF_USE_STM32_FLASH TRUE
#endif

// disable CRC in nf overlay for the moment
#define HAL_NF_USE_STM32_CRC FALSE

#endif // _HALCONF_NF_H_
