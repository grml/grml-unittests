#!/usr/bin/env python
import sys
import select
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
return_value = 0
keep_running = True
message = None

class MyHandler(BaseHTTPRequestHandler):

    def stop(self, msg, retval):
        global keep_running
        global message
        global error
        keep_running=False
        message=msg
        return_value=retval
        return


    def do_POST(self):
        data = ""
        length = self.headers.getheader('content-length')
        try:
            nbytes = int(length)
        except (TypeError, ValueError):
            nbytes = 0
        if nbytes > 0:
            data = self.rfile.read(nbytes)
        while select.select([self.rfile._sock], [], [], 0)[0]:
            if not self.rfile._sock.recv(1):
                break

        if self.path.endswith("FAIL"):
            self.stop("FAILED - %s" % data, 1)
            return

        if self.path.endswith("DONE"):
            self.stop("OK - %s" % data, 0)
            return


    def do_GET(self):
        if self.path.endswith("FAIL"):
            self.stop("FAILED", 1)
            return

        if self.path.endswith("DONE"):
            self.stop("OK", 0)
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
        sys.exit(return_value)
    except KeyboardInterrupt:
        server.socket.close()

if __name__ == '__main__':
    main()
