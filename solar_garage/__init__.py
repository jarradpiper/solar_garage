from datetime import datetime

from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy
from pyramid.config import Configurator
from pyramid.csrf import CookieCSRFStoragePolicy
from pyramid.renderers import JSON
from bson import json_util


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    config.add_static_view('static', 'static', cache_max_age=3600)

    config.add_route('favicon.ico', '/favicon.ico')
    config.add_route('home', '/')
    config.add_route('login', '/login')
    config.add_route('logout', '/logout')
    config.add_route('users', '/users')
    config.add_route('api', '/api')
    config.add_route('latest', '/latest')
    config.add_route('last', '/last/{thing}')
    config.add_route('show_graphic', '/graphic')
    config.add_route('api_graphic', '/graphic.json')
    config.add_route('charts', '/charts')
    config.add_route('api_charts', '/charts_{thing}.json')
    config.add_route('admin', '/admin')

    config.scan()

    def get_user(request):
        userid = request.unauthenticated_userid
        if userid is not None:
            return request.db_sg.users.find_one({'username': request.authenticated_userid})

    def auth_callback(uid, request):
        if hasattr(request, '_uid'):
            return request._uid
        user = request.db_sg.users.find_one({'username': uid})
        if user is not None:
            request._uid = [user['level']]
            return request._uid

    json_renderer = JSON()

    def datetime_adapter(obj, request):
        return obj.isoformat()

    json_renderer.add_adapter(datetime, datetime_adapter)
    config.add_renderer('json', json_renderer)
    config.add_renderer('bson', 'solar_garage.renderers.BSONRenderer')
    auth_policy = AuthTktAuthenticationPolicy(settings['auth_ticket_key'], callback=auth_callback, hashalg='sha512')
    config.set_authentication_policy(auth_policy)
    config.set_authorization_policy(ACLAuthorizationPolicy())
    config.set_csrf_storage_policy(CookieCSRFStoragePolicy())
    config.add_request_method(get_user, 'user', reify=True)

    return config.make_wsgi_app()
