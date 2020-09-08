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
					else if (event.data.type == "progress") {
						$("#progresses").append('<li id="'+event.data.name+'"><progress  "class="progress" value="100" max="100"></progress></li<')
					}
					else {
						$("#menus").append(
							"<aside id='"+event.data.name+"'  class='menu "+event.data.position+"'>"+
							"<p class='menu-label'>"+
							event.data.title+
							"</p><ul class='menu-list'></ul>"+
							"</aside>");
								JSON.parse(event.data.items).forEach(el =>$(
								'#'+event.data.name+" .menu-list").append(
								"<li><a>"+
								 el.label+
								"</a></li>")
							)
							selected = 1
							$('#'+event.data.name+" .menu-list li:nth-child("+selected+") a").addClass("is-active")
							items = JSON.parse(event.data.items)
					}
					currentmenu = event.data.name
					open(event.data.name)
				}

				break;
			}
			case 'delete': {
				console.log("delete")
				$('#'+event.data.name).remove()
			}

			case 'update': {
				console.log("update")

				if (event.data.type == "progress") {
					$('#'+event.data.name+' progress').val(event.data.value)
				}
			}

			case 'controlPressed': {
				console.log(event.data.control)

				switch (event.data.control) {
					case 'TOP': {
						if(selected > 1 && currentmenu) {
							$('#'+event.data.name+" .menu-list li:nth-child("+selected+") a").removeClass("is-active")
							selected = selected - 1
							$('#'+event.data.name+" .menu-list li:nth-child("+selected+") a").addClass("is-active")	
						}
						break;
					}

					case 'DOWN': {
						if(selected < Object.keys(items).length && currentmenu) {
							$('#'+event.data.name+" .menu-list li:nth-child("+selected+") a").removeClass("is-active")
							selected = selected + 1
							$('#'+event.data.name+" .menu-list li:nth-child("+selected+") a").addClass("is-active")	
						}
						break;
					}
					
					case 'ENTER': {
						if(items[selected-1].items){
							console.log('#'+event.data.name+" .menu-list li")
							$('#'+event.data.name+" .menu-list li").remove()
							items[selected-1].items.forEach(el =>$('#'+event.data.name+" .menu-list").append(
								"<li><a>"+
								 el.label+
								"</a></li>")
							)
							selected = 1
							$('#'+event.data.name+" .menu-list li:nth-child("+selected+") a").addClass("is-active")	
							menuDepth = menuDepth + 1
						} else {
							console.log(items[selected-1].action)
						}
						break;
					}
					case 'BACKSPACE': {
						if(menuDepth == 1) {
							$('#'+event.data.name+" .menu-list li").remove()
							items.forEach(el =>$('#'+event.data.name+" .menu-list").append(
								"<li><a>"+
								 el.label+
								"</a></li>")
							)
							selected = 1
							$('#'+event.data.name+" .menu-list li:nth-child("+selected+") a").addClass("is-active")	
			
							menuDepth = 0
						} else {
							close(event.data.name)
						}
						break;
					}
				}
			}

		}
	});
};