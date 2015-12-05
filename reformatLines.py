#!/usr/bin/python
# -*- coding: utf-8 -*-
# Takes text as input and outputs that text reformated so that no line is more
# than 79 characters wide, breaking only at spaces.
import sys

def main(filename):
    f = open(filename, 'r')
    output = ""

    for line in f.readlines():
        position = 0
        if (len(line) > 80):
            words = line.split(' ')
            for word in words:
                if (position + len(word) + 1) < 80:
                    output += word + ' '
                    position += len(word) + 1
                else:
                    output += '\n'+ word + ' '
                    position = len(word)
        else:
            output += line
            
    print output
                        
                        
if __name__ == "__main__":
    main(sys.argv[1])

