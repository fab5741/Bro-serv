opened = false

open = function(name) {
	$("#"+name).show();
}

close = function(name) {
	$("#"+name).hide();
}

window.onload = function(e){
	menus = {

	}
	window.addEventListener('message', (event) => {
		switch (event.data.action) {
			case 'setAndOpen': {
				if (event.data.type == "form")
				{
					$("body").append(
						"<form id='"+event.data.name+"'  class='form align-top-right'>"+
						"<div class='head'><span>"+
						event.data.title+
						"</span></div>"+
						"</form>");
						JSON.parse(event.data.items).forEach(function(el) {
							
								if (el.type == "checkbox") {
									$('#'+event.data.name).append(
										"<label>"+
										el.label
										+ "</label><input type='checkbox' id='"+el.name+"' name='"+el.name+"' value='"+el.placeholder+"'>")
								} else {
									$('#'+event.data.name).append(
										"<label>"+
										el.label
										+ "</label><input type='"+el.type+"' id='"+el.name+"' name='"+el.name+"' value='"+el.placeholder+"'>"
										)
								}
							}
						)
						$('#'+event.data.name).append(
							'<input type="submit" value="Submit">')
							
						$('#'+event.data.name).submit(function(e){  
							e.preventDefault();  
							console.log($(this).serializeArray())
							values = $(this).serializeArray()
							var checkboxes = $('#'+event.data.name+' input:checkbox').map(function() {
								return { name: this.name, value: this.checked ? this.value : "false" };
							  });
							fetch(`https://menu/`+event.data.cb, {
								method: 'POST',
								headers: {
									'Content-Type': 'application/json; charset=UTF-8',
								},
								body: JSON.stringify(
									values,
									checkboxes
								)
							}).then($('#'+event.data.name).fadeOut(1000));
						});  
												  
				}
				else {
					$("#menus").append(
						"<div id='"+event.data.name+"'  class='menu align-top-left'>"+
						"<div class='head'><span>"+
						event.data.title+
						"</span></div><div class='menu-items'></div>"+
						"</div>");
							JSON.parse(event.data.items).forEach(el =>$(
							'#'+event.data.name+" .menu-items").append(
							"<div class='menu-item'>"+
							 el.name+
							"</div>")
						)
				}
				open(event.data.name)
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

			case 'delete': {
				$('#'+event.data.name).remove()
			}
		}
	});
};