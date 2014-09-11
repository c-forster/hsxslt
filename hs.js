$(document).ready(function(){

    // This function manages the checkbox toggles.
    $('input[type="checkbox"]').click(function(){
	var id = $(this).attr("id");

	id = id.replace('CheckBox','')
	console.log(id);

	// This is for toggling notes.
        if(id.indexOf('editorialNotes')>0) {
            $('#' + id).toggle();
	    $('.'+id+'Fn').toggle();
        }

	// This is for showing/hiding apparatus.
        if(id=='highlightVariants') {
	    $('span.apparatus').toggleClass('highlight');

	    // And let's ensure that lemmas are visible and alternate
	    // readings are not.
	    $('span.reading').hide();
	    $('span.lemma').show();
	    $('span.lemma.empty-lemma').show();
        }

    });


    // Thsi function manages behavior when a "reading is clicked."
    // The first 'if' ensures that the behavior is only activated 
    // when the checkbox is checked, to present folks from unintentionally 
    // cycling alternate readings.
    $('.reading').click(function () {

	var $next = $(this).next();

	if($('#highlightVariants').is(':checked')) {

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
	}
    });

});

