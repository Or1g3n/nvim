# nvim

This is my custom Neovim configuration, designed with love and optimized for productivity. :heart:

## Design Philosophy

- **Maximize functionality, minimize bloat**: Focus on essential features and performance.
- **Leverage native Neovim capabilities**: Before introducing plugins, I check if the desired functionality can be achieved using built-in Neovim commands.
- **Organized keymaps**: Every keymap is categorized with a brief description and a pretext header for easy fuzzy finding. Commands are grouped logically for efficiency.
- **Mnemonic-friendly keymaps**: Keybindings are intuitive, following familiar patterns where possible to enhance usability and reduce cognitive load.
- **Eye-catching, comfortable themes**: A killer set of themes that are easy on the eyes and a joy to work in.
- **Must be better than VS Code**: Because well...

## Requirements

- [Python]( https://www.python.org/downloads/ )
    ```bash
    pip install pynvim ipykernel
    ```
- zig  
    - **Windows (Scoop):**  
      ```powershell
      scoop install zig
      ```
    - **macOS (Homebrew):**  
      ```bash
      brew install zig
      ```
    - **Linux (apt):**  
      ```bash
      sudo apt install zig
      ```
- nodejs  
    - **Windows (Scoop):**  
      ```powershell
      scoop install nodejs
      ```
    - **macOS (Homebrew):**  
      ```bash
      brew install node
      ```
    - **Linux (apt):**  
      ```bash
      sudo apt install nodejs
