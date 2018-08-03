$(document).ready(function(){
	$("#contactForm").submit(function(e){
		$.post("/_resources/php/email.php", { name: $("#name").val(), email: $("#email").val(), "message": $("#message").val() }).done(function( data ){ $("#success").html(data); });
		$('#contactForm')[0].reset();
		e.preventDefault();
	});
});