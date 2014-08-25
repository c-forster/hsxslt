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

    $('.reading').click(function () {

	var $next = $(this).next();

	// If we're not at the last reading
	if ($next.length) {
	    $(this).children().hide();            // Hide Children of Current Reading
	    $(this).hide().next().show();         // Hide Current Reading and Show Next
	    // Now what was hidden is visible. This next line 
	    // ensures the the children of the newly visible 
	    // element (here chiefly the witness sigla) is also 
	    // shown.
	    $(this).children().show();
	}
	else { // We need to start back at the first reading, marked by lemma.
	    $(this).hide(); // Hide current (and it's children, I think...)
//	    $(this).children().hide(); // So this isn't necessary.
	    $(this).parent().find('.lemma').show(); // And show the lemma.
	}
    });


});


/* When you click on a value, it switches in the next value,
  and then appends the old value to the attribute list. */
