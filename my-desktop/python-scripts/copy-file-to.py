import os
import sys

inputFileName = sys.argv[1]
outputFileName = sys.argv[2]

i = open(inputFileName, 'r')
o = open(outputFileName, 'w')

o.write(i.read())
