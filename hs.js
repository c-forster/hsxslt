$(document).ready(function(){
    $('input[type="checkbox"]').click(function(){
	var id = $(this).attr("id");

	id = id.replace('CheckBox','')
	console.log(id);

        if($(this).attr("type")=="checkbox"){
            $('#' + id).toggle();
	    $('.'+id+'Fn').toggle();	    
        }
    });
});
