#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Created on Mon Jul 15 15:08:46 2019

@author: skems
"""

import os
from google.cloud import bigquery

# Maybe the line below is required:
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/home/skems/gabinete/projetos/keys-configs/gabinete-compartilhado.json'

client = bigquery.Client()

# Get list of datasets:
datasets = list(client.list_datasets())

for dataset in datasets:
    # Print dataset name
    print('{:40}   {}'.format(dataset.dataset_id, '----------'))

    # Get list of tables in the dataset:
    tables = list(client.list_tables(dataset.dataset_id))
    for table in tables:
        # Print table name and type:
        print('  {:40} ({})'.format(table.table_id, table.table_type))
        
        if table.table_type == 'VIEW':
            # If its a view, save its query to file:
            full_name = table.full_table_id.replace(':','.')
            filename  = table.full_table_id.split(':')[-1]
            objTable  = client.get_table(full_name)
            query     = objTable.view_query
            with open('../views/'+filename+'.sql','w') as f:
                f.write(query)
            
    print('')
