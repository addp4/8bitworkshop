#!/usr/bin/python3


def main():
    with open("mario.rgb", mode='rb') as infile:
        v = infile.read()
        assert len(v) == 320*200*3
        for n in range(len(v)):
            print("%02x" % v[n])


main()
