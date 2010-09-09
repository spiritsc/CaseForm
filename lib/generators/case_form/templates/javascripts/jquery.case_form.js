$(function() {
	$('a[data-action=remove]').live('click', function() {
		var hidden = $(this).prev('input[type=hidden]')[0];
		if (hidden) {
			hidden.value = 'true';
		};
		$(this).closest('.association_inputs').hide();
		return false;
	});
});