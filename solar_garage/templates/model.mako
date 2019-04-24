<!DOCTYPE html>
<html lang="en">
<head>
    <title>Solar Garage Model</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
    <style>
        body {
            background-color: #f0ebf2;
            color: #fff;
            margin: 0px;
            overflow: hidden;
        }

    </style>
</head>

<body>
<div id="info">
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/103/three.min.js"></script>
<script src="/static/js/DDSLoader.js"></script>
<script src="/static/js/OBJLoader.js"></script>
<script src="/static/js/MTLLoader.js"></script>

<script>
    var container, stats, mObject;
    var camera, scene, renderer;
    var mouseX = 0, mouseY = 0;
    var windowHalfX = window.innerWidth / 2;
    var windowHalfY = window.innerHeight / 2;
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
        container = document.createElement('div');
        document.body.appendChild(container);
        camera = new THREE.PerspectiveCamera(25, window.innerWidth / window.innerHeight, 1, 2000);
        camera.position.z = 180;
        // scene
        scene = new THREE.Scene();
        scene.background = new THREE.Color('rgba(0,0,0,0)');
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
        THREE.Loader.Handlers.add(/\.dds$/i, new THREE.DDSLoader());
        new THREE.MTLLoader()
                .setPath('/static/models/')
                .load('sg.mtl', function (materials) {
                    materials.preload();
                    new THREE.OBJLoader()
                            .setMaterials(materials)
                            .setPath('/static/models/')
                            .load('sg.obj', function (object) {
                                object.position.x = -10;
                                mObject = object;
                                scene.add(object);
                                var axis = new THREE.Vector3(0.5, 0.5, 0.5).normalize();//tilted a bit on x and y - feel free to plug your different axis here
                                //in your update/draw function
                                object.rotateOnAxis(axis, 0.01);

                                 fitCameraToObject(camera, object, 9)
                            }, onProgress, onError);
                });
        //
        renderer = new THREE.WebGLRenderer({antialias: true, alpha: true});
        renderer.setClearColor(0xffffff, 0);
        renderer.setPixelRatio(window.devicePixelRatio);
        renderer.setSize(window.innerWidth, window.innerHeight);
        container.appendChild(renderer.domElement);
        document.addEventListener('mousemove', onDocumentMouseMove, false);
        //
        window.addEventListener('resize', onWindowResize, false);
    }

    function onWindowResize() {
        windowHalfX = window.innerWidth / 2;
        windowHalfY = window.innerHeight / 2;
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
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
        ##  camera.position.x += (mouseX - camera.position.x) * .05;
        ##  camera.position.y += (-mouseY - camera.position.y) * .05;
        ##      fitCameraToObject(camera, mObject);
            camera.lookAt(scene.position);
        renderer.render(scene, camera);
    }
</script>

</body>
</html>