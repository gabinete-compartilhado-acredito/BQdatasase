#!/usr/bin/env python

"""
Use an SQL query saved in <FILE> to create, in Google BigQuery, 
a view named <VIEW> inside the dataset <DATASET>.

USAGE:   create_view.py <DATASET> <VIEW> <FILE>
EXAMPLE: create_view.py testing_mess nomeacoes_exoneracoes ../queries_backup/nomeacoes_exoneracoes_ministerio_da_saude.sql

Written by: Henrique S. Xavier, hsxavier@gmail.com, 23-may-2020.
"""

import sys

# Docstring output:
if len(sys.argv) < 1 + 3: 
    print(__doc__)
    sys.exit(1)

from google.cloud import bigquery
import os


### Functions ###

def load_query_file(filename):
    """
    Load the content of the file `filename` to a string and return it.
    """
    with open(filename, 'r') as f:
        query = f.read()
    return query


def create_view(dataset, view_name, query, 
                credentials='/home/skems/gabinete/projetos/keys-configs/gabinete-compartilhado.json'):
    """
    Create or update view in bigquery.
    
    Input
    -----
    
    dataset : str
        Name of the dataset where the view should be saved.
        
    view_name : str
        Name o the view to be created.
        
    query : str
        Query constituting the view.
        
    credentials : str (default 'gabinete-compartilhado.json')
        Filename of the JSON file constaining GCP credentials.
    """
    
    # Start client:
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credentials
    client = bigquery.Client()
    
    # Create table/view object:
    dataset_ref = client.dataset(dataset)
    table_ref   = dataset_ref.table(view_name)
    view        = bigquery.Table(table_ref)
    # Set view properties:
    view.view_use_legacy_sql = False
    view.view_query = query

    table_list = [obj.table_id for obj in client.list_tables(dataset)]
    if view_name in table_list:
        client.delete_table(view)
        client.create_table(view, timeout=300)
    else:
        client.create_table(view, timeout=300)


### Main code ###

# Load input:
dataset    = sys.argv[1]
view_name  = sys.argv[2]
query_file = sys.argv[3]

print('Load query...')
query = load_query_file(query_file)
print('Create view...')
create_view(dataset, view_name, query)
