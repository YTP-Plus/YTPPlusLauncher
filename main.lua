function getPath(str)
    return str:match("(.*[/\\])")
end
function game_request(studioversion)
	local response = Request.send("https://github.com/YTP-Plus/YTPPlusStudio/releases/latest/download/YTPPlusStudio.love?time="..os.time())
	if response then
		if response.code ~= 404 then
			love.filesystem.write('game_' .. studioversion .. '.love', response.body)
			-- Mount and run
			love.filesystem.mount('game_' .. studioversion .. '.love', '')
			package.loaded.main = nil
			package.loaded.conf = nil
			love.conf = nil
			love.init()
			love.load(args)
		end
	end
end

function studioversioncheck()
	local response = Request.send("https://ytp-plus.github.io/studio-version.txt?time="..os.time())
	if response then
		if response.code ~= 404 then
			return response.body
		end
	end
	return
end

function cliversioncheck()
	local response = Request.send("https://ytp-plus.github.io/cli-version.txt?time="..os.time())
	if response then
		if response.code ~= 404 then
			return response.body
		end
	end
	return
end

function love.load(args)
	Loading = love.graphics.newImage( "loading.png" )
	Enums = require("enums-launcher")
	Request = require('lib/luajit-request')
	Data = require("data-launcher")
	TimerDone = 0
	love.window.setMode( Enums.Width, Enums.Height, Enums.WindowFlags )
	love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")
	love.filesystem.mount(getPath(love.filesystem.getSource()), "")
end

function love.draw()
	love.graphics.draw(Loading, 0, 0, 0, (love.graphics.getWidth()/Enums.Width), (love.graphics.getHeight()/Enums.Height))
end

function love.update()
	TimerDone = TimerDone + 1
	if TimerDone == 2 then
		local studioversion = Data.Version.Major.."."..Data.Version.Minor.."."..Data.Version.Patch
		local studioversioncheck = studioversioncheck()
		if studioversioncheck ~= nil then
			studioversion = studioversioncheck
		end
		local info = love.filesystem.getInfo("YTPPlusCLI")
		local cwd = getPath(love.filesystem.getSource())
		local path = love.filesystem.getSource()
    	if string.find(path, ".love") then
			cwd = love.filesystem.getSaveDirectory()
		end
		if info then
			local cliversion = "0.0.0"
			cliversion = love.filesystem.read("YTPPlusCLI/version.txt")
			local cliversioncheck = cliversioncheck()
			if cliversion ~= cliversioncheck then
				os.execute("git -C \""..cwd.."/YTPPlusCLI/\" stash")
				os.execute("git -C \""..cwd.."/YTPPlusCLI/\" pull origin main")
				os.execute("git -C \""..cwd.."/YTPPlusCLI/\" stash pop")
			end
		else
			os.execute("git -C \""..cwd.."\" clone https://github.com/YTP-Plus/YTPPlusCLI.git")
			os.execute("npm install --prefix \""..cwd.."/YTPPlusCLI/\" \""..cwd.."/YTPPlusCLI/\" ")
		end
		if not love.filesystem.getInfo('game_' .. studioversion .. '.love') then
			game_request(studioversion)
		else
			love.filesystem.mount('game_' .. studioversion .. '.love', '')
			package.loaded.main = nil
			package.loaded.conf = nil
			love.conf = nil
			love.init()
			love.load(args)
		end
	end
end
