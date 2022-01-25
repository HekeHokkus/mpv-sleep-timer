local options = require "mp.options"

local o = {
    increment = 15,
    minimum = 15,
    maximum = 150,
    episodes = false
}

options.read_options(o, "sleeptimer")

If o.episodes == true then
    o.increment = 1
    o.minimum = 1
    o.maximum = 5
    options.read_options(o, "sleeptimer")
end

local sleepAfter = o.minimum - o.increment
local startSleep = nil
local timeout = nil
local timeron = false

if o.increment < 1 then
    o.increment = 1
end

if o.minimim < 1 then
    o.minimum = 1
end

if o.maximum < o.minimum then
    o.maximum = o.minimum
end

function sleep()
    if (sleepAfter == o.minimum - o.increment) then
        timeout = mp.add_timeout(60, sleepBegin)
        sleepAfter = (sleepAfter + o.increment)
        mp.osd_message("Sleep in "..sleepAfter.." minutes")
    elseif (math.floor((sleepAfter - o.minimum) / o.increment) < (sleepAfter - o.minimum) / o.increment) then
        startSleep:kill()
        startSleep = nil
        sleepAfter = o.minimum - o.increment
        mp.osd_message("Sleep cancelled")
    elseif (sleepAfter >= o.maximum) then
        timeout:kill()
        timeout = nil
        sleepAfter = o.minimum - o.increment
        mp.osd_message("Sleep cancelled")
    elseif (math.floor((sleepAfter - o.minimum) / o.increment) == (sleepAfter - o.minimum) / o.increment) and (sleepAfter < o.maximum) then
        sleepAfter = (sleepAfter + o.increment)
        mp.osd_message("Sleep in "..sleepAfter.." minutes")
    end
end

function sleepBegin()
    timeout:kill()
    timeout = nil
    sleepAfter = sleepAfter - 1
    startSleep = mp.add_timeout(sleepAfter * 60, sleepPause)
end

function sleepPause()
    mp.set_property_native("pause", true)
    startSleep:kill()
    startSleep = nil
    sleepAfter = o.minimum - o.increment
end

function sleepEpisode()
    if (sleepAfter == o.minimum - o.increment) then
        timeout = mp.add_timeout(60, episodeBegin)
        sleepAfter = (sleepAfter + o.increment)
        mp.osd_message("Sleep in "..sleepAfter.." episodes")
    elseif timeout == nil then
        sleepAfter = o.minimum - o.increment
        mp.osd_message("Sleep cancelled")
        timeron = false
    elseif (sleepAfter >= o.maximum) then
        timeout:kill()
        timeout = nil
        sleepAfter = o.minimum - o.increment
        mp.osd_message("Sleep cancelled")
    else
        sleepAfter = (sleepAfter + o.increment)
        mp.osd_message("Sleep in "..sleepAfter.." episodes")
    end
end

function episodeCount()
    if timeron == true then
        sleepAfter = sleepAfter - 1
        if sleepAfter == 0 then
            mp.set_property_native("pause", true)
            sleepAfter = o.minimum - o.increment
            timeron = false
        end
    end
end

function episodeBegin()
    timeout:kill()
    timeout = nil
    timeron = true
end

if o.episodes == true then
    mp.register_event("file-loaded", episodeCount)
    mp.add_key_binding("Ctrl+SPACE", "sleep-timer", sleepEpisode)
else
    mp.add_key_binding("Ctrl+SPACE", "sleep-timer", sleep)
end
