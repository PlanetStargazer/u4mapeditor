--- Contains all the "tool" functions

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


function file_exists(name)
    -- Checks if file exists in game folder
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end    