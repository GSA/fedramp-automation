#!/usr/bin/env python3

import argparse
import sys
import xml.etree.ElementTree as ET


def assert_svrl(svrl_string):
    root = ET.fromstring(svrl_string)
    failed_asserts = root.findall('{http://purl.oclc.org/dsdl/svrl}failed-assert')
    for failed_assert in failed_asserts:
        text = failed_assert.find('{http://purl.oclc.org/dsdl/svrl}text').text
        diagnostic = failed_assert.find('{http://purl.oclc.org/dsdl/svrl}diagnostic-reference').text
        location = failed_assert.get('location')
        print(f"""* failed-assert at {location}
    {text}
    {diagnostic}
        """)
    print(f'Found {len(failed_asserts)} failed assertions')
    return len(failed_asserts)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog='assert_svrl')
    parser.add_argument('file_name')
    arguments = parser.parse_args(sys.argv[1:])
    with open(arguments.file_name, 'r') as f:
        svrl_string = f.read()
        assertion_count = assert_svrl(svrl_string)
        sys.exit(assertion_count)
