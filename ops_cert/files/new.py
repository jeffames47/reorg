import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from datetime import datetime
import json
import sys

def the_big_function():
    maF5 = {
      'baseUrl': 'https://ma-bigip-01.navihealth.local',
      'username': 'svc_devops',
      'password': 'j}mb@{<74mhm<ATk',
      'resultFile': 'ma-bigip-result.json'
    }
    vaF5 = {
      'baseUrl': 'https://va-bigip-03.curaspan.local',
      'username': 'svc_devops',
      'password': 'j}mb@{<74mhm<ATk',
      'resultFile': 'va-bigip-result.json'
    }
    f5 = (maF5, vaF5)[len(sys.argv) > 1 and sys.argv[1] == 'prod' ]

    # print start time
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    print("Start Time =", current_time)

    # suppress ssl warning
    requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

    # get a list of f5 pool
    resp = requests.get(f5['baseUrl'] + '/mgmt/tm/ltm/pool/', auth=(f5['username'], f5['password']), verify=False)
    failedPool = []
    allPool = {}

    if resp.status_code != 200:
        raise Error('cannot get all pools')
    for pool in resp.json()['items']:
    # loop through each pool and get members
    url = pool['membersReference']['link'].replace('https://localhost', f5['baseUrl'])
    poolResp = requests.get(url, auth=(f5['username'], f5['password']), verify=False)
    if resp.status_code != 200:
        failedPool.append(pool['name'])
    else:
        for member in poolResp.json()['items']:
        memberData = {'nodeName': member['name'], 'nodePort': member['fullPath'].split(':')[1], 'nodeAddress': member['address'], 'poolName': pool['name'], 'partition': pool['partition']}
        if member['address'] in allPool:
            allPool[member['address']].append(memberData)
        else:
            allPool.update({member['address']: [memberData]})


    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    print("End Time =", current_time)

    return json.dump(allPool, fp)

#    with open(f5['resultFile'],'w') as fp:
#    json.dump(allPool, fp)
#
#    print('----------Failed Pool--------------')
#    print(failedPool)

def application(environ, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [the_big_function()]
