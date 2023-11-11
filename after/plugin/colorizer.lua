-- Use the `default_options` as the second parameter, which uses
-- `foreground` for every mode. 
require 'colorizer'.setup({
	css = {
		hsl_fn = true
	};
	scss = {
		hsl_fn = true
	};
	sass = {
		hsl_fn = true
	};
})
