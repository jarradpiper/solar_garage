from datetime import datetime
from pyramid.httpexceptions import HTTPForbidden
from pyramid.request import Request
from pyramid.view import view_config


@view_config(route_name='api', request_method='POST', renderer='json')
def api(request: Request):
    js = request.json_body
    key = js.get('key')
    if key is None or request.db_sg.api_keys.find_one({'key': key}) is None:
        raise HTTPForbidden("Please specify a valid key")
    print(js)
    del js['key']

    # make sure all the right stuff is in there

    bays = [
        ('bay-1', ['FAST_CHARGE_1_CURRENT_1', 'FAST_CHARGE_1_CURRENT_2', 'FAST_CHARGE_1_CURRENT_3'], 'FAST_CHARGE_1_VOLTAGE'),
        ('bay-2', ['AC_CHARGE_1_CURRENT'], 'AC_CHARGE_1_VOLTAGE'),
        ('bay-3', ['AC_CHARGE_2_CURRENT'], 'AC_CHARGE_2_VOLTAGE'),
        ('bay-4', ['AC_CHARGE_3_CURRENT'], 'AC_CHARGE_3_VOLTAGE'),
        ('bay-5', ['AC_CHARGE_4_CURRENT'], 'AC_CHARGE_4_VOLTAGE'),
        ('bay-6', ['FAST_CHARGE_2_CURRENT_1', 'FAST_CHARGE_2_CURRENT_2', 'FAST_CHARGE_2_CURRENT_3'], 'FAST_CHARGE_2_VOLTAGE'),
        ('battery-in', ['BATTERY_IN_CURRENT'], 'BATTERY_IN_VOLTAGE'),
        ('battery-out', ['BATTERY_OUT_CURRENT'], 'BATTERY_OUT_VOLTAGE'),
        ('grid', ["GRID_CURRENT_1", "GRID_CURRENT_2", "GRID_CURRENT_3"], "GRID_VOLTAGE"),
        ('solar', ["SOLAR_CURRENT_1", "SOLAR_CURRENT_2", "SOLAR_CURRENT_3"], "SOLAR_VOLTAGE"),
    ]
    d = js['data']
    for b in bays:
        obj = {
            'datetime': datetime.fromtimestamp(d['datetime']),
            'diff': d['diff'],
            'thing': b[0],
            'current': [d[f] for f in b[1]],
            'voltage': d[b[-1]],
        }

        request.db_sg.status.insert_one(obj)
    return {"success": True}
