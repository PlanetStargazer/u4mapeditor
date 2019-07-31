--- Keypressed

function keyb_universal(key)
    if key == "escape" then love.event.quit() end

    if key == "f1" then u4_style_tileset=init_tileset("assets/tileset/u4_tiles_c64.png") end
    if key == "f2" then u4_style_tileset=init_tileset("assets/tileset/u4_tiles_pc_ega.png") end
    if key == "f3" then u4_style_tileset=init_tileset("assets/tileset/u4_tiles_pc_ega2.png") end
    if key == "f4" then u4_style_tileset=init_tileset("assets/tileset/u4_tiles_pc_vga.png") end
    




end



function keyb_game(key)
    
    keyb_universal(key)
    
    if key == "a" then move_player(player.x-1,player.y) end
    if key == "d" then move_player(player.x+1,player.y) end
    if key == "w" then move_player(player.x,player.y-1) end
    if key == "s" then move_player(player.x,player.y+1) end
    
    if key == "m" then
        volume = music:getVolume()
        if volume == 0 then music:setVolume(1) else music:setVolume(0) end
    end

    if key == "tab" then 
        switch_mode_to(0)
     end

end


function keyb_editor(key)
    keyb_universal(key)
    
    if key == "a" then move(viewx-1,viewy) end
    if key == "d" then move(viewx+1,viewy) end
    if key == "w" then move(viewx,viewy-1) end
    if key == "s" then move(viewx,viewy+1) end

    if key == "c" then empty_map() end
    if key == "j" then 
        local cx = math.floor(player.x/32)
        local cy = math.floor(player.y/32)
        move(cx,cy)
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
        switch_mode_to(1)
    end

    if key == "x" and love.keyboard.isDown("lctrl","rctrl") then save_map() end

end