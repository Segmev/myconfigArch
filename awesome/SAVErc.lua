-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
vicious = require("vicious")
require("volume")

local tyrannical = require("tyrannical")
local net_widgets = require("net_widgets")
local revelation = require("revelation")
local lain = require("lain")

-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local cal = require("utils.cal")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
		    title = "Oops, there were errors during startup!",
		    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
			     -- Make sure we don't go into an endless error loop
			     if in_error then return end
			     in_error = true

			     naughty.notify({ preset = naughty.config.presets.critical,
					      title = "Oops, an error happened!",
					      text = err })
			     in_error = false
   end)
end
-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("/home/karraz_s/.congif/awesome/themes/dunzor/theme.lua")
beautiful.init("/home/karraz_s/.config/awesome/themes/dunzor/theme.lua")
revelation.init()


-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
   {
      awful.layout.suit.fair,
      awful.layout.suit.fair.horizontal,
      awful.layout.suit.floating,
      awful.layout.suit.tile,
      awful.layout.suit.tile.left,
      awful.layout.suit.tile.bottom,
      awful.layout.suit.tile.top,
      awful.layout.suit.spiral,
      awful.layout.suit.spiral.dwindle,
      awful.layout.suit.max,
      awful.layout.suit.max.fullscreen,
      awful.layout.suit.magnifier,
      lain.layout.termfair,
      lain.layout.centerfair,
      lain.layout.cascade,
      lain.layout.cascadetile,
      lain.layout.centerwork,
      lain.layout.centerhwork,
      lain.layout.uselessfair,
      lain.layout.uselesspiral,
      lain.layout.uselesstile
   }
-- }}}

tyrannical.settings.default_layout =  awful.layout.suit.tile.fair
tyrannical.settings.mwfact = 0.60

tyrannical.tags = {
   {
      name = "Develop",
      init        = true,
      exclusive   = true,
      screen      = 1,
      clone_on    = 2, -- Create a single instance of this tag on screen 1, but also show it on screen 2
      -- The tag can be used on both screen, but only one at once
      layout      = awful.layout.suit.fair,
      class ={ 
	 "Kate", "KDevelop", "Codeblocks", "Code::Blocks" , "DDD", "kate4", "Emacs", "jetbrains-studio"}
   } , 
   {
      name        = "Term",                 -- Call the tag "Term"
      init        = true,                   -- Load the tag on startup
      exclusive   = false,                   -- Refuse any other type of clients (by classes)
      screen      = {1,2},                  -- Create this tag on screen 1 and screen 2
      layout      = awful.layout.suit.tile, -- Use the tile layout
      selected    = true,
      class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
	 "xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal"
      }
   } ,
   {
      name        = "Internet",
      init        = true,
      exclusive   = true,
      --icon        = "~net.png",                 -- Use this icon for the tag (uncomment with a real path)
      screen      = screen.count()>1 and 2 or 1,-- Setup on screen 2 if there is more than 1 screen, else on screen 1
      layout      = awful.layout.suit.tile,      -- Use the max layout
      class = {
	 "Opera"         , "Firefox"        , "Rekonq"    , "Dillo"        , "Arora",
	 "Chromium"      , "nightly"        , "minefield"     }
   } ,
   {
      name = "Files",
      init        = false,
      exclusive   = true,
      screen      = 1,
      layout      = awful.layout.suit.tile,
      exec_once   = {"dolphin"}, --When the tag is accessed for the first time, execute this command
      class  = {
	 "Thunar", "Konqueror", "Dolphin", "ark", "Nautilus","emelfm", "SpaceFM"
      }
   } ,
   {
      name        = "Doc",
      init        = false, -- This tag wont be created at startup, but will be when one of the
      -- client in the "class" section will start. It will be created on
      -- the client startup screen
      exclusive   = true,
      layout      = awful.layout.suit.max,
      class       = {
	 "Assistant"     , "Okular"         , "Evince"    , "EPDFviewer"   , "xpdf",
	 "Xpdf"          ,                                        }
   } ,
   {
      name        = "All",
      init        = true, -- This tag wont be created at startup, but will be when one of the
      -- client in the "class" section will start. It will be created on
      -- the client startup screen
      exclusive   = true,
      layout      = awful.layout.suit.fair,
   } ,
   {
      name        = "Chat/all",
      init        = true, -- This tag wont be created at startup, but will be when one of the
      -- client in the "class" section will start. It will be created on
      -- the client startup screen
      exclusive   = true,
      layout      = awful.layout.suit.fair,
   } ,
}

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
   "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
   "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
   "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
   "VLC",
}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
   "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
   "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
   "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
   "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer" ,
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
   "Xephyr"       , "ksnapshot"       , "kruler"
}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
   "kcalc"
}

