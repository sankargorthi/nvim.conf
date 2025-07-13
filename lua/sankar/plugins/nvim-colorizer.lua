local C = {
	-- UI Language plugins
	{
		'catgoose/nvim-colorizer.lua',
		config = function()
			require 'colorizer'.setup({
				filetypes = { 'scss', 'css' },
				lazy_load = true,
				user_default_options = {
					names = false
				},
				css = {
					hsl_fn = true
				},
				scss = {
					hsl_fn = true
				},
				sass = {
					enable = true,
					hsl_fn = true
				},
			})
			-- All of these settings don't seem to work for colorizing hsl values
		end
	},
}
return C
