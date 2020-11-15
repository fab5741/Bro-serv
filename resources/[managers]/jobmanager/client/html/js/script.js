
$(document).ready(function(){	
send = false	
	window.addEventListener('message', (event) => {
		if(event.data.action == "setAndOpen"){
			$(".header").append(event.data.title);
			$(".subheader").append(event.data.subtitle);

			for(let i = 0; i < event.data.buttons.length; i++){
				let li = $("<li>").append(event.data.buttons[i].name).addClass("item").attr("function", event.data.buttons[i].func).attr("params", event.data.buttons[i].params);
				if(i == 0) {
					li.addClass("active");
				}
				$(".list").append(li);
			}

			var count = $("ul").children().length;
			if (count > 10) {
				$(".scroll").show();
			} else {
				$(".scroll").hide();
			} 

			$(".menu").show();
		}
		
		if(event.data.action == "close"){
			$(".menu").hide();
			$(".list").empty();
			$(".header").empty();
			$(".subheader").empty();
		}
		
		if(event.data.action == "keyup"){
			if($(".item").length > 1) {
				let active = $(".active").removeClass("active");
			
				if(active.prev().length != 0 && active.prev().css("display") == "none"){
					$(".list").find(".item:visible:last").hide();
					active.prev().show();
				}
				
				if(active.prev().length == 0) {
					active.siblings().last().addClass("active");
					$(".item").hide();
					$(".item").slice(-10).show();
				} else {
					active.prev().addClass("active");
				}
			}
		}
		
		if(event.data.action == "keydown") {
			if($(".item").length > 1) {
				let active = $(".active").removeClass("active");
			
				if(active.next().length != 0 && active.next().css("display") == "none"){
					$(".list").find(".item:visible:first").hide();
					active.next().show();
				}
				
				if(active.next().length == 0) {
					active.siblings().first().addClass("active");
					$(".item").hide();
					$(".item").slice(0, 10).show();
				} else {
					active.next().addClass("active");
				}
			}
		}
		
		if(event.data.action == "keyenter"){
			let action = $(".active").attr("function");
			let params = $(".active").attr("params");
			$.post('http://jobmanager/sendAction', JSON.stringify({
				 action: action,
				 params: params
			}));
		}

		if(event.data.action == "openAmount"){
			$('#amount').show()
			amount = true
			withdraw = event.data.withdraw
		}

		$(document).on('keypress',function(e) {
			if(e.which == 13 && !send && amount) {
				send = true
				amount = false
				$.post('http://jobmanager/amount', JSON.stringify({
					amount: $('#amount').val(),
					withdraw: withdraw

			   }));

			}
		});
	});
});