-- Editor

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

function move_high(tx,ty)
    if mouse_in_chunk(tx,ty) then
        px=tx
        py=ty
    end
end

function move(tx,ty)
       
    

    if (tx>=0) and (tx<=7) and (ty>=0) and (ty<=7) then 
        viewx=tx 
        viewy=ty
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

function editor_mousemoved(x, y, dx,dy,istouch)
    move_high(mouse_x,mouse_y)
end

function set_active_tool(tool)
    if (tool>=0) and (tool<=255) then palette_active = tool end
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


function editor_mousepressed(x, y, button,istouch)
    if button == 1 then
        if mouse_in_palette(mouse_x,mouse_y) then
            newtool = mouse_x+palette_min-3
            set_active_tool(newtool)        
        end
        
        

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