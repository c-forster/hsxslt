
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

    // This function manages behavior when a "reading is clicked."
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

    // This function manages behavior when a particular textual witness
    // is selected from the textual note. It sets all variants to a source
    // document so that the displayed version reflects a particular historical
    // appearance of the text.
    $('a.textualWitness').click(function (e) {
	// Get the id of the function
	var $witnessID = $(this).attr('id');

	// console.log($witnessID);
	// Reset the text to its lemma-state.
	resetText();

	// Remove any previously visible witness notes.
	$('.witnessNote').remove();

	// Remove the toggles themselves, which would now complicate
	// functionality. They'll return on "RESET."
//	$('#toggles').hide()
	disableVariants();

	// Now set all apps in this poem to that value by:
	// Hiding all lemmas and reading.
	$('span.lemma').hide();
	$('span.reading').hide();

	// Selectively showing the appropriate reading.
	$("span."+$witnessID).show();

	// Hiding the sigla, which here would be superfluous.
	$('span.reading').children('span.sigla').hide();
	
	// Show a message explaining provenance of displayed 
	// text and displaying a link to return to original.
	$('p.verse-container').addClass('witnessDoc');
	var $witnessInfo = $('#bibl'+$witnessID).html();
	var $insertText = "<div id='witnessNote'><p>This is the text of the poem as it appears in: "+$witnessInfo+"</p><p><a href='#' class='reset'>Reset.</a></p></div>";
	// Remove any old witnessNotes
	$('#witnessNote').remove(); 
	// Now append the new note.
	$('#poem-text').append($insertText);
	// Now remove some of the apparatus to prevent confusion.
	$('.toggles').hide();

	// Prevent the default a behavior, which is to follow links 
	// and (therefore) jump to the top of page.
	e.preventDefault();
    });

    // JS for tooltip
    $("span.help").hover(function () {
	var tooltipText = $(this).attr('data-tip');
	$(this).append('<div class="tooltip"><p>'+tooltipText+'</p></div>');
    }, function () {
	$("div.tooltip").remove();
    });

    // JS to close tooltip; for mobile.
    $("div.tooltip").click(function () {
	$(this).remove();
    });


});

// Reset to condition when first loaded.
$(document.body).on('click', '.reset', function (e) {
    resetText();

    // Prevent the default a behavior, which is to follow links 
    // and (therefore) jump to the top of page.
    e.preventDefault();
});


// This function resets the poem to standard condition.
var resetText = function () {
    console.log('reset');

    $('#witnessNote').remove(); 

    // Remove any highlighting/coloring.
    $('span.apparatus').removeClass('highlight');

    // Paradoxically, we need to show siglas here, so that they 
    // will disappear/reappear with their parent spans.
    $('span.reading').children('span.sigla').show();

    // Hide alternate readings and show lemmas.
    $('span.reading').hide();
    $('span.lemma').show();


    // Re-enable highlighting of variants.
    $('input#highlightVariants').prop('disabled', false);
};

var disableVariants = function () {
    console.log('Disable Toggles');

    // Ensure variants checkbox is unchecked.
    $('input#highlightVariants').prop('checked', false);    

    // Prevent highlighting of variants until we've reset the text to its 
    // lemma-state.
    $('input#highlightVariants').prop('disabled', true);
}



