-- ~/homenix/config/nvim/lua/plugins/smart-save.lua

return {
  {
    -- [1단계] SudaWrite 플러그인 설치 및 즉시 활성화 보장
    "lambdalisue/suda.vim",
    lazy = false, -- [무결성 보강] 다른 환경에서도 켜지자마자 SudaWrite 명령어를 준비합니다.
    config = function()
      -- Suda 기본 도구 설정
      vim.g.suda_command = "sudo"

      -- [2단계] 사용자님의 지능형 저장 로직 (SmartWrite)
      -- 전역 함수로 등록하여 약어(abbreviation)에서 호출 가능하게 만듭니다.
      _G.SmartWrite = function(mode)
        local file = vim.fn.expand("%")
        -- 파일 쓰기 권한이 있으면 일반 저장, 없으면 SudaWrite 호출
        if vim.fn.filewritable(file) == 1 then
          vim.cmd(mode == "wq" and "wq" or "w")
        else
          -- 플러그인이 상단에서 로드되었으므로 안전하게 호출됩니다.
          vim.cmd("SudaWrite")
          if mode == "wq" then
            vim.cmd("q")
          end
        end
      end

      -- [3단계] 무한 루프가 발생하지 않는 안전한 명령줄 약어 설정
      -- 사용자님의 '엔터 시 작동' 의도를 100% 반영하면서도 재귀 호출을 원천 차단합니다.
      vim.cmd([[
        cnoreabbrev <expr> w (getcmdtype() == ':' && getcmdline() == 'w') ? 'lua SmartWrite("w")' : 'w'
        cnoreabbrev <expr> wq (getcmdtype() == ':' && getcmdline() == 'wq') ? 'lua SmartWrite("wq")' : 'wq'
      ]])
    end,
  },
}
