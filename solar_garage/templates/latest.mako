<%inherit file="admin_layout.mako"/>

<div class="container" id="page-0">
    <div class="row" id="boxes">

    </div>
</div>
<script type="text/javascript">
    const things = [
        % for t in things:
            "${t}",
        % endfor
    ];
    $(document).ready(function () {
        let $boxes = $('#boxes');

        things.forEach(function (t, idx) {
            $boxes.append(`<div class="card bg-light mb-3 mx-1" style="max-width: 18rem;">
                  <div class="card-header">` + t + `</div>
                  <div class="card-body">
                    <h5 class="card-title">Voltage: <span id="voltage-` + t + `"></span></h5>
                    <h5 class="card-title">Current: <span id="current-` + t + `"></span></h5>
                    <small>Updated: <span id="updated-`+t+`"></span></small>
                  </div>
                </div>`);

            function getLatest() {
                $.getJSON('/last/' + t, function (d) {
                    $('#voltage-' + t).text(d.voltage);
                    $('#current-' + t).text(d.current);
                    $('#updated-' + t).text(moment.unix(d.datetime.$date/1000).format('HH:mm DD/MM/YYYY'));
                })
            }
            setTimeout(function() {
                setInterval(function () {
                    getLatest();
                }, 5000);
            }, idx*500);
            getLatest();
        });

    });

</script>