from flask import Flask, got_request_exception, jsonify, request
from flask_restful import Api, reqparse
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.ext.automap import automap_base
from dateutil.parser import parse

############################
# Application wide variables
app = Flask(__name__)
app.config['BUNDLE_ERRORS'] = True
api = Api(app)
url_parameters = ['date', 'page']
# value intentionally set low for easy testing
PAGE_SIZE = 2
# value intentionally set low for easy testing
MAX_REQUESTS = 6

# connect to database
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@localhost:32771/gallery'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
automapper = automap_base()
automapper.prepare(db.engine, reflect=True)
############################

# Standard hello world response to let people know what this application does
@app.route('/')
def hello_world():
    return '<html><body>' \
           + '<p>RESTFUL URL with JSON response available at <a href="/gallery">/gallery</a></p>' \
           + '<p>Returns JSON array of all SMART applications available</p>' \
           + '<p>Optional parameters:<ul>' \
           + '<li>date - Only applications updated on or newer than date provided will be returned.' \
           + ' Date format must be valid according to <a href="https://dateutil.readthedocs.io/en/stable/parser.html">https://dateutil.readthedocs.io/en/stable/parser.html</a></li>' \
           + '<li>page - NOT YET IMPLEMENTED - If more than ' + str(PAGE_SIZE) + ' records are found, can view additional records via page parameter</li>' \
           + '</ul></p>' \
           + '</body></html>'

hit_counter = {}
@app.route('/gallery')
def gallery_query():
    # TO DO: need to implement more intelligent rate limiting
    # if too many requests from one IP return nothing, or error?
    # if memoization implemented, perhaps this should be tied with memoization?
    print(hit_counter)
    if request.remote_addr not in hit_counter:
        hit_counter[request.remote_addr] = 1
    else:
        hit_counter[request.remote_addr] += 1
    if hit_counter[request.remote_addr] > MAX_REQUESTS:
        print('too many visits -------------------------')
        return ('', 204)

    applications = automapper.classes['applications']
    listings = automapper.classes['listings']

    # get request parameters
    get_parser = reqparse.RequestParser()
    for u in url_parameters:
        get_parser.add_argument(
            u,
            dest = u,
            help = u + ' parameter',
        )

    # throw error on unrecognized parameters - this may not be wanted...
    args = get_parser.parse_args(strict=True)

    query = db.session.query(applications).join(listings).filter(listings.status == 'published').order_by(applications.updated_at.desc())

    try:
        query = query.filter(applications.updated_at >= parse(args['date']))
    except(ValueError, TypeError):
        print("Date parameter not valid or missing")

    # TO DO implement paging of results
    if args['page'] is not None:
        try:
            page = int(args['page'])
        except ValueError:
            print("can't convert")
        else:
            # paginate results here - replace this line
            result = query.all()
    else:
        result = query.all()

    # output for debugging purposes
    print(query)

    # build return object - start with applications table as base and add others
    retarr = []
    if result is not None:
        print(result)
        for record in result:
            ret = {}
            for c in applications.__table__.columns:
                ret[c.name] = getattr(record, c.name)
            ret = populate_collections(ret)
            retarr.append(ret)

    return jsonify(retarr)

############################
# function to populate the various subcollections associated with an application
def populate_collections(result_obj):
    applications_fhir = automapper.classes['applications_fhir']
    fhir = automapper.classes['fhir']
    collections = [{
        'src' : automapper.classes['applications_categories'],
        'dest' : automapper.classes['categories'],
        'name' : 'applications_categories'
    }, {
        'src' : automapper.classes['applications_ehr'],
        'dest' : automapper.classes['ehr'],
        'name' : 'applications_ehr'
    }, {
        'src' : automapper.classes['applications_fhir'],
        'dest' : automapper.classes['fhir'],
        'name' : 'applications_fhir'
    }, {
        'src' : automapper.classes['applications_operating_systems'],
        'dest' : automapper.classes['operating_systems'],
        'name' : 'applications_operating_systems'
    }, {
        'src' : automapper.classes['applications_pricing'],
        'dest' : automapper.classes['pricing'],
        'name' : 'applications_pricing'
    }, {
        'src' : automapper.classes['applications_specialties'],
        'dest' : automapper.classes['specialties'],
        'name' : 'applications_specialties'
    }]

    for c in collections:
        results = db.session.query(c['src']).join(c['dest']).filter(c['src'].application_id == result_obj['id']).add_column(c['dest'].name).all()
        result_obj[c['name']] = []
        for record in results:
            result_obj[c['name']].append(record.name)

    return result_obj

############################
# need to use this in gallery_query()
# function not validated to work correctly
memory = {}
MEMORY_AGE = 120
def memoize(table, params):
    if memory[table][params] is None:
        memory[table][params] = run_query(table, params)
    elif memory[table][params][stored] >= (time.time() - MEMORY_AGE):
        memory[table][params] = run_query(table, params)
    else:
        return memory[table][params]

############################
# exception logging
def log_exception(sender, exception, **extra):
    """ Log an exception to our logging framework """
    sender.logger.debug('Got exception during processing: %s', exception)
    for name, value in extra.items():
        sender.logger.debug('{0} = {1}'.format(name, value))

got_request_exception.connect(log_exception, app)

# these response headers allow for client side code to request resources
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET')
    return response

############################
# start application in debug mode, also listen on all ip addresses
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
