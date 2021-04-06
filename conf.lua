function love.conf(t)
    love.filesystem.setIdentity("ytpplusstudio_1")
    local Enums = require("enums-launcher") --conf enums
    local Data = require("data-launcher")
    local ver = Data.Version.Major.."."..Data.Version.Minor.."."..Data.Version.Patch
    if Data.Version.Label ~= nil then ver = ver.."-"..Data.Version.Label.."."..Data.Version.Candidate end
    local path = love.filesystem.getSource()
    t.window.title = "ytp+ launcher [v1.0.2]" --change version here
    t.window.width = Enums.Width
    t.window.height = Enums.Height
    t.window.icon = "logo.png"
    t.console = true
end
