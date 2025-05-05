# neotest-bun

Neotest adapter for [Bun](https://bun.sh/) test runner.

Based on [neotest-jest](https://github.com/nvim-neotest/neotest-jest)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "bellaartur/neotest-bun"
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-bun"),
      },
    })
  end,
}
```

Make sure you have the appropriate `treesitter` language parsers installed otherwise no tests will be found:

```
:TSInstall javascript
```

## Usage

See neotest's documentation for more information on how to run tests. Just make sure you have bun installed and in your path.

### Running tests in watch mode

That's not suppored right now, PRs welcome.