-- Do not honor size hints request for those classes
tyrannical.properties.size_hints_honor = { xterm = false, URxvt = false, aterm = false, sauer_client = false, mythfrontend  = false}

function run_once(cmd)
   findme = cmd
   firstspace = cmd:find(" ")
   if firstspace then
      findme = cmd:sub(0, firstspace-1)
   end
   awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- Widgets

net_wireless = net_widgets.wireless({interface="wlo1"})

--battery widget
-- {
batterywidget = wibox.widget.textbox()    
batterywidget:set_text(" | Battery | ")    
batterywidgettimer = timer({ timeout = 5 })    
batterywidgettimer:connect_signal("timeout",    
  function()    
    fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))    
    batterywidget:set_text(" |" .. fh:read("*l") .. " | ")    
    fh:close()    
  end    
)    
batterywidgettimer:start()
-- }

--}}}


-- {{{ Wallpaper
if beautiful.wallpaper then
   for s = 1, screen.count() do
      --gears.wallpaper.maximized(beautiful.wallpaper, s, true)
      gears.wallpaper.maximized("/home/karraz_s/Images/Wallpapers/wall2.jpg", 1, true)
   end
end


-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- tags = {}
-- for s = 1, screen.count() do
--    -- Each screen has its own tag table.
--    tags[s] = awful.tag({ 1, 2, "3: www", 4, "5: chat", 6, 7, 8, 9 }, s, layouts[1])
-- end
-- -- }}}



-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = {
			     { "awesome", myawesomemenu, beautiful.awesome_icon },
			     { "open terminal", terminal },
			     { "Firefox", "firefox" }
}
		       })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


-- remplace la boîte d’horloge par le widget d’horloge (par exemple « mytextbox »)

-- {{{ Wibox

-- Create a textclock widget
datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, " %d %B %Y, %R ", 60)

cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "cpu $1%")

-- cputmp = wibox.widget.textbox()
-- vicious.register(cuptmp, vicious.widgets.thermal)

-- -- Initialize widget
-- cpuwidget = awful.widget.graph()
-- -- Graph properties
-- cpuwidget:set_width(50)
-- cpuwidget:set_background_color("#494B4F")
-- cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#FF5656"}, {0.5, "#88A175"}, 
--                     {1, "#AECF96" }}})
-- -- Register widget
-- vicious.register(cpuwidget, vicious.widgets.cpu, "$1")

net_wired = net_widgets.indicator({
      interfaces  = {"wlo1"},
      timeout     = 5
})

