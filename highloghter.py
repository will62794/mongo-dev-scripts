#!/bin/python

import sys
import termcolor
import time
import argparse




test_title_color= 'yellow'

def colorize_line(line, test_name):
    if "going to run test" in line:
        col = test_title_color
        # if args.test_name in line:
            # col  = "green"
        testtitle = "\n\n\n[TEST RUN, %s]\n" % time.strftime('%l:%M:%S %p')
        return testtitle+termcolor.colored(line, col)
    elif "DONE running tests" in line:
        return "\n"+termcolor.colored(line, 'green')
    else:
        return line

# parser = argparse.ArgumentParser()
# parser.add_argument("test_name")
# args = parser.parse_args()

for line in sys.stdin:
    print colorize_line(line, None),
