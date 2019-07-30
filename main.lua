

require ("table")
require ("math")
require ("string")
require ("io")

local bigmap={}


function replace_char(pos, str, r)
-- Replaces a single character at position pos in a string str
    new = ""
    for i=1,#str do
        sub = string.sub(str,i,i)
        if i == pos then sub=r end
        new = new .. sub
    end    
    return new
end


function init_tileset(path)
 -- Loads tileset texture and converts it into quads for later use   
    
    love.graphics.setDefaultFilter("nearest","nearest")
    tileset = love.graphics.newImage(path)
    
    local tileW = 16
    local tileH = 16
    
    local ww,hh = tileset:getDimensions()
    local uu = ww / tileW

    tile = {}

    for i=0, 255 do
        local tx,ty = (i%uu)*tileW, math.floor(i/uu)*tileH
        tile[i] = love.graphics.newQuad(tx,ty, tileW, tileH, tileset:getDimensions())
    end

end

function file_exists(name)
-- Checks if file exists in game folder
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end    


function init_map()
-- Loads WORLD.MAP into memory for use in the editor
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


function save_map()
-- Saves changes to WORLD.MAP
    file = io.open("WORLD.MAP","wb")
    for c = 1,64 do
        file:write(tilemap[c])
    end
    status="Saved!"
    changed=false
    transfer_map()
end    



function draw_tile(tx,ty,tileid,ox,oy)
-- Draws a single tile on the screen 
-- tx and ty are blocks of 16 pixels each

    ox = ox or 0
    oy = oy or 0

    love.graphics.draw(tileset, tile[tileid], tx*16+ox, ty*16+oy)
    
end



function love.load()
-- Loads resources and initializes variables as game loads

    init_tileset("assets/tileset/u4_tiles_pc_vga.png")
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
    modus = 0
    plx=28
    ply=51
    player_tile = 32

end



function draw_chunk(chunk,ox,oy)
-- Draws a map chunk    
    for x = 1,32 do
        for y = 1,32 do
            tilenum = x + (y-1)*32
            tileid = string.byte(string.sub(tilemap[chunk+1],tilenum))
            draw_tile(x+ox-1,y+oy-1,tileid)
 
        end
    end
end



function transfer_map()
    
    for x = 0,255 do
        bigmap[x]={}
        for y = 0,255 do
            cx,cy = math.floor(x/32), math.floor(y/32)
            chunk=cx+cy*8
            ix = x-cx*32
            iy = y-cy*32
            tilenum = ix + (iy)*32 +1
            bigmap[x][y]=string.byte(string.sub(tilemap[chunk+1],tilenum))
        end
    end



end


function check_los(ray)

    local len = #ray
    local obstacles = 0

    for i=1,len do
        if (bigmap[ray[i][1]][ray[i][2]]==6) then obstacles=obstacles+1 end
        if (bigmap[ray[i][1]][ray[i][2]]==8) or (bigmap[ray[i][1]][ray[i][2]]==9) then obstacles=obstacles+1 end
    end



    if (obstacles>1) then 
        return false 
    else 
        return true 
    end

end



function draw_viewport(ox,oy,size)
   ox=ox or 0
   oy=oy or 0
   size=size or 10

    offset = math.floor(size/2)

    for x = 0,size do
        for y = 0,size do
            
            ray = bresenham(plx,ply,x+plx-offset,y+ply-offset)
            if check_los(ray) then draw_tile(x,y,bigmap[x+plx-offset][y+ply-offset],ox,oy) end
          

        end
    end

    

    draw_tile(offset,offset,player_tile,ox,oy)

end



function move(tx,ty)
       
    

    if (tx>=0) and (tx<=7) and (ty>=0) and (ty<=7) then 
        viewx=tx 
        viewy=ty
    end

end


function move_player(ttx,tty)
    
    target = bigmap[ttx][tty]

    
    if (ttx>=0) and (ttx<=255) and (tty>=0) and (tty<=255) and (target>2) and (target~=8) then 
        plx=ttx 
        ply=tty
    end

end



function mouse_in_chunk(tx,ty)
    if (tx>=0) and (tx<=31) and (ty>=0) and (ty<=31) then return true else return false end
end

function mouse_in_palette(tx,ty)
    if (ty==32) and (tx>=3) and (tx<=28) then 
        return true 
    else return false end
end



function move_high(tx,ty)
    if mouse_in_chunk(tx,ty) then
        px=tx
        py=ty
    end
end


function palette()
    love.graphics.setColor(1,1,1)

    if palette_min<0 then palette_min=0 end
    if palette_min>230 then palette_min=230 end
    palette_max=palette_min+25
    if palette_max>255 then palette_max=255 end


    for i = palette_min, palette_max do
        draw_tile(15+i-palette_min,32,i)
        if i == palette_active then
            love.graphics.setColor(1,0,0)
            draw_tile(15+i-palette_min,32,i)
            love.graphics.setColor(1,1,1) 
        end
    end

end

function empty_map()
    
    empty_chunk=""
    for x = 1,1024 do
        empty_chunk = empty_chunk .. string.char(0)
    end
        
    for c = 1,64 do
        tilemap[c]=empty_chunk
    end

    changed = true
    status = "Unsaved changes"
end

function love.mousemoved(x, y, dx,dy,istouch)
    move_high(mouse_x,mouse_y)
end

function set_active_tool(tool)
    if (tool>=0) and (tool<=255) then palette_active = tool end