separator = wibox.widget.textbox()
separator:set_text(" | ")

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
   awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
	 if c == client.focus then
	    c.minimized = true
	 else
	    -- Without this, the following
	    -- :isvisible() makes no sense
	    c.minimized = false
	    if not c:isvisible() then
	       awful.tag.viewonly(c:tags()[1])
	    end
	    -- This will also un-minimize
	    -- the client, if needed
	    client.focus = c
	    c:raise()
	 end
   end),
   awful.button({ }, 3, function ()
	 if instance then
	    instance:hide()
	    instance = nil
	 else
	    instance = awful.menu.clients({
		  theme = { width = 250 }
	    })
	 end
   end),
   awful.button({ }, 4, function ()
	 awful.client.focus.byidx(1)
	 if client.focus then client.focus:raise() end
   end),
   awful.button({ }, 5, function ()
	 awful.client.focus.byidx(-1)
	 if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt()
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
			     awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
			     awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
			     awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
			     awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
   -- Create a taglist widget
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

   -- Create a tasklist widget
   mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

   -- Create the wibox
   mywibox[s] = awful.wibox({ position = "bottom", height = "23", screen = s })

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   left_layout:add(mylauncher)
   left_layout:add(mytaglist[s])
   left_layout:add(separator)
   left_layout:add(mypromptbox[s])
   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()
   right_layout:add(net_wireless)
   right_layout:add(separator)
   if s == 1 then right_layout:add(wibox.widget.systray()) end
   right_layout:add(separator)
   right_layout:add(cpuwidget)
   right_layout:add(batterywidget)
   right_layout:add(volume_widget)
   right_layout:add(separator)
   right_layout:add(datewidget)
   right_layout:add(separator)
   right_layout:add(mylayoutbox[s])
   
   -- Now bring it all together (with the tasklist in the middle)
   local layout = wibox.layout.align.horizontal()
   layout:set_left(left_layout)
   layout:set_middle(mytasklist[s])
   layout:set_right(right_layout)

   mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
		awful.button({ }, 3, function () mymainmenu:toggle() end),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   -- awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
   -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
   -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

   awful.key({ modkey,           }, "Left",
      function ()
	 awful.client.focus.byidx( 1)
	 if client.focus then client.focus:raise() end
   end),
   awful.key({ modkey,           }, "Right",
      function ()
	 awful.client.focus.byidx(-1)
	 if client.focus then client.focus:raise() end
   end),
   awful.key({ modkey,           }, "p", function () mymainmenu:show() end),

   -- Layout manipulation
   awful.key({ modkey,           }, "Up", function () awful.client.swap.byidx(  1)    end),
   awful.key({ modkey,           }, "Down", function () awful.client.swap.byidx( -1)    end),
   awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
   awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
   awful.key({ modkey,           }, "Tab",
      function ()
	 awful.client.focus.history.previous()
	 if client.focus then
	    client.focus:raise()
	 end
   end),

   -- My bindings

   awful.key({ modkey,           }, "F3", 
      function ()
	 local screen = mouse.screen
	 local tag = awful.tag.gettags(screen)[3]
	 if tag then
	    awful.tag.viewonly(tag)
	 end
      end,
      function ()
	 run_once("firefox")
   end),
   awful.key({ modkey,           }, "F5", 
      function ()
	 local screen = mouse.screen
	 local tag = awful.tag.gettags(screen)[5]
	 if tag then
	    awful.tag.viewonly(tag)
	 end
      end,
      function ()
	 run_once("skype")
   end),

      
   awful.key({ modkey,           }, "F4", function () awful.util.spawn_with_shell("emacs &") end),
   awful.key({ modkey,           }, "F2", function () awful.util.spawn_with_shell("spacefm &") end),
   awful.key({ modkey,           }, "d", function () awful.util.spawn_with_shell("dmenu_extended_run &") end),
   awful.key({ modkey,           }, "l", function () awful.util.spawn_with_shell("/home/karraz_s/bin/i3lock.sh &") end),   

   -- Revelation

   awful.key({modkey}, "e", revelation),
   
   -- Standard program

   awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
   awful.key({ modkey, "Shift"   }, "r", awesome.restart),
   awful.key({ modkey, "Shift"   }, "End", awesome.quit),

   awful.key({ modkey, "Shift"   }, "Right",     function () awful.tag.incmwfact( 0.05)    end),
   awful.key({ modkey, "Shift"   }, "Left",     function () awful.tag.incmwfact(-0.05)    end),
   awful.key({ modkey, "Shift"   }, "Up",     function () awful.tag.incnmaster( 1)      end),
   awful.key({ modkey, "Shift"   }, "Down",     function () awful.tag.incnmaster(-1)      end),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
   awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

   

   awful.key({ modkey, "Shift" }, "n", awful.client.restore),

   -- Audio
   awful.key({ }, "XF86AudioRaiseVolume", function ()
	 awful.util.spawn("amixer set Master 9%+") end),
   awful.key({ }, "XF86AudioLowerVolume", function ()
	 awful.util.spawn("amixer set Master 9%-") end),
   awful.key({ }, "XF86AudioMute", function ()
	 awful.util.spawn("amixer sset Master toggle") end),

   -- Brightness

   awful.key({ }, "XF86MonBrightnessDown", function ()
	 awful.util.spawn("xbacklight -dec 10") end),
   awful.key({ }, "XF86MonBrightnessUp", function ()
	 awful.util.spawn("xbacklight -inc 10") end),
   awful.key({ "Shift" }, "XF86MonBrightnessDown", function ()
	 awful.util.spawn("xbacklight -dec 3") end),
   awful.key({ "Shift" }, "XF86MonBrightnessUp", function ()
	 awful.util.spawn("xbacklight -inc 3") end),

   -- Prompt
   awful.key({ modkey }, "r",     function () mypromptbox[mouse.screen]:run() end),

   awful.key({ modkey }, "x",
      function ()
	 awful.prompt.run({ prompt = "Run Lua code: " },
	    mypromptbox[mouse.screen].widget,
	    awful.util.eval, nil,
	    awful.util.getdir("cache") .. "/history_eval")
   end)
   -- Menubar
   --awful.key({ modkey }, "d", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
   awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ modkey,           }, "n",
      function (c)
	 -- The client currently has the input focus, so it cannot be
	 -- minimized, since minimized clients can't have the focus.
	 c.minimized = true
   end),
   awful.key({ modkey,           }, "m",
      function (c)
	 c.maximized_horizontal = not c.maximized_horizontal
	 c.maximized_vertical   = not c.maximized_vertical
   end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
   globalkeys = awful.util.table.join(globalkeys,
				      -- View tag only.
				      awful.key({ modkey }, "#" .. i + 9,
					 function ()
					    local screen = mouse.screen
					    local tag = awful.tag.gettags(screen)[i]
					    if tag then
					       awful.tag.viewonly(tag)
					    end
				      end),
				      -- Toggle tag.
				      awful.key({ modkey, "Control" }, "#" .. i + 9,
					 function ()
					    local screen = mouse.screen
					    local tag = awful.tag.gettags(screen)[i]
					    if tag then
					       awful.tag.viewtoggle(tag)
					    end
				      end),
				      -- Move client to tag.
				      awful.key({ modkey, "Shift" }, "#" .. i + 9,
					 function ()
					    if client.focus then
					       local tag = awful.tag.gettags(client.focus.screen)[i]
					       if tag then
						  awful.client.movetotag(tag)
					       end
					    end
				      end),
				      -- Toggle tag.
				      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
					 function ()
					    if client.focus then
					       local tag = awful.tag.gettags(client.focus.screen)[i]
					       if tag then
						  awful.client.toggletag(tag)
					       end
					    end
   end))
