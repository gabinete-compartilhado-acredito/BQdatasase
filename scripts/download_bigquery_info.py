import os
import json
from google.cloud import bigquery

def list_tables(config):

    # Load config from file:
    if type(config) == str:
        with open(config, 'r') as f:
            config = json.load(f)    
    
    # Set path to BigQuery credentials:
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = config['credentials']

    client = bigquery.Client()

    # Get list of datasets:
    datasets = list(client.list_datasets())

    table_list = []
    for dataset in datasets:
        # Print dataset name:
        if config['printout']:
            print('{:40}   {}'.format(dataset.dataset_id, '----------'))

        # Get list of tables in the dataset:
        tables = list(client.list_tables(dataset.dataset_id))
        for table in tables:

            # Print table name and type:
            if config['printout']:
                print('  {:40} ({})'.format(table.table_id, table.table_type))

            # Include table (name and type) in list:
            table_list.append({'name': dataset.dataset_id + '.' + table.table_id, 'type': table.table_type})

            if table.table_type == 'VIEW' and config['get_views']:
                # If its a view, save its query to file:
                full_name = table.full_table_id.replace(':','.')
                filename  = table.full_table_id.split(':')[-1]
                objTable  = client.get_table(full_name)
                query     = objTable.view_query
                with open(config['views_path'] + filename + '.sql','w') as f:
                    f.write(query)

        if config['printout']:
            print('')

    # Return list of dicts with table names and types: 
    return table_list
