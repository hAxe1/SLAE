; Filename: SLAEpolyBeep.nasm
; Author:  Billy (@_hAxel)
; Website:  https://www.haxel.io
;
; Student ID:  PA-7462
; Purpose: SLAE Assignmnet 6.2 - Polymorphed version of Sytem Beep shellcode, Original found here: http://shell-storm.org/shellcode/files/shellcode-60.php

global _start			

section .text
_start:

	   			;     int fd = open("/dev/tty10", O_RDONLY);
	xor eax, eax        	; Replaces push pop from original to xor then move       
	push eax            
	cdq                 	; Was going to replace this with an xor for EDX, but trying to shorten overall shellcode length
	mov al, 0x05        	; Replaces push pop from original with move to AL
 	push 0x30317974
   	push 0x742f2f2f
  	push 0x7665642f
   	mov ebx, esp
   	mov ecx, edx
   	int 80h

   				;     ioctl(fd, KDMKTONE (19248), 66729180);
   	mov ebx, eax
  	xor eax, eax      	; Replaces push pop from original to xor then move  
	mov al, 54          	; Replaces push pop from original with move al
  	mov cx, 0x4b30    	; Replaced move to ECX then NOT value with just a move to CX
   	mov edx, 66729180
   	int 80h
	mov al, 0x01        	; System Exit wasn't in original code, but code would segfault after inital run, 
	int 0x80            	; counting these extra bytes in size comparison.
