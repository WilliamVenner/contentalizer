# 🪄 The Contentalizer!

This quick script will search for mounted Workshop addons that contain content and add them to the clientside Workshop download list.

It will not add addons that are purely Lua files, and it will not add addons that contain maps, unless the server is currently playing that map.

I used this on a personal TTT server to fix the countless addons that contain content and do not call `resource.AddWorkshop`
