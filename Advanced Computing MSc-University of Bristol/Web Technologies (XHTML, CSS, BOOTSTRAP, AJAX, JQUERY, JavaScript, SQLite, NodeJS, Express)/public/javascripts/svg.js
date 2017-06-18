window.onload=function(){
	 var s = Snap("#fly");

	 	//Create the paths
	 	var cloud1Path=s.path("M 25 60 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					.attr({id: "cloud1",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud2Path=s.path("M 100 190 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					.attr({id: "cloud2",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud3Path=s.path("M 200 60 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					.attr({id: "cloud3",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });

	 	var cloud4Path=s.path("M 300 190 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					.attr({id: "cloud4",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud5Path=s.path("M 390 60 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					.attr({id: "cloud5",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud6Path=s.path("M 500 190 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					.attr({id: "cloud6",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud7Path=s.path("M 600 60 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					.attr({id: "cloud7",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud8Path=s.path("M 700 190 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					 .attr({id: "cloud8",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud9Path=s.path("M 800 60 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					 .attr({id: "cloud9",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud10Path=s.path("M 900 190 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					 .attr({id: "cloud10",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud11Path=s.path("M 1000 60 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					 .attr({id: "cloud11",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud12Path=s.path("M 1100 190 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					 .attr({id: "cloud12",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 	var cloud13Path=s.path("M 1200 60 a 20,20 1 0,0 0,40 h 50 a 20,20 1 0,0 0,-40 a 10,10 1 0,0 -15,-10 a 15,15 1 0,0 -35,10  z")
	 					 .attr({id: "cloud13",
						    fill: "none",
						    strokeWidth: "4",
						    stroke: "#ffffff",
						    strokeMiterLimit: "10",
						    strokeDasharray: "12 6",
						    strokeDashOffset: "180"
						  });
	 					 //M10 80 C 40 10, 65 10, 95 80 S 150 150, 180 80 M 180 80 400 200 600 80
	 	var planePath=s.path("M 10 158 Q 308 10 626 158 ,913 350 1250 158, 913 20 626 158 M 626 158 623 224")
	 					 .attr({
	 					 	fill:"none",
	 					 	/*stroke:'red',
	 					 	strokeWidth:4*/
	 					 });

	 	var plane = s.image("/svg/package.svg", -20, -60, 100, 100).transform('');
	 	initTriangle();
	 	

	 	function initTriangle(){
   			var triangleGroup = s.g( plane ); // Group polyline 
    		movePoint = planePath.getPointAtLength(length);
   		    triangleGroup.transform( 't' + parseInt(movePoint.x - 15) + ',' + parseInt( movePoint.y - 15) + 'r' + (movePoint.alpha - 90));
  		};
  		var len1 = planePath.getTotalLength();

  		function animateSVG() {
    
			    planePath.animate({"stroke-dashoffset": 10}, 4500,mina.easeinout);
			    
			    var triangleGroup = s.g( plane ); // Group polyline

			    setTimeout( function() {
			      Snap.animate(0, len1, function( value ) {
			   
			        movePoint = planePath.getPointAtLength( value );
			      
			        triangleGroup.transform( 't' + parseInt(movePoint.x - 15) + ',' + parseInt( movePoint.y - 15) + 'r' + (movePoint.alpha - 90));
			    
			      }, 16000,mina.easeinout);
			    });
			    
			  }

			 animateSVG(); 

};

