local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.icon_map")

local spaces = {}

-- Aerospace workspaces
local workspaces = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"I",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
}

-- Color mapping for workspaces
local workspace_palette = {
	colors.cmap_1,
	colors.cmap_2,
	colors.cmap_3,
	colors.cmap_4,
	colors.cmap_5,
	colors.cmap_6,
	colors.cmap_7,
	colors.cmap_8,
	colors.cmap_9,
	colors.cmap_10,
	colors.tn_magenta,
	colors.tn_blue,
	colors.tn_cyan,
	colors.tn_green,
	colors.tn_yellow,
	colors.tn_orange,
}

local colors_spaces = {}
for index, ws_name in ipairs(workspaces) do
	colors_spaces[ws_name] = workspace_palette[((index - 1) % #workspace_palette) + 1]
end

-- Register custom event for aerospace workspace change
sbar.add("event", "aerospace_workspace_change")

for _, ws_name in ipairs(workspaces) do
	local space = sbar.add("item", "space." .. ws_name, {
		icon = {
			font = {
				family = settings.font.numbers,
				size = 14,
			},
			string = ws_name,
			padding_left = 5,
			padding_right = 0,
			color = colors_spaces[ws_name],
			highlight_color = colors.tn_black3,
		},
		label = {
			padding_right = 10,
			padding_left = 3,
			color = colors_spaces[ws_name],
			font = "sketchybar-app-font-bg:Regular:21.0",
			y_offset = -2,
		},
		padding_right = 4,
		padding_left = 4,
		background = {
			color = colors.transparent,
			height = 22,
			border_width = 0,
			border_color = colors.transparent,
		},
	})

	spaces[ws_name] = space

	-- Handle aerospace workspace change event
	space:subscribe("aerospace_workspace_change", function(env)
		local focused = env.FOCUSED_WORKSPACE == ws_name
		space:set({
			icon = { highlight = focused },
			label = { highlight = focused },
			background = {
				height = 25,
				border_color = focused and colors_spaces[ws_name] or colors.transparent,
				color = focused and colors_spaces[ws_name] or colors.transparent,
				corner_radius = focused and 6 or 0,
			},
		})
	end)

	-- Handle mouse click to switch workspace
	space:subscribe("mouse.clicked", function(env)
		if env.BUTTON == "left" then
			sbar.exec("aerospace workspace " .. ws_name)
		end
	end)
end

-- Bracket for visual grouping
local space_names = {}
for _, ws_name in ipairs(workspaces) do
	table.insert(space_names, spaces[ws_name].name)
end

sbar.add("bracket", space_names, {
	background = {
		color = colors.background,
		border_color = colors.accent3,
		border_width = 2,
	},
})

sbar.add("item", { width = 6 })

local spaces_indicator = sbar.add("item", {
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
		border_width = 0,
		corner_radius = 6,
		height = 24,
		padding_left = 6,
		padding_right = 6,
	},
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 14.0,
		},
		padding_left = 6,
		padding_right = 9,
		color = colors.accent1,
		string = icons.switch.on,
	},
	label = {
		drawing = "off",
		padding_left = 0,
		padding_right = 0,
	},
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = colors.tn_black1,
				border_color = { alpha = 1.0 },
				padding_left = 6,
				padding_right = 6,
			},
			icon = {
				color = colors.accent1,
				padding_left = 6,
				padding_right = 9,
			},
			label = { drawing = "off" },
			padding_left = 6,
			padding_right = 6,
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.accent1 },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)

local front_app_icon = sbar.add("item", "front_app_icon", {
	display = "active",
	icon = { drawing = false },
	label = {
		font = "sketchybar-app-font-bg:Regular:21.0",
	},
	updates = true,
	padding_right = 0,
	padding_left = -10,
})

front_app_icon:subscribe("front_app_switched", function(env)
	local icon_name = env.INFO
	local lookup = app_icons[icon_name]
	local icon = ((lookup == nil) and app_icons["default"] or lookup)
	front_app_icon:set({ label = { string = icon, color = colors.accent1 } })
end)

sbar.add("bracket", {
	spaces_indicator.name,
	front_app_icon.name,
}, {
	background = {
		color = colors.tn_black3,
		border_color = colors.accent1,
		border_width = 2,
	},
})

-- Initialize: get current focused workspace
sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
	focused_workspace = focused_workspace:gsub("%s+", "") -- trim whitespace
	if spaces[focused_workspace] then
		spaces[focused_workspace]:set({
			icon = { highlight = true },
			label = { highlight = true },
			background = {
				height = 25,
				border_color = colors_spaces[focused_workspace],
				color = colors_spaces[focused_workspace],
				corner_radius = 6,
			},
		})
	end
end)
