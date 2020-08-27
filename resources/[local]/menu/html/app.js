opened = false

open = function() {
	$(".menu").show();
}

close = function() {
	$(".menu").hide();
}

window.onload = function(e){
	menus = {

	}
	window.addEventListener('message', (event) => {
		switch (event.data.type) {
			case 'open': {
				open()
				break;
			}
	
			case 'close': {
				close()
				break;
			}

			case 'createMenu': {
				/*menus[menus.length+1] = {
					"text": event.data.text,
				}*/
				$("#menus").append(
				"<div id='menu'  class='menu align-top-left'>"+
				"<div class='head'><span>"+
				event.data.text+
				"</span></div>"+
				"</div>");
				$(".menu").hide();
				break;
			}

			case 'createMenuLine': {
				/*menus[menus.length].menuItems[menus[menus.length+1].menuItems.length] = {
					"text": event.data.text,
				}*/
				$('#menu').append(
					"<div class='menu-items'>"+
					"<div class='menu-item'>"+
					 event.data.text+
					"</div>"+
					"</div>")
					$(".menu").hide();
					break;
			}

			case 'controlPressed': {
				switch (data.control) {

					case 'ENTER': {
						break;
					}

					case 'TOP': {
						break;
					}

					case 'DOWN': {
						break;
					}

					case 'LEFT': {
						break;
					}

					case 'RIGHT': {
					
						break;
					}
				}
			}
		}
	});
};