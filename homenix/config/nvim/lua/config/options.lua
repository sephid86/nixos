-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.scrolloff = 999 
vim.opt.title = true
vim.opt.relativenumber=false
vim.g.autoformat=false

vim.g.ts=2
vim.g.sw=2
vim.g.sts=2

vim.cmd("set fencs=ucs-bom,utf-8,default,euc-kr,cp949")

vim.opt.clipboard = "unnamedplus"
vim.opt.guicursor = ""

if vim.v.servername:find("nvim.sock") then
  vim.opt.title = true
  -- [%t]파일명, [%m]수정표시, [(%p:h)]상대경로 괄호
  -- 결과: NVIM_SERVER | init.lua [+] (~/.config/nvim/lua/config) - NVIM
  vim.opt.titlestring = "Nvim Socket | %t %m (%{fnamemodify(expand('%:p:h'), ':~')}) - NVIM"
end
