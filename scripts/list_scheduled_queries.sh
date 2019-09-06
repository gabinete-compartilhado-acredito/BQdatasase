#!/bin/bash
# This script gets all information about scheduled queries in Google BigQuery and prints a JSON
# to stdout.

# Parameters:
projectId=gabinete-compartilhado

# Get authentication token:
authToken="$(gcloud auth print-access-token)"

# API call:
scheduled_queries=$(curl  -H "Authorization: Bearer $authToken" \
https://bigquerydatatransfer.googleapis.com/v1/projects/$projectId/transferConfigs?dataSourceIds=scheduled_query)
# For other data locations rather than US or EU, check:
# https://stackoverflow.com/questions/55745763/list-scheduled-queries-in-bigquery

# Pretty print results:
echo $scheduled_queries | python -m json.tool
