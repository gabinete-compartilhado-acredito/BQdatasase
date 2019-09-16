# BigQuery database structure

This is a repository for the views' queries and scheduled queries (and, in the future, saved queries) stored
in Google Cloud BigQuery service used by the Gabinete compartilhado do Movimento
[Acredito](https://www.movimentoacredito.org/) no congresso nacional, along with a listing of all present
tables and their relationships. It serves as a guide for other projects on how to process the data stored
here, as a data organization schema and as a historical backup.

## 1. Structure of the project

    .
    ├── LICENSE             <- This project's license
    ├── README.md           <- This document, with information about the project
    ├── list_of_tables.txt  <- A list of all tables in BigQuery, under each dataset, along with their type
    ├── flowcharts          <- A folder with flowcharts of table dependencies (for views and scheduled queries)
    ├── scheduled_queries   <- A folder with backup of active scheduled queries
    ├── views               <- A folder with backup of views
    └── notes.txt           <- A few notes on debugging and working with BigQuery

## 2. Basic information

Most of the data present in BigQuery were captured with the system described in the
[capturaAWS](https://github.com/gabinete-compartilhado-acredito/capturaAWS) repository
and stored in Google Storage as JSON files. The flowcharts in `flowcharts` folder were
created by the code in the [bigQuery_mapper](https://github.com/hsxavier/bigQuery_mapper)
repository, by [Henrique Xavier](https://github.com/hsxavier).

## 3. To do list

* A backup, in a separate folder, of disabled scheduled queries;
* A folder with backup of saved queries;
* Flowcharts for individual tables, both for parent and for child dependencies.

## 4. Afterword

### Authors

The queries stored here were written by:

* Henrique S. Xavier - [@hsxavier](https://github.com/hsxavier)
* João Carabetta     - [@JoaoCarabetta](https://github.com/JoaoCarabetta)

### License

This project is distributed under the MIT license - see the [LICENSE](LICENSE) file for more details.

### Acknowledgments

This README was based on: [*A template to make good README.md*](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
