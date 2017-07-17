/**
 *        Vital Element Studios - LinkerScript
 *
 **/
 
OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08010000, LENGTH = 512K
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 192K
}

ENTRY(Reset_Handler)

SECTIONS
{
    /* Reset and ISR vectors */
    .interrupt_vector :
    {
        __isr_vector_start__ = .;
        KEEP(*(.interrupt_vector)) /* without 'KEEP' the garbage collector discards this section */
        ASSERT(. != __isr_vector_start__, "The .interrupt_vector section is empty");
    } >FLASH    
    
    /* Text section (code and read-only data) */
    .text :
    {
       *(.text .text.* .gnu.linkonce.t.*)
        *(.rodata .rodata.* .gnu.linkonce.r.*)

        *(.eh_frame_hdr)
        *(.eh_frame)
        *(.gcc_except_table)
        *(.eh_frame_hdr)
        *(.eh_frame)

        . = ALIGN(4);
        KEEP(*(.init))

        . = ALIGN(4);
        __preinit_array_start = .;
        KEEP (*(.preinit_array))
        __preinit_array_end = .;

        . = ALIGN(4);
        __init_array_start = .;
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array))
        __init_array_end = .;

        . = ALIGN(0x4);
        KEEP (*crtbegin.o(.ctors))
        KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
        KEEP (*(SORT(.ctors.*)))
        KEEP (*crtend.o(.ctors))

        . = ALIGN(4);
        KEEP(*(.fini))

        . = ALIGN(4);
        __fini_array_start = .;
        KEEP (*(.fini_array))
        KEEP (*(SORT(.fini_array.*)))
        __fini_array_end = .;

        KEEP (*crtbegin.o(.dtors))
        KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
        KEEP (*(SORT(.dtors.*)))
        KEEP (*crtend.o(.dtors))
        
        _etext = .;
        _sidata = .;
    } > FLASH
    
    /*
     * Initialized data section. This section is programmed into FLASH (LMA
     * address) and copied to RAM (VMA address) in startup code.
     */
    .data : 
    {
        _sdata = .; /* data section VMA address */
        *(vtable)
        *(.data .data.* .gnu.linkonce.d.*)
        . = ALIGN(4);
        _edata = .;
    } >RAM AT >FLASH
    
    /* Uninitialized data section (zeroed out by startup code) */
    .bss : AT(_edata)
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } >RAM   
    
    .noinit (NOLOAD) : AT (_ebss)
    {
        . = ALIGN(4);
        *(.noinit)
        . = ALIGN(4);
    } > RAM
}

/* end of allocated ram _end */
PROVIDE( _HEAP_START = _ebss );

/* end of the heap -> align 8 byte */ 
PROVIDE ( _HEAP_END = ALIGN(ORIGIN(RAM) + LENGTH(RAM) ,8) );
