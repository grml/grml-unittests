#!/usr/bin/env python
import sys
from os import curdir, sep
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
from optparse import OptionParser


USAGE = "Usage: %prog [options] "
parser = OptionParser(usage=USAGE)
parser.add_option("-p", "--port", dest="port",
                  help="http server port", default="8080")
parser.add_option("-t", "--test", dest="test_name",
                  help="test name", metavar="NAME")


# ugly ;0
options = None
error = 0
keep_running = True
message = None

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        global keep_running
        global message
        global error
        if self.path.endswith("FAIL"):
            self.send_error(404, 'Failed')
            keep_running = False
            error = 1
            message = "FAILED"
            return

        if self.path.endswith("DONE"):
            self.send_error(404, 'done')
            error = 0
            keep_running = False
            message = "OK"
            return
        try:
                f = open(curdir + sep + self.path)
                self.send_response(200)
                self.end_headers()
                self.wfile.write(f.read())
                f.close()
                return
        except IOError:
            self.send_error(404,'File Not Found: %s' % self.path)
    def log_message(self, *args):
        pass
    def log_error(self, *args):
        pass


def main():
    global options
    (options, args) = parser.parse_args()
    if not options.test_name:
        parser.error("Define test name")
        sys.exit(1)

    try:
        server = HTTPServer(('', int(options.port)), MyHandler)
        while keep_running:
            server.handle_request()
        sys.stderr.write("%s: %s\n" % (options.test_name, message))
        sys.exit(error)
    except KeyboardInterrupt:
        server.socket.close()

if __name__ == '__main__':
    main()
