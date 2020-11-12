var prices = {}
var maxes = {}
var zone = null

// Partial Functions
function closeMain() {
	$("body").css("display", "none");
}
function openMain() {
	$("body").css("display", "block");
}
function closeAll() {
	$(".body").css("display", "none");
}
$(".close").click(function(){
    $.post('http://brocoli_shop/quit', JSON.stringify({}));
});
// Listen for NUI Events
window.addEventListener('message', function (event) {

	var item = event.data;

	// Open & Close main window
	if (item.message == "show") {
		if (item.clear == true){
			$( ".body" ).empty();
			prices = {}
			maxes = {}
			zone = null
		}
		openMain();
	}

	if (item.message == "hide") {
		closeMain();
	}

	if (item.message=="add"){
		$(".card-container").append('<div class="card">'+
			'<div class="card-image">'+
			'<figure class="image is-4by3">'+
			'<img src="img/'+item.item+'.png" alt="Placeholder image">'+
			'</figure>'+
			'</div>'+
			'<div class="card-content has-text-centered">'+
			'<h2>'+item.label+'</h2>'+
			'<h2>'+item.price+' $'+'</h2>'+
			'<div>'+
			'<input class="input is-small" type="text" name="name" placeholder="Quantity">'+
			'</div>'+
			'<button class="button is-success" name="' + item.item + '">Buy</button>'+
			'</div>'+
			'</div>');
			prices[item.item] = item.price;
			maxes[item.item] = 99;
			zone = item.loc;
	 }


});