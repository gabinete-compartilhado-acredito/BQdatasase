# This script gets a BigQuery jobID as input and return the error messages associated to it.
# (check the Job ID in the Job Information tab in the Query results in the BG UI).

# Informações sobre como debugar dados do Storage no BigQuery:
# https://snowplowanalytics.com/blog/2018/12/19/debugging-bad-data-in-gcp-with-bigquery/

jobid=$1

#conda activate base
bq --format=prettyjson show -j $jobid
#conda activate python3
