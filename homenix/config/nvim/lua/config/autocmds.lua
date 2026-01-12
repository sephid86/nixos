-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- ~/.config/nvim/lua/config/autocmds.lua

local dynamic_so_group = vim.api.nvim_create_augroup("DynamicScrolloff", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved", "WinResized", "BufWinEnter" }, {
  group = dynamic_so_group,
  callback = function()
    -- 현재 활성화된 창의 높이를 가져옵니다.
    local win_height = vim.api.nvim_win_get_height(0)
    
    -- [핵심 로직]
    -- 창 높이의 약 40%를 scrolloff로 설정합니다.
    -- 이렇게 하면 상하 40%씩 영역을 차지하고, 중앙 20%가 '프리존'이 됩니다.
    local target_so = math.floor(win_height * 0.4)
    
    -- 현재 scrolloff 값이 목표치와 다를 때만 업데이트하여 성능 부하를 최소화합니다.
    if vim.opt.scrolloff:get() ~= target_so then
      vim.opt.scrolloff = target_so
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    -- 타이틀이 Nvim Socket | 으로 시작하는 창을 찾아 포커스 (가장 짧고 빠름)
    local cmd = "niri msg --json windows | jq -r '.[] | select(.title | startswith(\"Nvim Socket |\")) | .id' | xargs -I {} niri msg action focus-window --id {}"
    
    -- 50ms 딜레이는 타이틀 업데이트가 OS 수준에서 반영될 시간을 벌어줍니다.
    vim.defer_fn(function()
      vim.fn.jobstart(cmd)
    end, 50)
  end,
})
