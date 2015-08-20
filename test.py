import unittest
import glob
import subprocess
import shlex

class GenericPackerTestCase(unittest.TestCase):
    def __init__(self, methodName, cmdline=None, batsfile=None):
        super(GenericPackerTestCase, self).__init__(methodName)

        self.cmdline = cmdline
        self.batsfile = batsfile

    def runTest(self):
        subprocess.check_call(["packer", "build", "-var", "grml_test=%s" % self.batsfile, "-var", "grml_cmdline=%s" % self.cmdline, "grml.json"])


def load_tests(loader, tests, pattern):
    bats_files = glob.glob('*.bats')
    test_cases = unittest.TestSuite()
    for f in bats_files:
        cmdline = None
        with open(f) as bats_file:
            lexer = shlex.shlex(bats_file, posix=True)
            for token in lexer:
                if token == 'cmdline':
                    next_token = lexer.get_token()
                    if next_token == '=':
                        value = lexer.get_token()
                        cmdline = value
        if cmdline:
            test_cases.addTest(GenericPackerTestCase('runTest', cmdline, f))
    return test_cases

if __name__ == '__main__':
    unittest.main()
