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
            transition: background-color 2s ease-out;
            justify-content: center;
        }

        .bay > div {
            font-size: 32px;
            font-weight: 900;
        }

        .car-bay {
            width: 200px;
            height: 200px;
            background-color: #244e63;
            display: flex;
            flex-direction: column;
            align-content: flex-start;
        }

        #bays {
            position: absolute;
            top: 220px;
            left: 0;
            justify-content: center;
            right: 0;
            display: flex;
            margin-left: auto;
            margin-right: auto;
            flex-direction: row;
        }

        .battery {
            background-color: #1B5E20;
            height: 200px;
            width: 200px;
        }

        .grid {
            ## background-color: #f4f4f4;
            color: #404040;
            ## background-position: center;
            background: url('/static/transmission.png') no-repeat center;
            height: 200px;
            width: 200px;
        }


        #below {
            position: relative;
            display: flex;
            align-items: center;
            flex-direction: row;
        }

        #solar-panels {
            width: 300px;
            height: 200px;
            background-color: #0ab24f;
        }

        #bay-1, #bay-6 {
            ## Fast charging bays
            background-color: #23604f;
            transition: background-color 2s ease-out;
        }

        .charging {
            background-color: #00d1b5 !important;
            transition: background-color 2s ease-out;
        }

        .fast-charging {
            background-color: #51b5d9 !important;
            transition: background-color 2s ease-out;
        }

        .row {
            display: flex;
            flex-direction: row;
        }

        .solar, .battery {
            display: flex;
            flex-direction: column;
        }

        .wrapper {
            position: relative;
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
        <div class="bay solar" id="solar-panels">
            <h3>Solar Panels</h3>
            <div id="power-panels"></div>
        </div>
        <div class="bay battery" id="battery">
            <h3>Battery</h3>
            <div id="power-battery"></div>
        </div>
    </div>
    <div class="wrapper">
        <div id="baysUp" style="width:1650px;height:500px;">
        </div>
        <div id="bays">
            <div class="bay car-bay" id="bay-1">
                <h3>Bay 1 (FAST)</h3>
                <div id="power-1"></div>
            </div>
            <div class="bay car-bay" id="bay-2">
                <h3>Bay 2</h3>
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
                <h3>Bay 6 (FAST)</h3>
                <div id="power-6"></div>
            </div>
        </div>

    </div>
    <div id="below">
        <div class="bay grid solar" id="grid">
            <h1>Power Grid</h1>
            <div id="power-grid"></div>
        </div>
    </div>

</div>
</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/103/three.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="/static/js/DDSLoader.js"></script>
<script src="/static/js/OBJLoader.js"></script>
<script src="/static/js/MTLLoader.js"></script>>

<script src="${request.static_url('solar_garage:static/leader-line.min.js')}"></script>
<script>
    var container, mObject;
    var camera, scene, renderer;
    var mouseX = 0, mouseY = 0;
    container = document.getElementById('baysUp');
    const height = container.offsetHeight;
    const width = container.offsetWidth;
    var windowHalfY = height / 2;
    var windowHalfX = width / 2;

    init();
    animate();
    const fitCameraToObject = function (camera, object, offset, controls) {
        offset = offset || 1.25;
        const boundingBox = new THREE.Box3();
        // get bounding box of object - this will be used to setup controls and camera
        boundingBox.setFromObject(object);
        const center = boundingBox.getCenter();
        const size = boundingBox.getSize();
        // get the max side of the bounding box (fits to width OR height as needed )
        const maxDim = Math.max(size.x, size.y, size.z);
        const fov = camera.fov * (Math.PI / 180);
        let cameraZ = Math.abs(maxDim / 4 * Math.tan(fov * 2));
        cameraZ *= offset; // zoom out a little so that objects don't fill the screen
        camera.position.z = cameraZ;
        const minZ = boundingBox.min.z;
        const cameraToFarEdge = (minZ < 0) ? -minZ + cameraZ : cameraZ - minZ;
        camera.far = cameraToFarEdge * 3;
        camera.updateProjectionMatrix();
        if (controls) {
            // set camera to rotate around center of loaded object
            controls.target = center;
            // prevent camera from zooming out far enough to create far plane cutoff
            controls.maxDistance = cameraToFarEdge * 2;
            controls.saveState();
        } else {
            camera.lookAt(center)
        }
    };

    function init() {
        camera = new THREE.PerspectiveCamera(25, width / height, 1, 2000);
        camera.position.z = 180;
        // scene
        scene = new THREE.Scene();
        var ambientLight = new THREE.AmbientLight(0xcccccc, 0.4);
        scene.add(ambientLight);
        var pointLight = new THREE.PointLight(0xffffff, 0.8);
        camera.add(pointLight);
        scene.add(camera);
        // model
        var onProgress = function (xhr) {
            if (xhr.lengthComputable) {
                var percentComplete = xhr.loaded / xhr.total * 100;
                console.log(Math.round(percentComplete, 2) + '% downloaded');
            }
        };
        var onError = function () {
            console.log("Error loading model");
        };
        const model_name = "sg_no_concrete_2";
        THREE.Loader.Handlers.add(/\.dds$/i, new THREE.DDSLoader());
        new THREE.MTLLoader()
                .setPath('/static/models/')
                .load(model_name+'.mtl', function (materials) {
                    materials.preload();
                    new THREE.OBJLoader()
                            .setMaterials(materials)
                            .setPath('/static/models/')
                            .load(model_name+'.obj', function (object) {
                                object.position.x = 10;
                                object.position.y = 1;
                                mObject = object;
                                scene.add(object);
                                mObject.rotateOnWorldAxis(new THREE.Vector3(1, 0, 0).normalize(), 3 * Math.PI / 2);
                                mObject.rotateOnWorldAxis(new THREE.Vector3(0, 1, 0).normalize(), Math.PI);
                                fitCameraToObject(camera, object, 3.05);
                                object.position.z -= 1;
                            }, onProgress, onError);
                });
        renderer = new THREE.WebGLRenderer({antialias: true, alpha: true});
        renderer.setClearColor(0xffffff, 0);
        renderer.setPixelRatio(window.devicePixelRatio);
        renderer.setSize(width, height);
        container.appendChild(renderer.domElement);
        document.addEventListener('mousemove', onDocumentMouseMove, false);
        window.addEventListener('resize', onWindowResize, false);
    }

    function onWindowResize() {
        camera.aspect = width / height;
        camera.updateProjectionMatrix();
        renderer.setSize(width, height);
    }

    function onDocumentMouseMove(event) {
        mouseX = (event.clientX - windowHalfX) / 2;
        mouseY = (event.clientY - windowHalfY) / 2;
    }

    //
    function animate() {
        requestAnimationFrame(animate);
        render();
    }

    function render() {
         renderer.render(scene, camera);
    }

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
                end: {element: e, x: 100, y: '100%'},
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
            ##  endSocketGravity: 100,
            startSocket: 'bottom',
            endSocket: 'top',
            x: '100%',
            y: '100%',
            dash: {animation: true},
            dropShadow: true,
        });
        panels2grid.setOptions({start: LeaderLine.pointAnchor({element: panels2grid.start, x: '94%', y: '100%'})});

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
            let p = (obj.voltage * obj.current[0] / 1000) + 'kW';
            return p;
        }

        function updateCallback(data) {
            data.bays.forEach(function (obj, index) {
                let charging = obj.current !== 0;
                let bayId = obj.thing.split('-')[1];
                let $power = $('#power-' + bayId);
                if (charging) {

                    $('#bay-' + bayId).addClass((bayId === '6' || bayId === '1' ? 'fast-' : '') + 'charging');
                    if ($power.is(":hidden")) {
                        $power.fadeIn();
                    }
                    $power.html(power(obj) + ' <i class="fas fa-bolt"></i>');
                } else {
                    $power.fadeOut();
                    $('#bay-' + bayId).removeClass((bayId === '6' || bayId === '1' ? 'fast-' : '') + 'charging');
                }
                lines[obj.thing].setOptions({dash: {animation: charging}})
            });
            if (data['battery-in']) {
                panels2battery.setOptions({
                    start: panelsEl,
                    end: batteryEl,
                    dash: {animation: data['battery-in'].current !== 0}
                });
                $batteryPower.html(power(data['battery-in']));
            } else if (data['battery-out']) {
                panels2battery.setOptions({
                    start: batteryEl,
                    end: panelsEl,
                    dash: {animation: data['battery-out'].current !== 0}
                });
                $batteryPower.text(power(data['battery-out']));
            } else {
                panels2grid.setOptions({dash: {animation: true}});
            }
            if (data.solar) {
                $panelsPower.text(power(data.solar));
                sun2panels.setOptions({dash: {animation: data.solar.current !== 0}});
            }
            if (data.grid) {
                $("#power-grid").text(power(data.grid));
            }
        }

        (function () {
            ##  initModel();

            function update() {
                if (document.hasFocus())
                    getStatus(updateCallback);
            }

            update();
            setInterval(update, 7000);
        })();
    })
</script>
</html>
