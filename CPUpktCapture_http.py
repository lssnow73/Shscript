#!/usr/bin/python

import sys
import json, urllib2
import time

def sendRpcCmd(data):
    url = "http://127.0.0.1/api/cmd_api/"
    request = urllib2.Request(url, data, {'Content-Type': 'application/json'})
    try:
        response = urllib2.urlopen(request)
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

permitCmds=['stop', 'start', 'show', 'cd']

if __name__ == '__main__':
    numOfargs = len(sys.argv)
    print 'Number of arguments: ', numOfargs, 'arguments.'
    print 'Argument List:', str(sys.argv)

    if numOfargs != 2:
        cmd = 'show'
    else:
        if sys.argv[1] in permitCmds:
            cmd = sys.argv[1]
        else:
            cmd = 'show'

    print "{}".format(cmd)

    cpuMonitorCmd(cmd)
    exit(0)

