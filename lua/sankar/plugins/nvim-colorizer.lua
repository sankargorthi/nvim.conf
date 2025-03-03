local C = {
	-- UI Language plugins
	{
		'catgoose/nvim-colorizer.lua',
		config = function()
			require 'colorizer'.setup({
				css = {
					hsl_fn = true
				},
				scss = {
					hsl_fn = true
				},
				sass = {
					hsl_fn = true
				},
			})
			-- All of these settings don't seem to work for colorizing hsl values
		end
	},
}
return C
