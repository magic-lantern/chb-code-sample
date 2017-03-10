import app_gallery
import unittest
from flask import json, jsonify

class AppGalleryTestCase(unittest.TestCase):

    def setUp(self):
        app_gallery.app.config['TESTING'] = True
        self.app = app_gallery.app.test_client()
        # should probably validate database and create new test data
        return

    def tearDown(self):
        # full testing would require deletion of any test data
        return

    def test_hello_world(self):
        rv = self.app.get('/', follow_redirects=True)
        assert rv.status_code == 200
        assert 'text/html' in rv.content_type
        assert b'RESTFUL URL with JSON response available' in rv.data

    def test_gallery_query(self):
        # default request - should return all data
        rv = self.app.get('/gallery', follow_redirects=True)
        assert rv.status_code == 200
        assert 'application/json' in rv.content_type
        assert 'Access-Control-Allow-Origin' in rv.headers
        assert 'Access-Control-Allow-Headers' in rv.headers
        assert 'Access-Control-Allow-Methods' in rv.headers
        data = json.loads(rv.data)
        assert len(data) == 3, len(data)
        # make sure data in order - newest first
        assert data[0]['name'] == 'Growth Chart'
        assert data[1]['name'] == 'BP Centiles v1 (Open Source)'
        assert data[2]['name'] == 'Cardiac Risk'

        # invalid query parameter
        rv = self.app.get('/gallery?blah', follow_redirects=True)
        assert rv.status_code == 400

        # invalid date should return all data
        rv = self.app.get('/gallery?date=blah', follow_redirects=True)
        assert rv.status_code == 200
        data = json.loads(rv.data)
        assert len(data) == 3, len(data)
        # make sure data in order - newest first
        assert data[0]['name'] == 'Growth Chart'
        assert data[1]['name'] == 'BP Centiles v1 (Open Source)'
        assert data[2]['name'] == 'Cardiac Risk'

        # date parameter - future dated should return no results
        rv = self.app.get('/gallery?date=2020-01-01', follow_redirects=True)
        assert rv.status_code == 200
        assert 'application/json' in rv.content_type
        data = json.loads(rv.data)
        assert len(data) == 0

        # date parameter - this date should return 1 result
        rv = self.app.get('/gallery?date=2017-02-19%2000:42', follow_redirects=True)
        assert rv.status_code == 200
        assert 'application/json' in rv.content_type
        data = json.loads(rv.data)
        assert len(data) == 1, len(data)
        assert data[0]['name'] == 'Growth Chart'

        # page parameter - not yet implemented
        rv = self.app.get('/gallery?page=5', follow_redirects=True)
        assert rv.status_code == 200
        assert 'application/json' in rv.content_type

        # more requests than MAX_REQUESTS, should return http 204 code
        rv = self.app.get('/gallery?page=5', follow_redirects=True)
        assert rv.status_code == 204

        '''
        for r in dir(rv):
            print(r)
            print('-----', getattr(rv, r))
        '''


if __name__ == '__main__':
    unittest.main()
