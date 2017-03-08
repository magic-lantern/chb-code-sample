from flask import Flask, got_request_exception
from flask_restful import Resource, Api, fields, marshal_with, reqparse


############################
# Application wide variables
app = Flask(__name__)
app.config['BUNDLE_ERRORS'] = True
api = Api(app)
url_parameters = ['date', 'page']
# connect to database

############################


@app.route('/')
def hello_world():
    return '<html><body>' \
           + '<p>JSON API RESTFUL URL available at <a href="/gallery">/gallery</a></p>' \
           + '</body></html>'

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

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
