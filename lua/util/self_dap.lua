local M = {}
M.dll = nil
M.tail = nil
M.proj_name = nil
local project_selection = { pending = false, resolved = false, candidate = nil, waiters = {} }

function M.search_for(glob)
  return vim.fn.globpath(vim.fn.getcwd(), glob, false, false)
end

function M.select_execution(glob, project_only)
  if project_only then
    return M.select_project_value(glob, function(candidate)
      return candidate.dll
    end)
  end

  return coroutine.create(function(dap_run_co)
    local items = vim.fn.globpath(vim.fn.getcwd(), glob, false, true)
    local opts = {
      format_item = function(path)
        return vim.fn.fnamemodify(path, ':.')
      end,
    }
    local function cont(choice)
      if choice == nil then
        return nil
      else
        M.dll = choice
        M.tail = vim.fn.fnamemodify(M.dll, ':t:r')
        M.proj_name = vim.fn.fnamemodify(M.search_for('**/' .. M.tail .. '.csproj'), ':p:h')
        coroutine.resume(dap_run_co, choice)
      end
    end

    vim.ui.select(items, opts, cont)
  end)
end

function M.reset_project_selection()
  project_selection = { pending = false, resolved = false, candidate = nil, waiters = {} }
end

function M.with_project_selection(glob, callback)
  if project_selection.resolved then
    callback(project_selection.candidate)
    return
  end

  if project_selection.pending then
    project_selection.waiters[#project_selection.waiters + 1] = callback
    return
  end

  project_selection.pending = true
  project_selection.waiters = { callback }

  local function finish(candidate)
    project_selection.pending = false
    project_selection.resolved = true
    project_selection.candidate = candidate
    if candidate then
      M.dll = candidate.dll
      M.tail = vim.fn.fnamemodify(candidate.dll, ':t:r')
      M.proj_name = candidate.project
    end

    local waiters = project_selection.waiters
    project_selection.waiters = {}
    for _, waiter in ipairs(waiters) do
      waiter(candidate)
    end
  end

  local root = vim.fn.getcwd()
  local projects = vim.fn.globpath(root, '**/*.csproj', false, true)
  local candidates = {}

  for _, project in ipairs(projects) do
    local project_name = vim.fn.fnamemodify(project, ':t:r')
    local project_root = vim.fn.fnamemodify(project, ':p:h')
    local dlls = vim.fn.globpath(project_root, glob, false, true)
    local matching_dlls = {}

    -- Keep only this project's output assembly; ignore dependency DLLs.
    for _, dll in ipairs(dlls) do
      if vim.fn.fnamemodify(dll, ':t:r'):lower() == project_name:lower() then
        matching_dlls[#matching_dlls + 1] = dll
      end
    end

    if #matching_dlls > 0 then
      -- Multi-target projects can produce several copies. Prefer the most
      -- recently built output, with a stable path tie-breaker.
      table.sort(matching_dlls, function(a, b)
        local a_time, b_time = vim.fn.getftime(a), vim.fn.getftime(b)
        if a_time == b_time then
          return a < b
        end
        return a_time > b_time
      end)

      candidates[#candidates + 1] = {
        dll = matching_dlls[1],
        project = project_root,
        project_name = project_name,
        project_relative = vim.fn.fnamemodify(project_root, ':.'):gsub('\\', '/'),
        project_file = vim.fn.fnamemodify(project, ':t'),
      }
    end
  end

  if #candidates == 0 then
    vim.notify('No Debug DLLs associated with a .csproj were found', vim.log.levels.WARN)
    finish(nil)
    return
  end

  vim.ui.select(candidates, {
    prompt = 'Select .NET project',
    format_item = function(candidate)
      return string.format('%s  [%s]', candidate.project_file, candidate.project_relative)
    end,
  }, finish)
end

function M.select_project_value(glob, value_for_project)
  return coroutine.create(function(dap_run_co)
    M.with_project_selection(glob, function(candidate)
      coroutine.resume(dap_run_co, candidate and value_for_project(candidate) or nil)
    end)
  end)
end

function M.get_launch_profiles(project_path)
  local launch_settings_path = project_path .. '/Properties/launchSettings.json'
  local file = io.open(launch_settings_path, 'r')
  if not file then
    return nil
  end

  local content = file:read '*a'
  file:close()

  local ok, parsed = pcall(vim.json.decode, content)
  if not ok or not parsed or not parsed.profiles then
    return nil
  end

  return parsed.profiles
end

local function select_launch_profile(project_path, cb)
  local profiles = M.get_launch_profiles(project_path)

  if profiles == nil then
    vim.notify('No launch profiles found in ' .. project_path .. '/Properties/launchSettings.json', vim.log.levels.WARN)
    cb(nil)
    return
  end

  local profile_names = vim.tbl_keys(profiles)
  if #profile_names == 0 then
    vim.notify('No profiles defined in launchSettings.json', vim.log.levels.WARN)
    cb(nil)
    return
  end

  -- If only one profile, auto-select it
  if #profile_names == 1 then
    local name = profile_names[1]
    cb { name = name, profile = profiles[name] }
    return
  end

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({}, {
      prompt_title = 'Select Launch Profile',
      finder = finders.new_table {
        results = profile_names,
        entry_maker = function(name)
          local profile = profiles[name]
          local display = name
          if profile.applicationUrl then
            display = string.format('%s (%s)', name, profile.applicationUrl)
          end
          return {
            value = { name = name, profile = profile },
            display = display,
            ordinal = name,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            cb(selection.value)
          else
            cb(nil)
          end
        end)
        return true
      end,
    })
    :find()
end

function M.get_environment_variables(project_path, autoselect)
  return coroutine.create(function(dap_run_co)
    local profiles = M.get_launch_profiles(project_path)

    if profiles == nil then
      coroutine.resume(dap_run_co, nil)
      return
    end

    local profile_names = vim.tbl_keys(profiles)
    if #profile_names == 0 then
      coroutine.resume(dap_run_co, nil)
      return
    end

    local function process_profile(selected)
      if selected == nil then
        coroutine.resume(dap_run_co, nil)
        return
      end

      local profile = selected.profile
      local env_vars = profile.environmentVariables or {}

      -- Add ASPNETCORE_URLS from applicationUrl if present
      if profile.applicationUrl then
        env_vars['ASPNETCORE_URLS'] = profile.applicationUrl
        env_vars['DOTNET_URLS'] = profile.applicationUrl
        env_vars['applicationUrl'] = profile.applicationUrl
      end
      if profile.DOTNET_ENVIRONMENT then
        env_vars['DOTNET_ENVIRONMENT'] = profile.DOTNET_ENVIRONMENT
      end
      if profile.ASPNETCORE_ENVIRONMENT then
        env_vars['ASPNETCORE_ENVIRONMENT'] = profile.ASPNETCORE_ENVIRONMENT
      end

      coroutine.resume(dap_run_co, env_vars)
    end

    if autoselect and #profile_names == 1 then
      local name = profile_names[1]
      process_profile { name = name, profile = profiles[name] }
      return
    end

    -- Use the picker
    select_launch_profile(project_path, process_profile)
  end)
end

return M
