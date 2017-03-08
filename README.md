## Application Requirements
Create a single route, unauthenticated web service in Node.js or Python to return a JSON array of app gallery listings created or updated on/after a specified date. The user should be able to pass in the target date as a querystring parameter (or no date to retrieve all listings in the db). The data and schema are in the attached Postgres SQL dump and the “updated_at” date is in the applications table. All of the tables will need to be joined to generate the full response and only applications with a status of “published” in the listings table should be returned. Bonus points for implementing paging, ip based throttling and other standard API features as time allows. Functionality that is designed but not implemented can be indicated through failing unit tests or placeholder comments in the code.

## Additional Features Needed
* Database query throttling - store result, don't re-query db if too soon
* IP address logging and throttling
* Paging of results (only return first X to start).
 * page parameter in URL. If missing, then get first page automatically
 * Response should indicate page X of Y or nextrecords. Something like page?limit=5&start=10


## How to setup and run applciationSetup
### PostgreSQL
pg_dump file doesn't create database:

    psql -U postgres
    CREATE DATABASE gallery;

Next import tables and data:

    psql -U postgres gallery < gallery.sql

#### If using Docker official PostgreSQL image
In a Docker image, by default no changes are saved, so data volume should be mapped to a local directory. In order to do that, set volume location.

Additionally, in order to have the administrative password be something you know, you should set the POSTGRES_PASSWORD environment variable.


### Create Python Virtual Environment

    conda create --name smart python=3.5
    source activate smart
    conda list --export
