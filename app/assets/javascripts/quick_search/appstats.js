// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
  $('#appstats-date-showhide').click(function () {
    $('#appstats-date-filter').toggle();
  });
});

/*                RENDER SAMPLE GRAPH              */
$.ajax({
           type: "GET",
           contentType: "application/json; charset=utf-8",
           url: 'appstats/data',
           dataType: 'json',
           success: function (data) {
               draw(data);
           },
           error: function (result) {
               error();
           }
       });

function draw(data) {
  var data = [1,2,3,4,5];
  var svg = d3.select("#genGraph"),
      margin = {top: 20, right: 20, bottom: 30, left: 40},
      width = +svg.attr("width") - margin.left - margin.right,
      height = +svg.attr("height") - margin.top - margin.bottom;

  var x = d3.scaleLinear().rangeRound([0, width]),
      y = d3.scaleLinear().rangeRound([height, 0]);

  var g = svg.append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  x.domain([0, d3.max(data, function(d) { return d; })]);
  y.domain([0, d3.max(data, function(d) { return d; })]);

  g.append("g")
    .attr("class", "axis axis--x")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x).ticks(5));

  g.append("g")
    .attr("class", "axis axis--y")
    .call(d3.axisLeft(y).ticks(5))
  .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", "0.71em")
    .attr("text-anchor", "end")
    .text("Frequency");

  g.selectAll(".bar")
  .data(data)
  .enter().append("rect")
    .attr("class", "bar")
    .attr("x", function(d) { return x(d)-50; })
    .attr("y", function(d) { return y(d); })
    .attr("width", 50)
    .attr("height", function(d) { return height - y(d); });
}

function error() {
    console.log("error")
}
/////////////////////////////////////////////////////