import sys
import getopt






def main(argv):
    whitelistunpared = ''
    blacklistunpared = ''
    opts, args = getopt.getopt(argv,"ha:b:",["ifile=","ofile="])
    for opt, arg in opts:
        if opt == '-h':
            print 'test.py -a <whitelist-array> -b <blacklist-array>'
            sys.exit()
        elif opt in ("-a", "--aa"):
            whitelistunpared = arg
        elif opt in ("-b", "--bb"):
            blacklistunpared = arg
#        print  "Whitelist:",whitelistunpared # Debug
#        print  "Blacklist:",blacklistunpared # Debug

if __name__ == "__main__":
    main(sys.argv[1:])
