// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
  $('#appstats-date-showhide').click(function () {
    $('#appstats-date-filter').toggle();
  });
});

/*                RENDER SAMPLE GRAPH              */
$(function() { $.ajax({
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
});

function draw(data) {
	console.log(data);
	var svg = d3.select("#genGraph"),
	    margin = {top: 20, right: 20, bottom: 20, left: 20},
	    width = +svg.attr("width") - margin.left - margin.right,
	    height = +svg.attr("height") - margin.top - margin.bottom
	    labelWidth = 100;

	var x = d3.scaleLinear().rangeRound([0, width - margin.left - margin.right - labelWidth]),
	    y = d3.scaleLinear().rangeRound([0, height - margin.top - margin.bottom - 26])
	    yL = d3.scaleLinear().rangeRound([0, height - margin.top - margin.bottom]);

	var g = svg.append("g")
	    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	  x.domain([0, d3.max(data, function(d) { return d.clickcount; })]);
	  y.domain([0, d3.max(data, function(d , i) { return i; })]);

	 g.append("g")
	   .attr("class", "axis axis--x")
	   .attr("transform", "translate(" + labelWidth + ",50)")
	   .call(d3.axisTop(x).ticks( d3.max(data, function(d) { return d.clickcount; })) );

	g.append("g")
	  .attr("class", "axis axis--y")
	  .attr("transform", "translate(" + labelWidth + ",50)")
      .call(d3.axisLeft(yL).ticks(0));

	g.append("g")
	  .attr("class" , "data bars")
	  .attr("transform", "translate(" + (labelWidth+2) + ",52)")
	  .selectAll(".bar")
	  .data(data)
	  .enter().append("rect")
	  .attr("class", "bar")
	  .attr("x", 0 )
	  .attr("y", function(d , i) { return y(i); })
	  .attr("width", function(d) { return x(d.clickcount); })
	  .attr("height", 25 );

	g.append("g")
	  .attr("class" , "labels labels--x")
	  .attr("transform", "translate(" + (width/2 - 14) + ",30)")
	  .append("text")
	  .text("Click Count");

	g.append("g")
	  .attr("class" , "labels labels--y")
	  .attr("transform", "translate(0,50)")
	  .selectAll(".label")
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