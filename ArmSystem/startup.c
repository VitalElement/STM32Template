/******************************************************************************
*       Description:
*
*       Author:
*         Date: January 2015
*
*******************************************************************************/
#pragma mark Compiler Pragmas


#pragma mark Includes
#include "startup.h"
#include <string.h>


#pragma mark Definitions and Constants
typedef void (*func_ptr) (void);

extern func_ptr __init_array_start[0], __init_array_end[0];
extern func_ptr __fini_array_start[0], __fini_array_end[0];

extern unsigned long _sidata;
extern unsigned long _sdata;
extern unsigned long _edata;
extern unsigned long _sbss;
extern unsigned long _ebss;

#pragma mark Static Data


#pragma mark Static Functions

#pragma mark Function Implementations
void system_startup (void)
{
    uint32_t* source = (uint32_t*)&_sidata;
    uint32_t* destination;

    for (destination = (uint32_t*)&_sdata; destination < (uint32_t*)&_edata;)
    {
        *(destination++) = *(source++);
    }

    for (destination = (uint32_t*)&_sbss; destination < (uint32_t*)&_ebss;)
    {
        *(destination++) = 0;
    }
}

void system_init (void)
{
    // Call C++ static constructors.
    func_ptr* func;

    for (func = __init_array_start; func != __init_array_end; func++)
    {
        (*func) ();
    }
}

void system_cleanup (void)
{
    func_ptr* func;

    for (func = __fini_array_start; func != __fini_array_end; func++)
    {
        (*func) ();
    }
}
