; Filename: SLAEexecveBinSh.nasm
; Author:  Billy (@_hAxel)
; Website:  https://www.haxel.io
;
;
; Purpose: 

global _start			

section .text
_start:

    xor eax, eax
    push eax
    push 0x68732f2f
    push 0x6e69622f
    mov ebx, esp
    push eax
    push eax
    push ebx
    mov ecx, esp
    mov al, 11
    int 0x80
