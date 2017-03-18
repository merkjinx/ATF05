import sys
import os
import getopt
import thread
import threading
import subprocess

#Host ID FORMAT "Host:Ports(Port Port Port):connections" > export to log eventually

whitelistunpared = ''
blacklistunpared = ''

whitelist = []
blacklist = []

listenerthread = []

notifications = 0




def listener_menu():
    #Going to add more here
    print "Booted into listener"
def proccess_results(input):
    lol = "lol asdf"
    command = 'echo "%s" | grep -e tcp -e udp | cut -c 22-70' % lol
    print command
    #output = subprocess.check_output(['echo lol asdf | grep -e tcp -e udp | cut -c 22-70'])
    output = os.system('echo lol asdf | grep -e tcp -e udp | cut -c 22-70')
    return output
def listen(som,sun):
    result = subprocess.check_output(['netstat', '-an'])
    print proccess_results(result)


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
