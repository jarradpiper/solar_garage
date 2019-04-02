from pyramid.request import Request
from pyramid.view import view_config
from datetime import datetime
from multiprocessing import Pool
import pymongo


@view_config(route_name='home', renderer='templates/landing.mako')
def landing(request: Request):
    return {'project': 'solar_garage'}


@view_config(route_name='charts', renderer='templates/charts.mako')
def charts(request: Request):
    return {'title': 'Charts', 'things': request.db_sg.status.distinct('thing')}


@view_config(route_name='latest', renderer='templates/latest.mako')
def latest(request: Request):
    return {'title': 'Latest Readings', 'things': request.db_sg.status.distinct('thing')}


@view_config(route_name='last', renderer='bson')
def get_last(request: Request):
    return request.db_sg.status.find_one({'thing': request.matchdict['thing']}, {'_id': 0}, sort=[('datetime', -1)])


@view_config(route_name='api_charts', renderer='bson')
def api_charts(request: Request):
    thing = request.matchdict['thing']
    aggr = request.GET.get('aggregate')
    start = int(request.GET.get('start'))
    end = int(request.GET.get('end'))
    query = {
        'thing': thing
    }
    if start or end:
        query['datetime'] = {}
    if start:
        query['datetime']['$gte'] = datetime.utcfromtimestamp(start)
    if end:
        query['datetime']['$lte'] = datetime.utcfromtimestamp(end)

    if aggr in ['hour', 'day', 'week', 'month']:
        group_id = {
            'year': {'$year': '$datetime'},
            'month': {'$month': '$datetime'},
            'week': {'$week': '$datetime'},
            'day': {'$dayOfMonth': '$datetime'},
            'hour': {'$hour': '$datetime'}
        }
        if aggr == 'day':
            del group_id['hour']
        if aggr == 'week':
            del group_id['hour']
            del group_id['day']
        if aggr == 'month':
            del group_id['hour']
            del group_id['day']
            del group_id['week']
        data = list(request.db_sg.status.aggregate([
            {'$match': query},
            {'$sort': {'datetime': pymongo.ASCENDING}},
            {
                '$group': {
                    '_id': group_id,
                    # 'r': {'$push': {'dt': '$datetime', 'power': {'$multiply': ['$voltage', '$current']}}},
                    # 'kWh': {'$sum': {'$multiply': ['$voltage', '$current', {'$divide': ['$diff', 3600, 1000]}]}}
                    'kWh': {'$sum': {'$multiply': ['$voltage', '$current', 5. / 3600, 1. / 1000]}}
                }
            }
        ], allowDiskUse=True))
        # for g in data:
        #     total = 0
        #     readings = sorted(g['r'], key=lambda x: x['dt'])
        #     for a, b in zip(readings, readings[1:]):
        #         total += (b['power'] / 1000.) * (b['dt'] - a['dt']).total_seconds() / 3600.
        #     del g['r']
        #     g['kWh'] = total
    else:
        data = request.db_sg.status.find(query)
    return {
        'data': sorted(data, key=lambda x: tuple(x['_id'].get(f, 0) for f in ('year', 'month', 'week', 'day', 'hour')))
    }
