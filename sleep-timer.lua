local sleepAfter = 0
local startSleep = nil

function sleep()
    sleepAfter = sleepAfter + 15
    startSleep = mp.add_timeout(sleepAfter * 60, sleepPause)
    startSleep:resume()
    mp.osd_message("Sleep in "..sleepAfter.." minutes")
end

function sleepPause()
    mp.set_property_native("pause", true)
    startSleep:kill()
    sleepAfter = 0
end

mp.add_key_binding("F3", "sleep-timer", sleep)
