#!/usr/bin/env python

import http.server as SimpleHTTPServer
import argparse
from RangeHTTPServer import RangeRequestHandler

def main():
    parser = argparse.ArgumentParser(description='Serve local directory (support range requests).')
    parser.add_argument('port', nargs='?', type=int, default=8181)
    options=parser.parse_args()
    SimpleHTTPServer.test(port=options.port, HandlerClass=RangeRequestHandler)

if __name__ == "__main__":
    main()
