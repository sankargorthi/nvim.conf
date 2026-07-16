-- git-worktree.nvim, plus aspen-worktree automation.
--
-- Two Create hooks + one Switch hook + one user command:
--   * `Create` on an aspen worktree — symlink the new Claude Code memory folder to the canonical
--     aspen memory, so a new worktree inherits the consolidated memory set without a manual step.
--   * `Create` on an aspen worktree — symlink host-local TLS certs from the canonical worktree
--     into the new one's `app/.devcontainer/`, so `xroot` from the new worktree can find the TLS
--     material without a manual copy. Certs are gitignored + installed once during on-host
--     onboarding, so a fresh worktree would otherwise fail with "failed to get key file".
--   * `Switch` to an aspen worktree — async-run `app/server/scripts/verify-setup.sh` (from XCRM-446)
--     and notify only if the pre-flight fails. Silent when the setup is clean.
--   * `:AspenVerifySetup` — open the same script in a terminal split for the full interactive
--     report + fix hints, on demand.
--
-- Aspen worktrees are detected by comparing `git rev-parse --git-common-dir` against the aspen bare
-- repo, so the hook is rename-tolerant (works whether the repo dir is still `x-platform.git` or
-- gets renamed later).

local ASPEN_BARE = vim.fn.expand('~/Documents/workspace/x-platform.git')
local CANON_MEMORY = vim.fn.expand('~/.claude/projects/aspen/memory')
local CERT_SOURCE_WORKTREE = vim.fn.expand('~/Documents/workspace/aspen-main')
local HOST_LOCAL_CERTS = {
	'app/.devcontainer/plain.star.veevaxlocal.com.key',
	'app/.devcontainer/star_veevaxlocal_com.chained.crt',
}
local VERIFY_SCRIPT_REL = 'app/server/scripts/verify-setup.sh'

-- True iff `path` is a worktree of the aspen bare repo.
local function is_aspen_worktree(path)
	local cmd = string.format('git -C %q rev-parse --git-common-dir 2>/dev/null', path)
	local common_dir = vim.fn.system(cmd):gsub('%s+$', '')
	if common_dir == '' then
		return false
	end
	local abs = vim.fn.resolve(common_dir)
	-- git-common-dir returns a relative path when the parent is the bare repo; resolve against `path`.
	if abs:sub(1, 1) ~= '/' then
		abs = vim.fn.resolve(path .. '/' .. common_dir)
	end
	return abs == vim.fn.resolve(ASPEN_BARE)
end

-- Slug the Claude Code memory-folder key uses for a given cwd.
local function claude_project_slug(path)
	return path:gsub('[^%w]', '-')
end

-- Symlink the new worktree's Claude memory folder to the canonical aspen memory. No-op if a link
-- already points there. Refuses to overwrite an existing non-empty directory.
local function link_claude_memory(worktree_path)
	local slug = claude_project_slug(worktree_path)
	local project_dir = vim.fn.expand('~/.claude/projects/' .. slug)
	local memory_path = project_dir .. '/memory'

	vim.fn.mkdir(project_dir, 'p')

	local ftype = vim.fn.getftype(memory_path)
	if ftype == 'link' then
		return
	end
	if ftype == 'dir' then
		if vim.fn.glob(memory_path .. '/*') ~= '' then
			vim.notify(
				'aspen worktree memory dir already has content; refusing to symlink automatically: '
					.. memory_path,
				vim.log.levels.WARN
			)
			return
		end
		vim.fn.delete(memory_path, 'd')
	end

	vim.fn.system(string.format('ln -s %q %q', CANON_MEMORY, memory_path))
	vim.notify('Linked Claude memory for aspen worktree: ' .. worktree_path, vim.log.levels.INFO)
end

