/*
 * Start entry point by Human68K XFile.
 *
 * Communication between the kernel and program is done
 * by setting cpu registers as is :
 * a0 : MCB pointer
 * a1 : End of bss segment
 * a2 : Command line pointer
 * a3 : Environ variable pointer
 * a4 : Execution entry point address
 * a5 : Interrupt routine command number (driver only)
 *
 * Preprocessor variable used by this file :
 * HUPAIR : Support hupair argument vector
 * RFILE : Support for .r Relocatable file loading
 */

#include "config.h"

.extern __crt1_startup
.extern _exit

.global _start

_start:
	bra	_start_1
#ifdef SUPPORT_HUPAIR
	.string "#HUPAIR"
#endif
	.string	"X68000 LIBC"
	.string "crt0-"
#ifdef SUPPORT_HUPAIR
	.string "h"
#endif
	.string "x"

	.even

_start_1:
	move.l	%a0@(0x30), %a5
	move.l	%a1, %d0
	sub.l	%a5, %d0

clear_bss:
	clr.l	%a5@+
	dbra	%d0, clear_bss

| Save crt0 arguments
	move.l	%a0, _MCB		| MCB
	move.l	%a0, _memcp		| pointer version
	lea.l	%a0@(0x100), %a5
	move.l	%a5, _PSTA		| TEXT Start
	move.l	%a5, _psta		| pointer version
	move.l	%a0@(0x34), %d0
	move.l	%d0, _PEND		| TEXT End
	move.l	%d0, _DSTA		| DATA Start
	move.l	%a0@(0x30), %d0
	move.l	%d0, _DEND		| DATA End
	move.l	%d0, _BSTA		| BSS Start
	move.l	%d0, _bsta		| pointer version
	move.l	%a1, _BEND		| BSS End

	lea.l	%a0@(0x10), %a5
	move.l	%a5, _PSP
	move.l	%a5, _procp		| pointer version

| Setup environment
	move.l	%a3, _ENV0

| Setup command line
	move.l	%a2, _cmdline

| Setup stack
	move.l	%a1, _SSTA
	move.l	%a1, _ssta		| pointer version
	add.l	#STACK_SIZE, %a1
	move.l  #STACK_SIZE, _stacksize
	move.l	%a1, _SEND

	move.l	%a1, %sp
	
| Setup heap
	move.l	%a1, _HSTA		| HEAP Start
	move.l	%a1, _hsta		| pointer version
	add.l	#HEAP_SIZE, %a1
	move.l  #HEAP_SIZE, _heapsize
	move.l	%a1, _HEND		| HEAP End
	move.l	%a1, _last		| pointer version
	move.l	%a0@(0x08), _HMAX	| End block
	move.l	%a0@(0x08), _mmax	| pointer version

	lea.l	%a0@(0x10), %a5		| PSP

	sub.l	%a5, %a1
	move.l	%a1, %sp@-		| incr
	move.l	%a5, %sp@-		| ptr
	.short	0xFF4A			| setblock

	pea	%a0@			| MCB
	jmp	__crt1_startup		| Human initialization

	|
	| No return
	|

|
| Variables
|

	.comm	_MCB, 4
	.comm	_memcp, 4		| pointer version
	.comm	_PSP, 4
	.comm	_procp, 4		| pointer version

	.comm	_PSTA, 4
	.comm	_psta, 4		| pointer version
	.comm	_PEND, 4
	.comm	_DSTA, 4
	.comm	_DEND, 4
	.comm	_BSTA, 4
	.comm	_bsta, 4		| pointer version
	.comm	_BEND, 4
	.comm	_SSTA, 4
	.comm	_ssta, 4		| pointer version
	.comm	_stacksize, 4
	
	
	.comm	_SEND, 4
	.comm	_HSTA, 4
	.comm	_hsta, 4		| pointer version
	.comm	_HEND, 4
	.comm	_last, 4		| pointer version
	.comm	_heapsize, 4
	
	
	.comm	_HMAX, 4
	.comm	_mmax, 4		| pointer version

	.comm	_ENV0, 4

	.comm	_cmdline, 4

