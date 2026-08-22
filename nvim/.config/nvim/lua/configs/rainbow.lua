require('rainbow-delimiters.setup').setup {
  strategy = {
    [''] = 'rainbow-delimiters.strategy.global',
    commonlisp = 'rainbow-delimiters.strategy.local',
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
    latex = 'rainbow-blocks',
    javascript = 'rainbow-delimiters-react',
    c = 'rainbow-delimiters',
    cpp = 'rainbow-delimiters',
    typescript = 'rainbow-delimiters',
    tsx = 'rainbow-delimiters',
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterOrange',
    'RainbowDelimiterYellow',
    'RainbowDelimiterGreen',
    'RainbowDelimiterBlue',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
}
