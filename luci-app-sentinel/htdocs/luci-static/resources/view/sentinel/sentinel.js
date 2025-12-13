'use strict';
'require view';

return view.extend({
	render: function () {
		return E('div', { class: 'cbi-map' }, [
			E('h2', _('Sentinel')),
			E('p', _('Sentinel service is installed.')),
			E('p', _('This LuCI page is a minimal entry point, similar to podkop.')),
			E('p', _('Advanced configuration will be added later.'))
		]);
	}
});
