function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

function _G.merge_tables(target, tbl)
  for k, v in pairs(tbl) do
    target[k] = v
  end
end

function _G.dump(...)
	local objects = vim.tbl_map(vim.inspect, { ... })
	print(unpack(objects))
end