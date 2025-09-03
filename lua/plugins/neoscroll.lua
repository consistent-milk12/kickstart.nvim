-- Enhanced smooth scrolling with neoscroll.nvim
-- Provides butter-smooth scrolling animations for better UX
return {
  'karb94/neoscroll.nvim',
  event = 'VeryLazy',
  opts = {
    -- Performance settings
    performance_mode = false, -- Enable for slower machines
    easing_function = 'quadratic', -- Smooth easing curve

    -- Timing configuration
    mappings = {
      '<C-u>',
      '<C-d>',
      '<C-b>',
      '<C-f>',
      '<C-y>',
      '<C-e>',
      'zt',
      'zz',
      'zb',
    },

    -- Hide cursor during animation for cleaner look
    hide_cursor = true,

    -- Stop animation on any key press
    stop_eof = true,

    -- Respect scroll off
    respect_scrolloff = false,

    -- Cursor scrolling
    cursor_scrolls_alone = true,

    -- Default easing function
    easing = 'linear',

    -- Pre-hook for custom behavior
    pre_hook = nil,

    -- Post-hook for custom behavior
    post_hook = nil,

    -- Custom step size
    step_eof = 50,
  },
}

