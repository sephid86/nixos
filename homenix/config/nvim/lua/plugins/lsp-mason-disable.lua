return {
  -- 1. Mason 핵심 플러그인 비활성화
  { "williamboman/mason.nvim", enabled = false },
  -- 2. LSP 자동 설정 도구 비활성화
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  -- 3. (선택) 포맷터/린터 자동 설치 도구 비활성화
  { "jay-babu/mason-null-ls.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
}
