from datetime import datetime
from pyramid.httpexceptions import HTTPForbidden
from pyramid.request import Request
from pyramid.view import view_config


@view_config(route_name='api', request_method='POST')
def api(request: Request):
    js = request.json_body
    key = js.get('key')
    if key is None or request.db_sg.api_keys.find_one({'key': key}) is None:
        raise HTTPForbidden("Please specify a valid key")

    for row in js['rows']:
        try:
            row['datetime'] = datetime.fromtimestamp(row['datetime'])
            request.db_sg.status.insert_one(row)
        except Exception as e:
            print(e)
