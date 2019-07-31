

require ("table")
require ("math")
require ("string")
require ("io")

require ("draw")
require ("tools")
require ("keyb")
require ("editor")

bigmap ={}



function switch_mode_to(mode)

    -- mode 0: editor
    -- mode 1: game

    local mode = mode or 0

    if mode == 0 then
        _draw=draw_editor
        _keyb=keyb_editor
        _mousemoved=editor_mousemoved
        _mousepressed=editor_mousepressed
        music:stop()
    elseif mode == 1 then
        _draw=draw_game
        _keyb=keyb_game
        _mousemoved=dead_mousemoved
        _mousepressed=dead_mousepressed
        music:play()
    end

end

function dead_mousepressed()
end

function dead_mousemoved()
end


function love.mousepressed(x, y, button,istouch)
    _mousepressed(x,y,button,istouch)
end    


function love.mousemoved(x, y, dx,dy,istouch)
    _mousemoved(x,y,dx,dy,istouch)
end




function init_tileset(path)
 -- Loads tileset texture and converts it into quads for later use   
 -- returns {texture,tiles}

    love.graphics.setDefaultFilter("nearest","nearest")
    local tileset = love.graphics.newImage(path)
    
    local tileW = 16
    local tileH = 16
    
    local ww,hh = tileset:getDimensions()
    local uu = ww / tileW

    local tile = {}

    local tilenum = ww/tileW * hh/tileH -1

    for i=0, tilenum do
        local tx,ty = (i%uu)*tileW, math.floor(i/uu)*tileH
        tile[i] = love.graphics.newQuad(tx,ty, tileW, tileH, tileset:getDimensions())
    end


return {tileset, tile}

end




function init_map()
-- Loads WORLD.MAP into memory for use in the editor/game
    tilemap={}

    if file_exists("WORLD.MAP") then
        local contents = love.filesystem.read("WORLD.MAP")
        local t={}

        

        file = io.open("WORLD.MAP", "rb")
        
        for c = 0,64 do
            chunk = file:read(1024)
            t[c]=chunk
            file:seek("set",1024*c)
        end
        file:close()
        tilemap = t
    else
        love.window.showMessageBox("Error", "WORLD.MAP not found", "error")
        love.event.quit()
    end
-- Map is transferred into a multi-dimensional array for easier use
transfer_map()
end









function love.load()
-- Loads resources and initializes variables as game loads

    player ={}

    u4_style_tileset = init_tileset("assets/tileset/u4_tiles_pc_ega2.png")
    u5_style_tileset = init_tileset("assets/tileset/u5_tiles_pc_ega.png")
    
    
    
    init_map()
    music = love.audio.newSource("assets/music/wanderer.ogg","stream")
    music:setLooping(true)
    gui = love.graphics.newImage("assets/gui/gui.png")    
    
    viewx = 0
    viewy = 0
    px, py = 0,0
    palette_min = 0
    palette_max = 25
    palette_active = 25
    mouse_x = 0
    mouse_y = 0
    status = ""
    changed = false
    
    
    player.x=28
    player.y=51
    player.tile = 284
    player.tileset = u5_style_tileset

    switch_mode_to(0)


end







function check_los(ray)

    local len = #ray
    local obstacles = 0

    for i=1,len do
        if (bigmap[ray[i][1]][ray[i][2]]==6) then obstacles=obstacles+1 end
        if (bigmap[ray[i][1]][ray[i][2]]==8) or (bigmap[ray[i][1]][ray[i][2]]==9) then obstacles=obstacles+1 end
    end



    if (obstacles>1) or (len>8) then 
        return false 
    else 
        return true 
    end

end





function move_player(ttx,tty)
    
    target = bigmap[ttx][tty]

    
    if (ttx>=0) and (ttx<=255) and (tty>=0) and (tty<=255) and (target>2) and (target~=8) then 
        player.x=ttx 
        player.y=tty
    end

end











function love.update(delta)
    if love.mouse.isDown(1) then 
        if mouse_in_chunk(mouse_x,mouse_y) then
            replace_chunk(mouse_x,mouse_y,palette_active)
        end
    end
end

function love.wheelmoved(x,y)
    if y>0 then 
        palette_min = palette_min+1 
        
    end
    if y<0 then 
        palette_min = palette_min-1 
        
    end
    

end




function love.keypressed(key)
    _keyb(key) 
end




function love.draw()
    
    -- if modus == 0 then draw_editor() else draw_game() end
  
    _draw()

    
    
    

end