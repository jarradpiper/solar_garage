<!DOCTYPE html>
<html lang="${request.locale_name}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="${request.static_url('solar_garage:static/favicon.ico')}">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="Solar Garage at Flinders">
    <meta name="author" content="Jonathan Mackenzie">

    <title>Flinders Solar Garage</title>

    <%include file="bootstrap_header.mako"/>
    <!-- Custom styles for this template -->

    <style type="text/css">
        @media (min-width: 768px) {
            #tagline {
                bottom: 0;
                position: absolute;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>

    <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Muli" rel="stylesheet">
    <link href="${request.static_url('solar_garage:static/style.css')}" rel="stylesheet">
</head>

<body id="page-top">

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light fixed-top" id="mainNav">
    <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="#page-top">Flinders Solar Garage</a>
        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse"
                data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    % if request.authenticated_userid:
                        <a class="nav-link js-scroll-trigger" href="${request.route_url('admin')}">Admin</a>
                    %else:
                        <a class="nav-link js-scroll-trigger" href="${request.route_url('login')}">Login</a>
                    % endif

                </li>
            </ul>
        </div>
    </div>
</nav>

<header class="masthead text-center text-white d-flex">
    <div class="container my-auto">
        <div class="row">
            <div class="col-12">
                <h1 class="text-center mx-auto font-weight-bold">Flinders Solar Garage</h1>
            </div>
            <div class="col-12">
                <hr class="my-12">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12 mx-auto align-bottom">
                <img style="height:200px;color:#005005"
                     src="${request.static_url('solar_garage:static/solar-panel-solid.svg')}"
                     class="float-md-right img-responsive"/>
            </div>
            <div class="col-lg-6 col-md-6 col-sm-12 mx-auto">
                <h2 id="tagline" class="text-uppercase text-md-left text-sm-center align-text-bottom">
                    <strong>Your Car<br>Solar Powered</strong>
                </h2>
            </div>
        </div>
    </div>
</header>


<section id="services">
    <div class="container pt-5">
        <div class="row">
            <div class="col-lg-12 mx-auto text-center">
                <h2 class="section-heading text-dark">Project Partners</h2>
                <hr class="my-12">
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row mx-auto d-solar_garage align-items-center h-100">
            <div class="mx-auto col-lg-3 col-md-6 text-center">
                <div class="service-box mt-5 mx-auto">
                    <img class="align-middle rounded img-fluid"
                         src="${request.static_url('solar_garage:static/logos/flinders.png')}"/>
                </div>
            </div>
            ##             <div class="mx-auto  col-lg-3 col-md-6 text-center">
            ##                 <div class="service-box mt-5 mx-auto">
            ##                     <img class="align-middle rounded img-fluid"
            ##                          src="${request.static_url('solar_garage:static/logos/RAA_NoTag_hires.jpg')}"/>
            ##                 </div>
            ##             </div>

            <div class="mx-auto col-lg-3 col-md-6 text-center">
                <div class="service-box mt-5 mx-auto">
                    <img class="align-middle rounded img-fluid"
                         src="${request.static_url('solar_garage:static/logos/renewal_sa.png')}"/>
                </div>
            </div>
            <div class="mx-auto col-lg-3 col-md-6 text-center">
                <div class="service-box mt-5 mx-auto">
                    <img class="align-middle rounded img-fluid"
                         src="${request.static_url('solar_garage:static/logos/ZEN_Energy.png')}"/>
                </div>
            </div>
        </div>
    </div>
</section>


<section id="contact">
    <div class="container">
        <div class="row">
            <div class="col-lg-8 mx-auto text-center">
                <h2 class="section-heading">Contact</h2>
                <hr class="my-4">
                <p class="mb-5">Please  email us with any queries you may have</p>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-4 mx-auto text-center">
                <i class="fa fa-envelope-o fa-3x mb-3 sr-contact"></i>
                <p>
                    <a href="mailto:solargarage@flinders.edu.au">solargarage@flinders.edu.au</a>
                </p>
            </div>
        </div>
    </div>
</section>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.4.1/js/mdb.min.js"></script>
<!-- Plugin JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.4.1/jquery.easing.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/scrollReveal.js/3.4.0/scrollreveal.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/jquery.magnific-popup.min.js"></script>

<!-- Custom scripts for this template -->
<script src="/static/landing_script.js"></script>
</body>
</html>
