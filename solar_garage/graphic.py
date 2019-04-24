from pyramid.request import Request
from pyramid.view import view_config
import pymongo


@view_config(route_name='show_graphic', renderer='templates/graphic.mako')
def show_graphic(request: Request):
    """
    Show the graphic of energy movement
    :param request:
    :return:
    """
    return {}


@view_config(route_name='api_graphic', renderer='json')
def api_get_graphic(request: Request):
    """
    Show the graphic of energy movement
    :param request:
    :return:
    """

    def get_last(thing):
        return request.db_sg.status.find_one({'thing': thing},
                                             {'_id': 0, 'datetime': 0},
                                             sort=[("datetime", pymongo.DESCENDING)])

    return {
        'bays': [get_last('bay-' + str(i)) for i in range(1, 7)],
        'grid': get_last('grid'),
        'solar': get_last('solar'),
        'battery-in': get_last('battery-in'),
        'battery-out': get_last('battery-out')
    }


@view_config(route_name='show_model', renderer='templates/model.mako')
def show_mdoel(request):
    return {}
