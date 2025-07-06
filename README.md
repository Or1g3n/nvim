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

- **[Python]( https://www.python.org/downloads/ )**
  ```bash
  pip install pynvim ipykernel
  ```
- **Windows ([Scoop](https://scoop.sh)):**  
  ```bash
  scoop install neovim git zig nodejs ripgrep fd wget unzip gzip mingw make
  ```
- **macOS (Homebrew):**  
  ```bash
  brew install neovim git zig nodejs ripgrep fd wget unzip gzip make
  ```
- **Linux (apt):**  
  ```bash
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt update
  sudo apt install make gcc ripgrep unzip git xclip neovim
  ```

## Setting Up Your Config

You have two options:

1. **Clone the repo to any location, then copy it to your config path:**
    
    > [!Warning]
    > Run these commands from inside the cloned directory!

    - **Windows (cmd):**
        ```bash
        xcopy /E /H /Y . %localappdata%\nvim\
        rd /s /q %localappdata%\nvim\.git
        ```

    - **macOS/Linux:**
        ```bash
        cp -r . "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
        rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim/.git
        ```

2. **Clone the repo directly to your config path:**
 
    - **Windows (cmd):**
        ```bash
        git clone https://github.com/Or1g3n/nvim.git "%localappdata%\nvim"
        rd /s /q "%localappdata%\nvim\.git"
        ```

    - **macOS/Linux:**
        ```bash
        git clone https://github.com/Or1g3n/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
        rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim/.git
        ```

