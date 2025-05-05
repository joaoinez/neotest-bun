# neotest-bun

Neotest adapter for [Bun](https://bun.sh/) test runner.

Based on [neotest-jest](https://github.com/nvim-neotest/neotest-jest)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'nvim-neotest/neotest',
  requires = {
    ...,
    'arthur944/neotest-bun',
  }
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

## Configuration

There is currently nothing to configure. Test files will be discovered based on these patterns:

- `%.test%.ts$`
- `%.test%.tsx$`
- `%.spec%.ts$`
- `%.spec%.tsx$`
- `%.test%.js$`
- `%.test%.jsx$`
- `%.spec%.js$`
- `%.spec%.jsx$`

The root directory is determined by where a `package.json` file is found. If you have a bunfig.toml file there, it will be used when running tests.

### Running tests in watch mode

That's not suppored right now, PRs welcome.

## Bugs and feature requests

Feel free to raise an issue or reach out to me on [X the everything app](https://x.com/bella_artur)
