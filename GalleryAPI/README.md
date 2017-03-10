## Application Requirements
Create a single route, unauthenticated web service in Node.js or Python to return a JSON array of app gallery listings created or updated on/after a specified date. The user should be able to pass in the target date as a querystring parameter (or no date to retrieve all listings in the db). The data and schema are in the Postgres SQL dump file and the “updated_at” date is in the applications table. All of the tables will need to be joined to generate the full response and only applications with a status of “published” in the listings table should be returned. Bonus points for implementing paging, ip based throttling and other standard API features as time allows. Functionality that is designed but not implemented can be indicated through failing unit tests or placeholder comments in the code.

**Specifically, this means:**
1. No authentication required web service
1. Target date passed in as a query string parameter
1. No date returns all results
1. Only applications with a status of “published” in the listings table should be returned

**Assumptions Made:**
1. Incorrect URL parameters names will result in an error
1. Results are in descending order by updated_at
1. Invalid dates are treated as if no date passed.

## Additional Features Needed
* Database query throttling - store result, don't re-query db if too soon
* IP address logging and throttling
* Paging of results (only return first X to start).
 * page parameter in URL. If missing, then get first page automatically
 * Response should indicate page X of Y or nextrecords. Something like page?limit=5&start=10

## How to setup and run applciation
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

### To run application and unittests

By default application runs on port 5000 and binds to all IP addresses on current host.

    python app_gallery.py

To run unit tests

    python app_gallery_tests.py


## Developer notes
Since I'm using SQLAlchemy automap to generate classes from database introspection, it appears that:
1. I cannot use Flask's paginate() function. http://stackoverflow.com/questions/18468887/flask-sqlalchemy-pagination-error
1. Can't seem to get table relationships to work automatically. Possibly could override automapped class, but found a decent solution.
 * http://stackoverflow.com/questions/22019567/how-to-get-flask-sqlalchemy-object-to-load-relationship-children-for-jinja-templ
 * http://stackoverflow.com/questions/12698766/how-to-load-nested-relationships-in-sqlalchemy
 * http://docs.sqlalchemy.org/en/latest/orm/loading_relationships.html#sqlalchemy.orm.subqueryload
1. Alternative methods for converting SQLAlchemy results to JSON: http://stackoverflow.com/questions/5022066/how-to-serialize-sqlalchemy-result-to-json
1. REST APIs with pagination
 * https://developer.atlassian.com/confdev/confluence-server-rest-api/pagination-in-the-rest-api
 * http://stackoverflow.com/questions/13872273/api-pagination-best-practices
 * https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-ix-pagination
