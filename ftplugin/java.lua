-- Find the closest gradlew path and use that as the workspace_dir
local function find_project_root()
	local current_dir = vim.fn.getcwd()
	local gradlew_path = vim.fn.findfile('gradlew', current_dir .. ';')

	if gradlew_path ~= '' then
		-- Extract the directory containing gradlew
		return vim.fn.fnamemodify(gradlew_path, ':p:h')
	end

	return nil -- gradlew not found
end

local rootDirFound = vim.fs.root(0, {".git", "mvnw", "gradlew"})

print("Starting a java repo", rootDirFound)

local config = {
	cmd = {
		-- The command that starts the language server
		-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
		'java',
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xmx1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',

		'-jar', '/opt/homebrew/Cellar/jdtls/1.43.0/libexec/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
		'-configuration', '/opt/homebrew/Cellar/jdtls/1.43.0/libexec/config_mac_arm',

		'-data', find_project_root()
	},

	root_dir = rootDirFound
}
require('jdtls').start_or_attach(config)
