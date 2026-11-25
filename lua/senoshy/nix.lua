-- Plugin loader for Nix-managed mode.
--
-- In this mode every plugin is already on the packpath (see neovim.nix), so
-- this only runs each plugin module's `config`. Modules are discovered from
-- `lua/senoshy/plugins/` on the runtimepath, the same way lazy.nvim imports
-- them, so adding a plugin needs no change here.
--
-- A module is configured at startup unless it declares `event` or `ft`, in
-- which case it is configured the first time that trigger fires. `keys` are
-- always mapped immediately; using one configures the module first. `cmd`
-- needs no handling because the plugin (and its command) is already loaded.

local M = {}

local configured = {}
local group = vim.api.nvim_create_augroup("SenoshyPlugins", { clear = true })

local function list(v)
    if v == nil then
        return {}
    end
    return type(v) == "table" and v or { v }
end

-- lazy.nvim style: a spec without `config` but with `opts` is configured by
-- calling `require(main).setup(opts)`. `main` defaults to the repo name with
-- any `.nvim`/`.lua` suffix stripped (e.g. "vyfor/cord.nvim" -> "cord").
local function main_module(name, spec)
    if spec.main then
        return spec.main
    end
    if type(spec[1]) == "string" then
        local base = spec[1]:match("([^/]+)$") or spec[1]
        return (base:gsub("%.nvim$", ""):gsub("%.lua$", ""))
    end
    return name
end

local function configure(name, spec)
    if configured[name] then
        return
    end
    configured[name] = true

    local ok, err
    if type(spec.config) == "function" then
        ok, err = pcall(spec.config, spec, spec.opts or {})
    elseif spec.config == true or spec.opts ~= nil then
        local mod_name = main_module(name, spec)
        local loaded, mod = pcall(require, mod_name)
        if not loaded then
            ok, err = false, ("cannot require %q: %s"):format(mod_name, mod)
        elseif type(mod.setup) == "function" then
            ok, err = pcall(mod.setup, spec.opts or {})
        end
    else
        return
    end

    if ok == false then
        vim.notify(("senoshy: %s config failed: %s"):format(name, err), vim.log.levels.ERROR)
    end
end

local function dispatch(rhs)
    if type(rhs) == "function" then
        rhs()
    elseif type(rhs) == "string" and rhs:match("^<[Cc]md>") then
        vim.cmd((rhs:gsub("^<[Cc]md>", ""):gsub("<CR>$", "")))
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(rhs, true, false, true), "m", false)
    end
end

local function map_keys(name, spec)
    for _, key in ipairs(spec.keys or {}) do
        local lhs, rhs = key[1], key[2]
        if lhs and rhs then
            vim.keymap.set(key.mode or "n", lhs, function()
                configure(name, spec)
                dispatch(rhs)
            end, {
                desc = key.desc,
                silent = key.silent ~= false,
                noremap = key.noremap ~= false,
                nowait = key.nowait,
            })
        end
    end
end

local function on(events, pattern, name, spec)
    vim.api.nvim_create_autocmd(events, {
        group = group,
        pattern = pattern,
        once = true,
        callback = function()
            configure(name, spec)
        end,
    })
end

-- Registers the module's triggers. Returns true if it wants to be lazy.
-- mimics lazy load
local function defer(name, spec)
    local deferred = false

    for _, event in ipairs(list(spec.event)) do
        deferred = true
        if event == "VeryLazy" then
            on("VimEnter", nil, name, spec)
        else
            on(event, nil, name, spec)
        end
    end

    for _, ft in ipairs(list(spec.ft)) do
        deferred = true
        on("FileType", ft, name, spec)
    end

    return deferred
end

-- One entry per module name, even if the runtimepath holds two copies of the
-- config (a local checkout shadowing the installed one, for example).
local function modules()
    local found, seen = {}, {}
    for _, file in ipairs(vim.api.nvim_get_runtime_file("lua/senoshy/plugins/*.lua", true)) do
        local name = vim.fn.fnamemodify(file, ":t:r")
        if not seen[name] then
            seen[name] = true
            local ok, spec = pcall(require, "senoshy.plugins." .. name)
            if not ok then
                vim.notify(("senoshy: %s failed to load: %s"):format(name, spec), vim.log.levels.ERROR)
            elseif type(spec) == "table" then
                found[#found + 1] = { name = name, spec = spec }
            end
        end
    end

    table.sort(found, function(a, b)
        local pa, pb = a.spec.priority or 0, b.spec.priority or 0
        if pa ~= pb then
            return pa > pb
        end
        return a.name < b.name
    end)

    return found
end

function M.load_config()
    for _, entry in ipairs(modules()) do
        map_keys(entry.name, entry.spec)
        if entry.spec.lazy == false or not defer(entry.name, entry.spec) then
            configure(entry.name, entry.spec)
        end
    end
end

M.load_config()

return M
