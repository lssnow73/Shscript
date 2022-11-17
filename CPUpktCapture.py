#!/usr/bin/python

import sys
import json, urllib2
import time
import ssl, base64

def sendRpcCmd(data):
    url = "https://127.0.0.1:10444/api/cmd_api/"
    username = "admin"
    password = "admin"

    request = urllib2.Request(url, data, {'Content-Type': 'application/json'})
    b64auth = base64.standard_b64encode("%s:%s" % (username, password))
    request.add_header("Authorization", "Basic %s" % b64auth)

    try:
        response = urllib2.urlopen(request, context=ssl._create_unverified_context())
        print(response.read())
    except Exception as e:
        print(e)
        print("ERROR: Failed to send cmd\n")


def cpuMonitorCmd(cmd):

    monitorCmds = {
        'stop': '{ \
            "params": [ \
                { \
                    "format": "json", \
                    "version": 1, \
                    "cmds": ["monitor cpu capture packet stop"] \
                } \
            ] \
        }',
        'start': '{ \
            "params": [ \
                { \
                    "format": "json", \
                    "version": 1, \
                    "cmds": ["monitor cpu capture packet start"] \
                } \
            ] \
        }',
        'clear': '{ \
            "params": [ \
                { \
                    "format": "json", \
                    "version": 1, \
                    "cmds": ["clear monitor cpu packet all"] \
                } \
            ] \
        }',
        'cd': '{ \
            "params": [ \
                { \
                    "format": "json", \
                    "version": 1, \
                    "cmds": ["cd flash:"] \
                } \
            ] \
        }'
    }
    sendRpcCmd(monitorCmds.get(cmd, "Not supported command"))

permitCmds=['stop', 'start', 'clear', 'cd']

if __name__ == '__main__':
    numOfargs = len(sys.argv)
    print 'Number of arguments: ', numOfargs, 'arguments.'
    print 'Argument List:', str(sys.argv)

    if numOfargs != 2:
        cmd = 'clear'
    else:
        if sys.argv[1] in permitCmds:
            cmd = sys.argv[1]
        else:
            cmd = 'clear'

    print "{}".format(cmd)

    cpuMonitorCmd(cmd)
    exit(0)
