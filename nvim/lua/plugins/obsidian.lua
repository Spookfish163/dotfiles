-- Obsidian nvim
return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = false,
    ft = "markdown",
    opts = {
        legacy_commands = false,
        workspaces = {
            {
                name = "Personal",
                path = "~/Documents/syncing_folder/Obsidian_Vaults/Personal/",
            },
        },
        daily_notes = {
            folder = "Daily Notes",
            date_format = "%Y-%m-%d",
            alias_format = "%B %-d, %Y",
        },
        completion = {
            nvim_cmp = false,
            blink = true,
            min_chars = 2,
        },
        notes_subdir = "Brain",
        new_notes_location = "current_dir",

        -- Simple note ID generation
        note_id_func = function(title)
            local suffix = ""
            if title ~= nil then
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                end
            end
            return tostring(os.time()) .. "-" .. suffix
        end,

        -- Add directory-based tags to new notes
        note_frontmatter_func = function(note)
            local out = { id = note.id, aliases = note.aliases, tags = note.tags or {} }

            local vault_path = vim.fn.expand("~/Documents/syncing_folder/Obsidian_Vaults/Personal/")
            local note_path = tostring(note.path)
            local relative_path = note_path:gsub("^" .. vault_path:gsub("([^%w])", "%%%1"), "")

            local dir_parts = {}
            for part in relative_path:gmatch("([^/]+)") do
                if part ~= note.id .. ".md" then
                    local clean_tag = part:lower():gsub("%s+", "_"):gsub("[^%w_]", "")
                    table.insert(dir_parts, clean_tag)
                end
            end

            -- Add directory tags to existing tags
            local tag_set = {}
            for _, tag in ipairs(out.tags) do
                tag_set[tag] = true
            end
            for _, dir_tag in ipairs(dir_parts) do
                if not tag_set[dir_tag] then
                    table.insert(out.tags, dir_tag)
                    tag_set[dir_tag] = true
                end
            end

            return out
        end,

        templates = {
            folder = "Utils/Templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
        },

        attachments = {
            img_folder = "Utils/Assets/imgs",
            img_name_func = function()
                return string.format("Pasted image %s", os.date "%Y%m%d%H%M%S")
            end,
            confirm_img_paste = true,
        },
        checkbox = {
            order = { " ", ">", "x", },
        },
        ui = {
            enable = true,
        },
        picker = { name = "fzf-lua" },
        sort_by = "modified",
        sort_reversed = true,
        search_max_lines = 1000,
        open_notes_in = "current",

        -- Callback to set up keymaps when entering a note
        callbacks = {
            enter_note = function(_, note)
                -- Remove default Enter mapping and add Tab for smart_action
                vim.keymap.del("n", "<CR>", { buffer = note.bufnr })
                vim.keymap.set("n", "<C-y>", function()
                    return require("obsidian").util.smart_action()
                end, {
                    buffer = note.bufnr,
                    desc = "Obsidian smart action",
                    expr = true,
                })
            end,
        },
    },
}
