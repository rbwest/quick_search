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
	console.log(data);
	var svg = d3.select("#genGraph"),
	    margin = {top: 20, right: 20, bottom: 20, left: 20},
	    width = +svg.attr("width") - margin.left - margin.right,
	    height = +svg.attr("height") - margin.top - margin.bottom;

	var x = d3.scaleLinear().rangeRound([0, width]),
	    y = d3.scaleLinear().rangeRound([0, height])
	    yL = d3.scaleLinear().rangeRound([0, height + 25]);

	var g = svg.append("g")
	    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	  x.domain([0, d3.max(data, function(d) { return d.clickcount; })]);
	  y.domain([0, d3.max(data, function(d , i) { return i; })]);

	// g.append("g")
	//   .attr("class", "axis axis--x")
	//   .attr("transform", "translate(0," + height + ")")
	//   .call(d3.axisBottom(x).ticks(7));

	g.append("g")
	  .attr("class", "axis axis--y")
	  .attr("transform", "translate(" + 100 + "," + 0 + ")")
      .call(d3.axisLeft(yL).ticks(0));
	//   .append("text")
	//   .attr("transform", "rotate(-90)")
	//   .attr("y", 6)
	//   .attr("dy", "0.71em")
	//   .attr("text-anchor", "end")
	//   .text("Frequency");

	g.selectAll(".bar")
	.data(data)
	.enter().append("rect")
	  .attr("class", "bar")
	  .attr("x", 100 )
	  .attr("y", function(d , i) { return y(i); })
	  .attr("width", function(d) { return x(d.clickcount); })
	  .attr("height", 25 );

	g.selectAll(".label")
	  .data(data)
	  .enter().append("text")
	  .text( function (d) { return d.action })
	  .attr("x" , 5)
	  .attr("y" , function (d , i) { return y(i) + 15; });
}

function error() {
    console.log("error")
}
/////////////////////////////////////////////////////