import sys
import os
import getopt
import thread
import threading
import subprocess
from subprocess import *
import base64

#Host ID FORMAT "Host:connections" > export to log eventually
#actual format : array['host:connections',etc]
#              :
#              :

whitelistunpared = ''
blacklistunpared = ''

whitelist = []
blacklist = []

listenerthread = []

notifications = 0

foreignaddr = []


def listener_menu():
    #Going to add more here
    print "Booted into listener"
def proccess_results(input):
    
    p = Popen(["grep -e tcp -e udp"], stdout=PIPE, stdin=PIPE, stderr=PIPE, shell=True)
    stdout_data = p.communicate(input=input)[0]
    p = Popen(["cut -c 22-70"], stdout=PIPE, stdin=PIPE, stderr=PIPE, shell=True)
    stdout_data = p.communicate(input=stdout_data)[0]
    p = Popen(["cut -c 1-42"], stdout=PIPE, stdin=PIPE, stderr=PIPE, shell=True)
    stdout_data = p.communicate(input=stdout_data)[0]
    
    
    foreignaddr = stdout_data.split()

    output=foreignaddr
    return output
def listen(som,sun):
    result = subprocess.check_output(['netstat', '-an'])
    proccess_results(result)


#print result.communicate()

#while 1:
#print "testties"
#return



def main(argv):
    global whitelist
    global blacklist
    opts, args = getopt.getopt(argv,"ha:b:n:n",["aa=","bb=","notice="])
    for opt, arg in opts:
        if opt == '-h':
            print 'listen.py -a <whitelist-array> -b <blacklist-array>'
            sys.exit()
        elif opt in ("-a", "--aa"):
            whitelistunpared = arg
        elif opt in ("-b", "--bb"):
            blacklistunpared = arg
        elif opt in ("-n", "--notice"):
            notifications = arg

        #print  "Whitelist:",whitelistunpared # Debug
        #print  "Blacklist:",blacklistunpared # Debug
    whitelist = whitelistunpared.split()
    blacklist = whitelistunpared.split()
    listener_menu()

    try:
        thread.start_new_thread(listen,(1,1))
    except:
        print "Unable to start listener thread"


    while 1:
        pass


if __name__ == "__main__":
    main(sys.argv[1:])