-- Symlink host-local TLS certs from the canonical source worktree into the target worktree.
-- Idempotent: skips files that are already symlinks; refuses to overwrite regular files (which
-- would indicate the target worktree already ran the on-host onboarding). No-op when the target
-- IS the canonical source (i.e. running against aspen-main itself).
local function link_devcontainer_certs(worktree_path)
	if vim.fn.resolve(worktree_path) == vim.fn.resolve(CERT_SOURCE_WORKTREE) then
		return
	end
	local linked_any = false
	for _, rel in ipairs(HOST_LOCAL_CERTS) do
		local src = CERT_SOURCE_WORKTREE .. '/' .. rel
		local dst = worktree_path .. '/' .. rel
		if vim.fn.filereadable(src) == 0 then
			vim.notify(
				'aspen cert source missing at ' .. src .. '; skipping cert symlinks. '
					.. 'Install certs in the canonical worktree first, per the on-host setup doc.',
				vim.log.levels.WARN
			)
			return
		end
		local ftype = vim.fn.getftype(dst)
		if ftype == 'link' then
			-- already linked; skip silently
		elseif ftype == 'file' then
			vim.notify(
				'aspen worktree already has a regular file at ' .. dst .. '; refusing to overwrite. '
					.. 'Remove it manually if you want the symlink.',
				vim.log.levels.WARN
			)
		else
			vim.fn.mkdir(vim.fn.fnamemodify(dst, ':h'), 'p')
			vim.fn.system(string.format('ln -sfn %q %q', src, dst))
			linked_any = true
		end
	end
	if linked_any then
		vim.notify('Linked aspen host-local certs into ' .. worktree_path, vim.log.levels.INFO)
	end
end

-- Async pre-flight: run verify-setup.sh and notify only if the check fails.
local function verify_aspen_setup(worktree_path)
	local script = worktree_path .. '/' .. VERIFY_SCRIPT_REL
	if vim.fn.filereadable(script) == 0 then
		return -- new worktree without the script yet; silent skip
	end
	vim.fn.jobstart({ 'bash', script }, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_exit = function(_, code)
			vim.schedule(function()
				if code == 0 then
					-- Silent on success; the switch is already noise enough.
				else
					vim.notify(
						'aspen verify-setup: failures detected — :AspenVerifySetup for details',
						vim.log.levels.WARN
					)
				end
			end)
		end,
	})
end

-- Locate the aspen worktree root for the current buffer/cwd. Nil if not inside one.
local function current_aspen_worktree()
	local start = vim.fn.expand('%:p:h')
	if start == '' or start == '.' then
		start = vim.fn.getcwd()
	end
	local root = vim
		.fn.system(string.format('git -C %q rev-parse --show-toplevel 2>/dev/null', start))
		:gsub('%s+$', '')
	if root == '' or not is_aspen_worktree(root) then
		return nil
	end
	return root
end

-- :AspenVerifySetup — open verify-setup.sh in a terminal split for the interactive report.
vim.api.nvim_create_user_command('AspenVerifySetup', function()
	local root = current_aspen_worktree()
	if not root then
		vim.notify('not inside an aspen worktree', vim.log.levels.ERROR)
		return
	end
	local script = root .. '/' .. VERIFY_SCRIPT_REL
	if vim.fn.filereadable(script) == 0 then
		vim.notify('verify-setup.sh not found at ' .. script, vim.log.levels.ERROR)
		return
	end
	vim.cmd('botright 20new')
	vim.fn.termopen({ 'bash', script })
end, { desc = 'Run aspen verify-setup.sh in a terminal split' })

local G = {
	{
		'ThePrimeagen/git-worktree.nvim',
		config = function()
			local wt = require('git-worktree')
			wt.setup()

			wt.on_tree_change(function(op, metadata)
				if not (metadata and metadata.path) then
					return
				end
				if op == wt.Operations.Create and is_aspen_worktree(metadata.path) then
					link_claude_memory(metadata.path)
					link_devcontainer_certs(metadata.path)
				end
				if op == wt.Operations.Switch and is_aspen_worktree(metadata.path) then
					verify_aspen_setup(metadata.path)
				end
			end)
		end,
	},
}

return G
