local M = {}
M.dll = nil
M.tail = nil
M.proj_name = nil

function M.search_for(glob)
  return vim.fn.globpath(vim.fn.getcwd(), glob, false, false)
end

function M.select_execution(glob)
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
