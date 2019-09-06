#!/usr/bin/env python 

from subprocess import check_output
import json

# Use shell script to get scheduled queries:
json_string = check_output(['./list_scheduled_queries.sh'])
sched_raw   = json.loads(json_string)
sched_list  = sched_raw['transferConfigs']

for s in sched_list:

    # Get query name and destination table name:
    filename           = '../scheduled_queries/' + s['displayName'] + '.sql'
    destination_header = '# destination_table: ' + s['destinationDatasetId'] + '.' + \
                         s['params']['destination_table_name_template']
    # Save it to file:
    with open(filename, 'w') as f:
        f.write(destination_header + '\n\n')
        f.write(s['params']['query'])
