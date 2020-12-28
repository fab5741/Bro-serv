opened = false

open = function(name) {
	$("#"+name).show();
}

close = function(name) {
	$("#"+name).remove();
	currentmenu = null
	selected = 1
	items = {}
	menuDepth = 0
}

var currentmenu
var selected = 1
var items = {}
var menuDepth = 0

window.onload = function(e){

	window.addEventListener('message', (event) => {
		switch (event.data.action) {
			case 'setAndOpen': {
				if(!currentmenu) {
					if (event.data.type == "progress") {
						$("#progresses").append('<li id="'+event.data.name+'"><progress  class="progress is-info" value="100" max="100"></progress></li>')
					}
					open(event.data.name)
				}

				break;
			}
			case 'delete': {
				$('#'+event.data.name).remove()
			}

			case 'update': {
				if (event.data.type == "progress") {
					$('#'+event.data.name+' progress').val(event.data.value)
				}
			}

			case 'ui': {
				//console.log("UI")
				var item = event.data;
				if (item.display == true) {
					$("#mina").show();
					console.log("starting this shit!");
					var start = new Date();
					var maxTime = item.time;
					var text = item.text;
					var timeoutVal = Math.floor(maxTime/100);
					animateUpdate();

					$('#pbar_innertext').text(text);

					function updateProgress(percentage) {
						$('#pbar_innerdiv').css("width", percentage + "%");
					}

					function animateUpdate() {
						var now = new Date();
						var timeDiff = now.getTime() - start.getTime();
						var perc = Math.round((timeDiff/maxTime)*100);
					//	console.log(perc);
						if (perc <= 100) {
							updateProgress(perc);
							setTimeout(animateUpdate, timeoutVal);
						} else {
							$("#mina").hide();
						}
					}
				} else {
					$("#mina").hide();
				}
			}

		}
	});
};