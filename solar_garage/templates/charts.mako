<%inherit file="admin_layout.mako"/>

<div class="container" id="page-0">
    <h3>Charts</h3>
    <div class="row">
        <div class="col-12">
            <form class="form-inline">
                <div class="form-group">
                    <label>Date Range</label>
                    <input type="text" class="form-control" id="daterange" name="datetimes"/>
                </div>
                <div class="form-group">
                    <label>Aggregation</label>
                    <select class="aggregation-select form-control" id="aggr" name="aggregation">
                        <option value="hour" selected>Hour</option>
                        <option value="day">Day</option>
                        <option value="week">Week</option>
                        <option value="month">Month</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Thing</label>
                    <select class="thing-select form-control" id="thing" name="thing">
                        % for t in things:
                            <option value="${t}">${t}</option>
                        % endfor
                    </select>
                </div>
                <div class="form-group" id="loading" style="display: none;">
                    <i class="fa fa-circle-o-notch fa-spin fa-2x fa-fw"></i>
                    <span class="sr-only">Loading...</span>
                </div>
            </form>
        </div>
        <div class="alert alert-danger" role="alert" id="err" style="display: none;">

        </div>
        <div id="bay-test-div"
             style="width:1000px; height:800px;padding:30px"></div>
    </div>
</div>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/dygraph/2.1.0/dygraph.min.js"></script>
<script type="text/javascript">
    const fmt = 'DD/MM/YYYY HH';

    let loading = $('#loading');
    let err = $('#err');
    loading.hide();

    function doCharts() {
        loading.fadeIn(100);
        err.fadeOut();
        let aggr = $('#aggr').val();
        let dr = $('#daterange').val().split(' - ');
        let thing = $('#thing').val();
        let args = {
            aggregate: aggr,
            start: moment(dr[0], fmt).unix(),
            end: moment(dr[1], fmt).unix()
        };

        $.getJSON('/charts_' + thing + '.json', args, function (data) {
            const arr = [];
            if (data.data.length === 0) {
                err.text("No data for this period").fadeIn();
                return;
            }
            data.data.forEach(function (el) {
                let dt = moment.utc().year(el._id.year).month(el._id.month).hour(0).minutes(0).seconds(0).milliseconds(0);
                const idlen = Object.keys(el._id).length;
                if (idlen === 3)
                    dt = dt.weekYear(el._id.week);
                if (idlen === 4)
                    dt = dt.date(el._id.day);
                if (idlen === 5)
                    dt = dt.date(el._id.day).hours(el._id.hour);
                arr.push([dt.toDate(), el.kWh]);
            });
            ##  arr.sort(function (a, b) {
            ##      return a[0] - b[0];
            ##  });
            try {
                let g = new Dygraph(document.getElementById('bay-test-div'), arr, {
                    title: "Aggregated Energy Consumption by " + aggr,
                    legend: 'always',
                    ylabel: 'Consumption (kWh)',
                    xlabel: 'Date',

                });
            } catch (e) {
                err.text(e).fadeIn();
                loading.fadeOut();
            }
        }).fail(function (x) {
            err.text(x).fadeIn();
        }).always(function (x) {
            loading.fadeOut(100);
        });
    }

    $(function () {
        $('input[name="datetimes"]').daterangepicker({
            timePicker: true,
            startDate: moment().startOf('hour'),
            endDate: moment().startOf('hour').add(32, 'hour'),
            timePicker24Hour: true,
            timePicker24Seconds: false,
            locale: {
                format: fmt
            }
        }).on('apply.daterangepicker', function (ev, picker) {
            doCharts();
        });
        $('select').select2().on('change', function (e) {
            doCharts();
        });
        doCharts();
    });

</script>