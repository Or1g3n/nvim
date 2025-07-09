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
  pip install pynvim ipykernel jupytext
  ```
- **Windows ([Scoop](https://scoop.sh)):**  
  ```bash
  scoop install neovim git zig nodejs ripgrep fd wget unzip gzip mingw make nu
  ```
- **macOS (Homebrew):**  
  ```bash
  brew install neovim git zig nodejs ripgrep fd wget unzip gzip make nushell
  ```
- **Linux (apt):**  
  ```bash
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  ```
  ```bash
  curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
  ```
  ```bash
  echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list
  ```
  ```bash
  sudo apt update
  ```
  ```bash
  sudo apt install make gcc ripgrep unzip git xclip neovim nushell
  ```
- [Nerd Font](https://www.nerdfonts.com)

   **💡 Note:** Make sure you choose a `Mono` font

    - To get the best visual experience, install a Nerd Font of your choice and set as your terminal font
    - Personal recommendations:
        - JetBrainsMono Nerd Font
        - Fira Code Nerd Font

## Setting Up Your Config

You have two options:

1. **Clone the repo to any location, then copy it to your config path:**

   **💡 Note:** Run these commands from inside the cloned directory!

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

## Getting started

- **Neovim Tutor**

    If you are new to neovim, I highly recommend learning/practicing vim fundementals using Tutor mode. To activate, run the following in command mode:

   **💡 Note:** To enter command mode, press `:` from normal mode.

    ```vim
    :Tutor
    ```

- **Important Key Maps**

    **💡 Note:** To fuzzy find all available keymaps, press `<Leader>sk`.

    **💡 Note:** For non-plugin specific keymaps, see `nvim/lua/Or1g3n/core/keymaps.lua`. For plugin specific keymaps see the corresponding plugin.lua file found in `nvim/lua/Or1g3n/plugins`.

    **💡 Note:** The below is NOT exhaustive but a highlight of common actions.

    - Keymaps and Help search
        | Keymap | Description | 
        | -------------- | -------------- |
        | `<Leader>sk` | Open keymaps fuzzy finder |
        | `<Leader>sh` | Open help doc search |

    - Terminal
        | Keymap | Description | 
        | -------------- | -------------- |
        | `<Leader>t` | Toggle floating terminal |
        | `<Esc><Esc>` | Enter normal mode |

    - File explore/search
        | Keymap | Description | 
        | -------------- | -------------- |
        | `<Leader>e` | Open file explorer |
        | `<Leader><Leader>` | Open file fuzzy finder |
        | `<Leader>fc` | Open config file fuzzy finder |

    - Buffer management
        | Keymap | Description | 
        | -------------- | -------------- |
        | `<Leader>w` | Save buffer |
        | `<Leader>bd` | Close buffer |
        | `<Leader>q` | Force quit buffer |
        | `<A-h>` | Resize window left |
        | `<A-l>` | Resize window right |
        | `<A-j>` | Resize window down |
        | `<A-k>` | Resize window up |
        | `<A-=>` | Resize equally |

    - Buffer navigation
        | Keymap | Description | 
        | -------------- | -------------- |
        | `<C-h>` | Move focus left |
        | `<C-l>` | Move focus right |
        | `<C-j>` | Move focus down |
        | `<C-k>` | Move focus up |
        | `<Leader>h` | Move window left |
        | `<Leader>l` | Move window right |
        | `<Leader>k` | Move window up |
        | `<Leader>j` | Move window down |

- **Optimized jupyter notebook experience**
    - **jupytext**
        - Add jupytext.toml to your home directory with below settings
            ```toml
            # ~/jupytext.toml
            notebook_metadata_filter="-all"
            cell_metadata_filter="-all"
            ```
    - **To initializing a new notebook, run the following in command mode:**

       **💡 Note:** To enter command mode, press `:` from normal mode.

        ```vim
        :NewNoteBook note_book_name
        ```

    - **`Ctrl+Enter` and `Shift+Enter` keymaps will work as expected within a notebook**
        - If your terminal does not support those inputs, then `<Leader>xc` and `<Leader>xb` will perform the same behavior respectively
        - Workaround for Windows Terminal
            - Add the following to your Windows Terminal settings.json config file:
            ```json
            "actions": 
            [
                {
                    "command": 
                    {
                        "action": "sendInput",
                        "input": "\u001b[13;5u"
                    },
                    "id": "User.sendInput.F8A79DCB"
                },
                {
                    "command": 
                    {
                        "action": "sendInput",
                        "input": "\u001b[13;2u"
                    },
                    "id": "User.sendInput.8882FD6D"
                }
            ],
            ```
        - For all notebook cell related keymaps, open the keymap fuzzy finder, `<Leader>sk`, and search "Quarto"

- **Client specific customizations**

    This configuration allows adding client specific customizations via files added to the local folder (.gitignore in the root config directory excludes this folder). The idea here is that certain configurations such as bookmarks, llm api keys/adapters, or project directories are specific to certain machine and should not be included in git history.

    Below highlights the required local directory structure and the currently supported plugin customizations.

    ```bash
    nvim/
    | after/
    | lua/
    | | Or1g3n/
    | | | plugins/
    | | | | local/
    | | | | | alpha/
    | | | | | | greeting.lua
    | | | | | | messages.lua
    | | | | | codecompanion/
    | | | | | | custom_adapter.lua
    | | | | | minifiles/
    | | | | | | bookmarks.lua
    | | | | | pyproject_selector/
    | | | | | | pyprojects.lua
    ```

    - alpha (Neovim dashboard plugin)
        - To customize dashboard greeting, default is `Welcome to Neovim!`. Add the following `greeting.lua` to the local/alpha directory (create if it doesn't exist).
            ```lua
            -- nvim/lua/Or1g3n/plugins/local/alpha/greeting.lua
            return "My custom greeting!"
            ```

        - To customize dashboard random message, default is `Make it a great day`. Add the following `messages.lua` to the local/alpha directory (create if it doesn't exist).
            ```lua
            -- nvim/lua/Or1g3n/plugins/local/alpha/messages.lua.lua
            return {
                { message = "Random Message 1" },
                { message = "Random Message 2" },
            }
            ```

    - mini.files (File Explorer)
        - To customize mini.files bookmarks. Add the following `bookmarks.lua` to the local/minifiles directory (create if it doesn't exist).
            ```lua
            -- nvim/lua/Or1g3n/plugins/local/minifiles/bookmarks.lua
            return {
                { id = "r", path = "~/repos", desc = "Repos directory" },
                { id = "p", path = "~/Python", desc = "Python directory" },
            }
            ```

    - pyproject_selector (Python Project Selector)
        - To customize pyproject_selector picker. Add the following `pyprojects.lua` to the local/pyproject_selector directory (create if it doesn't exist).
        - To activate the picker, press `<Leader>pp`.
        - Selecting a project will automatically set the working directory to `dir` and activate the python virtual environment specified by `venv`.
            ```lua
            -- nvim/lua/Or1g3n/plugins/local/pyproject_selector/pyprojects.lua
            return {
                {
                    name = "project_1",
                    dir  = "C:/Users/MyUser/repos/project_1",
                    venv = "C:/Users/MyUser/repos/project_1/.venv",
                },
                name = "project_2",
                dir  = "C:/Users/MyUser/repos/project_2",
                venv = "C:/Users/MyUser/repos/project_2/.venv",
            },
            }
            ```

    - codecompanion (LLM Agent)
        - To add custom codecompanion LLM adapters. Add the following `custom_adapter.lua` to the local/codecompanion directory (create if it doesn't exist).
        - Note, the below is an example and should be updated with your specific requirements. To complete the configuration, update the codecompanion config file found at `nvim/lua/Or1g3n/plugins/codecompanion.lua`.
            ```lua
            -- nvim/lua/Or1g3n/plugins/local/codecompanion/custom_adapter.lua
            -- 
            local M = {}

            M.config = {
                env = {
                    url             = "https://myllm.url.com",
                    api_key         = "my_api_key",
                    chat_url        = "/v1/chat/completions",
                    models_endpoint = "/v1/models",
                },
                schema = {
                    model = {
                        default = "mistralai/Pixtral-12B-2409",
                    },
                },
            }

            return M
            ```

