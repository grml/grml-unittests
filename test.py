import unittest
import glob
import subprocess
import shlex

class GenericPackerTestCase(unittest.TestCase):
    def __init__(self, methodName, grml_vars=None):
        super(GenericPackerTestCase, self).__init__(methodName)

        self.grml_vars = grml_vars

    def runTest(self):
        cmd = ["packer", "build"]
        for v in self.grml_vars:
            cmd += ["-var", "%s=%s" % (v, self.grml_vars[v])]
        cmd += ["grml.json"]
        subprocess.check_call(cmd)


def load_tests(loader, tests, pattern):
    bats_files = glob.glob('*.bats')
    test_cases = unittest.TestSuite()
    for f in bats_files:
        grml_vars = {'grml_test': f}
        with open(f) as bats_file:
            lexer = shlex.shlex(bats_file, posix=True)
            for token in lexer:
                if token.startswith('grml_'):
                    next_token = lexer.get_token()
                    if next_token == '=':
                        value = lexer.get_token()
                        grml_vars[token] = value
        if 'grml_cmdline' in grml_vars:
            test_cases.addTest(GenericPackerTestCase('runTest', grml_vars))
    return test_cases

if __name__ == '__main__':
    unittest.main()
