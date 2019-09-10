#!/usr/bin/env python 

from subprocess import check_output
import json
import requests

# Hard-coded stuff:
project_id = 'gabinete-compartilhado'
domain     = 'https://bigquerydatatransfer.googleapis.com'

# Get access token:
token = check_output(['gcloud', 'auth', 'print-access-token']).decode('utf-8')[:-1]

# Make HTTP GET of scheduled queries:
session = requests.Session()
session.mount(domain, requests.adapters.HTTPAdapter(max_retries=3))
url = domain + '/v1/projects/' + project_id + '/transferConfigs?dataSourceIds=scheduled_query' 
response = session.get(url, headers={'Authorization': 'Bearer ' + token})

# Get list of scheduled queries:
sched_raw  = json.loads(response.content)
sched_list = sched_raw['transferConfigs']

for s in sched_list:

    # Get query name and destination table name:
    filename           = '../scheduled_queries/' + s['displayName'] + '.sql'
    destination_header = '# destination_table: ' + s['destinationDatasetId'] + '.' + \
                         s['params']['destination_table_name_template']
    # Save it to file:
    with open(filename, 'w') as f:
        f.write(destination_header + '\n\n')
        f.write(s['params']['query'])