end

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
		    border_color = beautiful.border_normal,
		    focus = awful.client.focus.filter,
		    raise = true,
		    keys = clientkeys,
		    buttons = clientbuttons } },
   { rule = { class = "MPlayer" },
     properties = { floating = true } },
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
   -- Set Firefox to always map on tags number 2 of screen 1.
   { rule = { class = "Firefox" },
     properties = { border_width = 0} },
   -- { rule = { class = "Skype" },
   --   properties = { tag = tags[1][5] },
   -- }

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
			 -- Enable sloppy focus
			 c:connect_signal("mouse::enter", function(c)
					     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
					     and awful.client.focus.filter(c) then
						client.focus = c
					     end
			 end)

			 if not startup then
			    -- Set the windows at the slave,
			    -- i.e. put it at the end of others instead of setting it master.
			    -- awful.client.setslave(c)

			    -- Put windows in a smart way, only if they does not set an initial position.
			    if not c.size_hints.user_position and not c.size_hints.program_position then
			       awful.placement.no_overlap(c)
			       awful.placement.no_offscreen(c)
			    end
			 end

			 local titlebars_enabled = false
			 if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
			    -- buttons for the titlebar
			    local buttons = awful.util.table.join(
			       awful.button({ }, 1, function()
				     client.focus = c
				     c:raise()
				     awful.mouse.client.move(c)
			       end),
			       awful.button({ }, 3, function()
				     client.focus = c
				     c:raise()
				     awful.mouse.client.resize(c)
			       end)
			    )

			    -- Widgets that are aligned to the left
			    local left_layout = wibox.layout.fixed.horizontal()
			    left_layout:add(awful.titlebar.widget.iconwidget(c))
			    left_layout:buttons(buttons)

			    -- Widgets that are aligned to the right
			    local right_layout = wibox.layout.fixed.horizontal()
			    right_layout:add(awful.titlebar.widget.floatingbutton(c))
			    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
			    right_layout:add(awful.titlebar.widget.stickybutton(c))
			    right_layout:add(awful.titlebar.widget.ontopbutton(c))
			    right_layout:add(awful.titlebar.widget.closebutton(c))

			    -- The title goes in the middle
			    local middle_layout = wibox.layout.flex.horizontal()
			    local title = awful.titlebar.widget.titlewidget(c)
			    title:set_align("center")
			    middle_layout:add(title)
			    middle_layout:buttons(buttons)

			    -- Now bring it all together
			    local layout = wibox.layout.align.horizontal()
			    layout:set_left(left_layout)
			    layout:set_right(right_layout)
			    layout:set_middle(middle_layout)

			    awful.titlebar(c):set_widget(layout)
			 end
end)

cal.register(datewidget, "<b>%s</b>")

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

run_once ("nm-applet")
--	run_once ("skype")
--	run_once ("auto_ns")
--	run_once ("pidgin")
run_once ("dunst")
awful.util.spawn_with_shell("xset -b")

-- awful.tag.viewonly(3)
-- awful.tag.incmwfact(0.15, 3)


