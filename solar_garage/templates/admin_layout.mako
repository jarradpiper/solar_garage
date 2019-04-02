<!DOCTYPE html>
<html lang="${request.locale_name}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" href="${request.static_url('solar_garage:static/favicon.ico')}">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Solar Garage Admin: ${title}</title>
    <!-- Bootstrap core CSS -->
    <%include file="bootstrap_header.mako"/>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/string-format/0.5.0/string-format.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/dygraph/2.1.0/dygraph.min.css"/>
    <link rel="stylesheet" href="${request.static_url('solar_garage:static/dashboard.css')}"/>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
    <!-- Custom styles for this template -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
    <style type="text/css">
        #jumbo-top {
            background-image: url('${request.static_url('solar_garage:static/booking_background.jpg')}');
            background-size: cover;
            overflow: hidden;

        }

        @media (max-width: 768px) {
            #jumbo-top {
                ## font-size: 2.5rem;
            }
        }

        @media (max-width: 992px) {
            #jumbo-top {
                ## font-size: 1rem;
            }
        }



            ## .container-fluid {
        ##     height: 100vh;
        ## }

        .thumb {
            height: 75px;
            border: 1px solid #000;
            margin: 10px 5px 0 0;
        }

    </style>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.10/lodash.min.js"></script>
    <script type="text/javascript">
        $.ajaxSetup({
            headers: {'X-CSRF-Token': "${get_csrf_token()}"}
        });
        format.extend(String.prototype, {});
    </script>
</head>
<body>
<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">Flinders Solar Garage</a>
</nav>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 col-1  d-md-block bg-light sidebar collapse show" id="sidebar">
            <div class="sidebar-sticky">
                <ul class="nav flex-column">
                    <%
                        links = [ ('Users', 'users','user'),
                        ('Charts', 'charts', 'area-chart'),
                        ('Latest', 'latest', 'bolt'),
                        ('Graphic', 'show_graphic', 'sun-o'),
                         ('Logout', 'logout', 'sign-out'),
                         ]
                        ##                         ('Bookings', 'chaperone', 'address-book'),
                        ##                         ('New Incident', 'chaperone_log_new', 'plus-square-o'),
                        ##                         ('Incident Logs', 'chaperone_log', 'list'),
                        ##                         ('Surveys', 'chaperone_survey_list', 'check-square-o'),
                        ##                         ('Board/Depart Report', 'board_depart_summary', 'bus'),
                        ##                         ('Rider Report', 'daily_volume', 'area-chart'), ]
                        ##                         if request.user['level'] == 'admin':
                        ##                             links.extend([,
                        ##                              ('About', 'svn_info', 'code-fork'),
                        ##                              ('Make Booking', 'admin_booking', 'plus-square'),
                        ##                              ('Unavabilities', 'admin_bus_unavailable', 'times')])
                        ##                         links.append(('Logout', 'logout', 'sign-out'))
                    %>

                    %for _title, route, icon in links:
                    <% active = request.matched_route.name == route %>
                        <li class="nav-item pl-xs-1">
                            <a class="nav-link${(' active' if active else '')}" href="${request.route_url(route)}">
                                <i class="fa fa-${icon}" aria-hidden="true"></i>
                                <span class="d-none d-md-inline">${_title}
                                    % if active:
                                        <span class="sr-only">(current)</span>
                                    % endif
                                    %if route == 'logout':
                                        <small>${request.authenticated_userid}</small>
                                    %endif
                                    </span>
                            </a>
                        </li>
                    %endfor
                </ul>
            </div>
        </nav>

        <main role="main" class="col-md-10 offset-md-2 offset-1 col-lg-10 px-0">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-0 pb-0 mb-0">

                <div class="col-md col-12 px-0 main">
                    <div class="jumbotron jumbotron-fluid" id="jumbo-top">
                        <div class="container">
                            <h1 class="display-4 text-light">${title}</h1>
                        </div>

                    </div>
                    <div class="container-fluid" id="main">
                        ${ next.body() }
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>


</body>
</html>
