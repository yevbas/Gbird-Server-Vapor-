import os
import sys

inFile = sys.argv[1]

with open(inFile, 'r') as inputFile:
	for line in inputFile:
		print(line)

