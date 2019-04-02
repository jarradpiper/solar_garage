from pyramid.request import Request
from pyramid.view import view_config


@view_config(route_name='admin', renderer='templates/admin.mako')
def admin(request: Request):
    return {'title': 'Admin'}