end

function love.keypressed(key)



    if key == "escape" then love.event.quit() end
    
    if modus == 0 then

        if key == "a" then move(viewx-1,viewy) end
        if key == "d" then move(viewx+1,viewy) end
        if key == "w" then move(viewx,viewy-1) end
        if key == "s" then move(viewx,viewy+1) end
    else
        if key == "a" then move_player(plx-1,ply) end
        if key == "d" then move_player(plx+1,ply) end
        if key == "w" then move_player(plx,ply-1) end
        if key == "s" then move_player(plx,ply+1) end
    end


    if key == "f1" then init_tileset("assets/tileset/u4_tiles_c64.png") end
    if key == "f2" then init_tileset("assets/tileset/u4_tiles_pc_ega.png") end
    if key == "f3" then init_tileset("assets/tileset/u4_tiles_pc_ega2.png") end
    if key == "f4" then init_tileset("assets/tileset/u4_tiles_pc_vga.png") end

    if key == "c" then empty_map() end

    if key == "m" then
        volume = music:getVolume()
        if volume == 0 then music:setVolume(1) else music:setVolume(0) end
    end

    if key == "space" then replace_chunk(px,py,palette_active) end

    if key =="kp+" then palette_min = palette_min+1 end
    if key =="kp-" then palette_min = palette_min-1 end

    if key =="," then set_active_tool(palette_active-1) end
    if key =="." then set_active_tool(palette_active+1) end

    if key == "left" then move_high(px-1,py) end
    if key == "right" then move_high(px+1,py) end
    if key == "up" then move_high(px,py-1) end
    if key == "down" then move_high(px, py+1) end

    if key == "tab" then 
        modus=1-modus 
        if modus==1 then music:play() else music:pause() end
     end

    if key == "x" and love.keyboard.isDown("lctrl","rctrl") then save_map() end
end

function replace_chunk(tx,ty,newid)
    tilenum = tx+1 + (ty)*32
    oldid = string.byte(string.sub(tilemap[chunk+1],tilenum))
    tm=tilemap[chunk+1]
    newchunk=replace_char(tilenum,tm,string.char(newid))
    tilemap[chunk+1]=newchunk
    
    status="Unsaved changes"
    changed=true
end


function love.mousepressed(x, y, button,istouch)
    if button == 1 then
        if mouse_in_palette(mouse_x,mouse_y) then
            newtool = mouse_x+palette_min-3
            set_active_tool(newtool)        
        end
        
        

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


function draw_editor()
    mouse_x = math.floor(love.mouse.getX() / 32)-12
    mouse_y = math.floor(love.mouse.getY() / 32)

    love.graphics.setColor(1,1,1) 
    love.graphics.scale(2,2)
    
    chunk=viewx+viewy*8
    chunkleft = (viewx-1)+viewy*8
    chunkright = (viewx+1)+viewy*8
    if ((viewx-1)>=0) then draw_chunk(chunkleft,-20,0) end
    if ((viewx+1)<=7) then draw_chunk(chunkright,44,0) end

    draw_chunk (chunk,12,0)

    
    text="X: "..viewx..", Y: "..viewy.. "  Chunk: "..chunk
    
    tilenum = px+1 + (py)*32
    tileid = string.byte(string.sub(tilemap[chunk+1],tilenum))
    
    
    
    
    love.graphics.setColor(1,1,1,.7)
    
    draw_tile (12+px,0+py,palette_active)
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("line",(12+px)*16,(py*16),16,16)

    love.graphics.setColor(1,1,1,1)

    love.graphics.print(text,16,514,0,1)
    

    palette() 

    love.graphics.setColor(1,0.5,0)
    love.graphics.rectangle("line",192,0,512,512)
    love.graphics.print(status,840,514,0,1)
    
end

function bresenham(x0,y0,x1,y1)
    local points = {}
  
    local steep = false
    if math.abs(y1 - y0) > math.abs(x1 - x0) then steep = true end
  
    if steep then
      x0, y0 = y0, x0
      x1, y1 = y1, x1
    end             
  
    if x0 > x1 then
      x0, x1 = x1, x0
      y0, y1 = y1, y0
    end
  
    local deltax = x1 - x0
    local deltay = math.abs(y1 - y0)
    local err = deltax / 2
    local ystep = 0
    local y = y0
  
    if y0 < y1 then 
      ystep = 1 
    else 
      ystep = -1 
    end
  
    for x=x0,x1 do
      if steep then 
        local c = {y, x}
        table.insert(points, c)
      else 
        local c = {x, y}
        table.insert(points, c)
      end             
  
      err = err - deltay
  
      if err < 0 then
         y = y + ystep
         err = err + deltax
      end
    end
    table.remove(points,1)
    return points
  end




function draw_game()
    
    love.graphics.scale(4,4)
    mouse_x = math.floor(love.mouse.getX() / 32)-12
    mouse_y = math.floor(love.mouse.getY() / 32)
    love.graphics.setColor(1,1,1) 
    

    love.graphics.draw(gui,0,0)
    draw_viewport(10,10,16)


    love.graphics.draw(gui,0,0)
    
    text="X: "..plx..", Y: "..ply.." id: "..bigmap[plx][ply]
    love.graphics.print(text,110,0,0,.8)
    draw_tile(11,15,bigmap[plx][ply])
    
end


function love.draw()
    
    if modus == 0 then draw_editor() else draw_game() end
   

    
    
    

end