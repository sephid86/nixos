return {
  {
    "lambdalisue/suda.vim",
    lazy = false,
    config = function()
      vim.g.suda_command = "sudo"
      -- [중요] suda가 자동으로 읽기/쓰기를 가로채지 않도록 설정 (수동 제어 위주)
      vim.g.suda_smart_edit = 1 

      _G.SmartWrite = function(mode)
        local file = vim.fn.expand("%")
        
        -- 1. 파일이 존재하는 경우: 쓰기 권한 직접 체크
        -- 2. 파일이 없는 경우: 부모 디렉토리의 쓰기 권한 체크
        local can_write = false
        if vim.fn.filereadable(file) == 1 then
          can_write = (vim.fn.filewritable(file) == 1)
        else
          local dir = vim.fn.fnamemodify(file, ":h")
          can_write = (vim.fn.filewritable(dir) == 2) -- 2는 디렉토리 쓰기 가능
        end

        -- 권한이 있거나, 특수 버퍼인 경우 일반 저장
        if can_write or file == "" or vim.bo.buftype ~= "" then
          vim.cmd(mode == "wq" and "wq" or "w")
        else
          -- 정말 권한이 없을 때만 SudaWrite
          vim.cmd("SudaWrite")
          if mode == "wq" then
            vim.cmd("q")
          end
        end
      end

      vim.cmd([[
        cnoreabbrev <expr> w (getcmdtype() == ':' && getcmdline() == 'w') ? 'lua SmartWrite("w")' : 'w'
        cnoreabbrev <expr> wq (getcmdtype() == ':' && getcmdline() == 'wq') ? 'lua SmartWrite("wq")' : 'wq'
      ]])
    end,
  },
}
