$(function(){
    
    // dialog 2 properties
    $('#Dialog1').dialog({
        autoOpen: false,
        show: 'blind',
        hide: 'fold',
		 width: 500,
        closeOnEscape: true
    });

    // dialog 2 open/close
    $('#clustal').click(function() {
        if ($('#Dialog1').dialog('isOpen') == true)
            $('#Dialog1').dialog('close');
        else
            $('#Dialog1').dialog('open');
        return false;
    });
  $('#Dialog2').dialog({
        autoOpen: false,
        show: 'blind',
        hide: 'fold',
		width: 500,
        closeOnEscape: true
    });

    // dialog 2 open/close
    $('#muscle').click(function() {
        if ($('#Dialog2').dialog('isOpen') == true)
            $('#Dialog2').dialog('close');
        else
            $('#Dialog2').dialog('open');
        return false;
    });
	
	
	 $('#Dialog3').dialog({
        autoOpen: false,
        show: 'blind',
        hide: 'fold',
		 width: 600,
        closeOnEscape: true
    });

$("#clustal1, #muscle1").click(function () {
    if ($("#clustal1").is(':checked') == true && $("#muscle1").is(':checked') == true) {
        $("#compare").removeAttr("disabled");
		$('#compare').click(function() {
        if ($('#Dialog3').dialog('isOpen') == true)
            $('#Dialog3').dialog('close');
        else
            $('#Dialog3').dialog('open');
        return false;
    });
		
    } else {
        $("#compare").attr("disabled", "disabled");
    }
});



    
    
});
// JavaScript Document