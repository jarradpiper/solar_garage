<html lang="en">
<head>

    <title>Flinders Solar Garage</title>
    <link href="https://fonts.googleapis.com/css?family=Roboto+Condensed" rel="stylesheet">

    <style>
        html,
        body {
            background-color: #f0ebf2;
            color: #F6F4F2;
            padding: 0;
            margin: 0;
            overflow-y: auto;
        }

        .container {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            overflow-y: hidden;
            position: relative;
            min-width: 100vh;
            min-height: 100vh;
        }

        .slow-spin {
            -webkit-animation: fa-spin 6s infinite linear;
            animation: fa-spin 6s infinite linear;
        }

        .sun {
            display: flex;
            align-items: center;
            width: 144px;
            height: 144px;
            justify-content: center;
            flex-direction: column;
        }

        .bay {
            border-radius: 10px;
            margin: 2em 2em;
            box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.12),
            0 2px 4px 0 rgba(0, 0, 0, 0.08);
            font-family: 'Roboto Condensed', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .car-bay {
            width: 200px;
            height: 200px;
            background-color: #004D40;
            display: flex;
            flex-direction: column;
            align-content: flex-start;
        }

        #bays {
            display: flex;
            flex-direction: row;
        }

        .battery {
            background-color: #1B5E20;
            height: 200px;
            width: 200px;
        }

        .grid {
            background-color: #424242;
            height: 200px;
            width: 200px;
        }

        #below {
            ## display: flex;
            ## align-items: center;
            ## flex-direction: rows;
        }

        #solar-panels {
            width: 400px;
            height: 200px;
            background-color: #0ab24f;
        }

        #bay-1, #bay-2 {
            ## Fast charging bays
            background-color: #b2a71a
        }

        .row {
            display: flex;
            flex-direction: row;
        }



    </style>
    <script defer src="https://use.fontawesome.com/releases/v5.7.2/js/all.js"
            integrity="sha384-0pzryjIRos8mFBWMzSSZApWtPl/5++eIfzYmTgBBmXYdhvxPc+XcFEk+zJwDgWbP"
            crossorigin="anonymous"></script>
</head>
<body>
<div class="container">
    <div class="sun" id="sun">
        <span style="color: #f9d71c;">
            <i class="fas fa-sun slow-spin fa-9x"></i>
        </span>
    </div>
    <div class="row">
        <div class="bay" id="solar-panels">
            <h3>Solar Panels</h3>
            <div id="power-panels"></div>
        </div>
        <div class="bay battery" id="battery">
            <h3>Battery</h3>
            <div id="power-battery"></div>
        </div>
    </div>
    <div id="bays">
        <div class="bay car-bay" id="bay-1">
            <h3>Bay 1 (FAST)</h3>
            <div id="power-1"></div>
        </div>
        <div class="bay car-bay" id="bay-2">
            <h3>Bay 2 (FAST)</h3>
            <div id="power-2"></div>
        </div>
        <div class="bay car-bay" id="bay-3">
            <h3>Bay 3</h3>
            <div id="power-3"></div>
        </div>
        <div class="bay car-bay" id="bay-4">
            <h3>Bay 4</h3>
            <div id="power-4"></div>
        </div>
        <div class="bay car-bay" id="bay-5">
            <h3>Bay 5</h3>
            <div id="power-5"></div>
        </div>
        <div class="bay car-bay" id="bay-6">
            <h3>Bay 6</h3>
            <div id="power-6"></div>
        </div>
    </div>
    <div id="below">
        <div class="bay grid" id="grid">
            <h3>Grid</h3>
        </div>


    </div>
</div>
</body>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    ## <script src="https://gitcdn.xyz/repo/juliangarnier/anime/master/lib/anime.min.js"></script>

