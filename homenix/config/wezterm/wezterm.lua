-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
config.enable_tab_bar = false 
config.window_background_opacity = 0.85
config.text_background_opacity = 1.0
-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font = wezterm.font("monospace")
config.warn_about_missing_glyphs = false
config.font_size = 14
config.color_scheme = 'Catppuccin Mocha'

-- 창을 닫을 때 뜨는 모든 확인 메시지를 즉시 차단합니다.
config.window_close_confirmation = 'NeverPrompt'

-- Finally, return the configuration to wezterm:
return config
