$(window).ready(function () {
	window.addEventListener('message', function (event) {
		let data = event.data;

		if (data.showMenu) {
			$('#container').fadeIn();
			$('#menu').fadeIn();
		} else if (data.hideAll) {
			$('#container').fadeOut();
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27) {
			$.post('http://shops/escape', '{}');
		}
	};

	$('#container').hide();

	$('#deposit_btn').on('click', function () {
		$.post('http://shops/buy', JSON.stringify({
			amount: $('#amount').val(),
			type: $('#type').val()
		}));

		$('#amount').val(0);
	})

	$('#deposit_amount').on("keyup", function (e) {
		if (e.keyCode == 13) {
			$.post('http://shops/buy', JSON.stringify({
				amount: $('#amount').val(),
				type: $('#type').val()
			}));
	
			$('#amount').val(0);
		}
	});
});