<script src="${request.static_url('solar_garage:static/leader-line.min.js')}"></script>
<script>
    $(document).ready(function () {
        const gridEl = document.getElementById('grid');
        const sunEl = document.getElementById('sun');
        const batteryEl = document.getElementById('battery');
        const panelsEl = document.getElementById('solar-panels');
        const lines = {};
        [...document.getElementsByClassName('car-bay')].forEach(function (e) {
            const id = e.getAttribute('id');
            let l = new LeaderLine(gridEl, e, {
                color: 'blue',
                size: 4,
                startPlug: 'disc',
                ##  path: 'grid',
                 ##  endSocketGravity: [0,0],
                 startSocket: 'auto',
                endSocket: 'bottom',
                dash: {animation: false},
                dropShadow: true,
            });
            lines[id] = l;
        });
        lines['bay-1'].setOptions({
            start: LeaderLine.pointAnchor({
                element: lines['bay-1'].start,
                x: 0,
                y: 200 / 3 * 2
            })
        });
        lines['bay-2'].setOptions({start: LeaderLine.pointAnchor({element: lines['bay-2'].start, x: 0, y: 200 / 3})});
        lines['bay-3'].setOptions({start: LeaderLine.pointAnchor({element: lines['bay-3'].start, x: 0, y: 0})});
        lines['bay-4'].setOptions({start: LeaderLine.pointAnchor({element: lines['bay-4'].start, x: '100%', y: 0})});
        lines['bay-5'].setOptions({
            start: LeaderLine.pointAnchor({
                element: lines['bay-5'].start,
                x: '100%',
                y: 200 / 3
            })
        });
        lines['bay-6'].setOptions({
            start: LeaderLine.pointAnchor({
                element: lines['bay-6'].start,
                x: '100%',
                y: 200 / 3 * 2
            })
        });
        ##  new LeaderLine(sunEl, gridEl, {
        ##      color: 'blue',
        ##      size: 4,
        ##      path: 'grid',
        ##      endSocketGravity: 100,
        ##      startSocket: 'bottom',
        ##      endSocket: 'top',
        ##      x: '50%',
        ##      y: '100%',
        ##      dash: {animation: true},
        ##      dropShadow: true,
        ##  });

        let sun2panels = new LeaderLine(sunEl, panelsEl, {
            color: 'yellow',
            size: 4,
            path: 'grid',
            ##  endSocketGravity: 100,
            ##  startSocket: 'bottom',
            ##  endSocket: 'top',
            ##  x: '50%',
            ##  y: '100%',
            dash: {animation: false},
            dropShadow: true,
        });

        let panels2grid = new LeaderLine(panelsEl, gridEl, {
            color: 'blue',
            size: 4,
            path: 'grid',
            endSocketGravity: 100,
            startSocket: 'bottom',
            endSocket: 'top',
            x: '300',
            y: '100%',
            dash: {animation: false},
            dropShadow: true,
        });
        panels2grid.setOptions({start: LeaderLine.pointAnchor({element: panels2grid.start, x: '76.5%', y: '100%'})});

        let panels2battery = new LeaderLine(panelsEl, batteryEl, {
            color: 'blue',
            size: 4,
            path: 'grid',
            ##  endSocketGravity: 100,
            ##  startSocket: 'bottom',
            ##  endSocket: 'top',
            ##  x: '50%',
            ##  y: '100%',
            dash: {animation: false},
            dropShadow: true,
        }).setOptions({start: LeaderLine.pointAnchor({element: panelsEl, x: '100%', y: '50%'})});

        function getStatus(cb) {
            $.getJSON('/graphic.json', function (data) {
                cb(data);
            });
        }

        let $batteryPower = $('#power-battery');
        let $panelsPower = $('#power-panels');

        function power(obj) {
            let p = (obj.voltage * obj.current / 1000) + 'kW';
            ##  console.log(p);
            return p;
        }
        function updateCallback(data) {
            data.bays.forEach(function (obj, index) {
                let charging = obj.current !== 0;
                let bayId = obj.thing.split('-')[1];
                let $power = $('#power-' + bayId);
                if (charging) {
                    if ($power.is(":hidden")) {
                        $power.fadeIn();
                    }
                    $power.html(power(obj) + ' <i class="fas fa-bolt"></i>');
                } else {
                    $power.fadeOut();
                }
                lines[obj.thing].setOptions({dash: {animation: charging}})
            });
            if (data.batteryIn) {
                panels2battery.setOptions({start: panelsEl, end: gridEl, dash:{animation:data.batteryIn.current !== 0}});
                $batteryPower.html(power(data.batteryIn));
            } else if (data.batteryOut) {
                panels2battery.setOptions({start: gridEl, end: panelsEl, dash:{animation:data.batteryOut.current !== 0}});
                $batteryPower.text(power(data.batteryOut));
            }
            if (data.panels) {
                $panelsPower.text(power(data.panels));
                sun2panels.setOptions({dash:{animation:data.panels.current !== 0}});
            }
        }
        (function () {
            function update() {
                getStatus(updateCallback);
            }
            update();
            setInterval(update, 7000);
        })();
    })
</script>
</html>
