--- Draw functions

function draw_tile(tx,ty,tileid,ox,oy,tileset)
    -- Draws a single tile on the screen 
    -- tx and ty are blocks of 16 pixels each
    
        local tileset=tileset or u4_style_tileset
        local ts=tileset[1]
        local ti=tileset[2]

        ox = ox or 0
        oy = oy or 0
    
        love.graphics.draw(ts, ti[tileid], tx*16+ox, ty*16+oy)
        
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



function draw_viewport(ox,oy,size)
    local ox=ox or 0
    local oy=oy or 0
    local size=size or 10
 
    local plx,ply=player.x,player.y

    local offset = math.floor(size/2)
 
     for x = 0,size do
         for y = 0,size do
             
             ray = bresenham(plx,ply,x+plx-offset,y+ply-offset)
             if check_los(ray) then draw_tile(x,y,bigmap[x+plx-offset][y+ply-offset],ox,oy) end
           
 
         end
    end
 
     
 
     draw_tile(offset,offset,player.tile,ox,oy,player.tileset)
 
end



function draw_game()
    
    local plx,ply=player.x, player.y

    love.graphics.scale(4,4)
    mouse_x = math.floor(love.mouse.getX() / 32)-12
    mouse_y = math.floor(love.mouse.getY() / 32)
    love.graphics.setColor(1,1,1) 
    

    draw_viewport(10,10,16)


    love.graphics.draw(gui,0,0)
    
    text="X: "..plx..", Y: "..ply.." id: "..bigmap[plx][ply]
    love.graphics.print(text,110,0,0,.8)
    draw_tile(11,15,bigmap[plx][ply])
    
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