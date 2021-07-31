-- title:  Chameleon Maze
-- author: Peterwu4084
-- email:  peterwu4084@outlook.com
-- desc:   Try to get out
-- script: lua

function vars3d()
    -- maze={}
    -- h_walls={}
    -- v_walls={}
    maze_red={}
    h_walls_red={}
    v_walls_red={}
    maze_yellow={}
    h_walls_yellow={}
    v_walls_yellow={}
    row_num=9
    col_num=9
    -- objs={}
    objs_red={}
    objs_yellow={}
    vf=150
    crx=0
    cry=0
    tick=0
    bgc=14 -- Clears Screen and used as transparent
    hrz=6 -- Allows a horizon to be added
    unit_length=40
    air_wall=2
    cx=unit_length/2
    cy=0
    cz=10
    global_color='red'
    state="init"
    diff_change=-100
    cur_level=0
    cur_max_level=0
    max_level=4
    yellow_add=8
    if cur_level >= 4 then
        yellow_add=0
    end
end

function vars3d_restart()
    -- maze={}
    -- h_walls={}
    -- v_walls={}
    maze_red={}
    h_walls_red={}
    v_walls_red={}
    maze_yellow={}
    h_walls_yellow={}
    v_walls_yellow={}
    row_num=9
    col_num=9
    -- objs={}
    objs_red={}
    objs_yellow={}
    vf=150
    crx=0
    cry=0
    tick=0
    cx=unit_length/2
    cy=0
    cz=10
    bgc=14
    global_color='red'
    diff_change=-100
    yellow_add=8
    if cur_level >= 4 then
        yellow_add=0
    end
end

vars3d()
function TIC()
    if state=="init" then
        TIC_init()
    elseif cz>row_num*unit_length+1 then
        if state=="play" then
            state="end"
            cur_max_level=math.max(cur_max_level,math.min(cur_level+1,max_level))
        end
        TIC_end()
    else
        state="play"
        TIC_game()
    end
end

function TIC_init()
    cls(bgc)
    if hrz~=bgc then
        rect(0,68,240,136,hrz)
        rect(0,68,240,1,7)
    end
    local w_title=print("Chameleon Maze", 0, -10, 1, fasle, 2)
    local w_play = print("z: play  x: exit", 0, -10, 0)
    print("Chameleon Maze", 120-w_title//2, 20, 2, false, 2)
    print("z: play  x: exit", 120-w_play//2, 37, 2)
    if tick%120<60 then
        local w_star_2 = print(star_s, 0, -10, 0)
        local w_play_2 = print("z: play  ", 0, -10, 0)
        print("z", 120-w_play//2, 37, 10)
        print("x", 120-w_play//2+w_play_2, 37, 10)
    end
    if btn(4) then
        state="play"
    end
    if btn(5) then
        exit()
    end
end

function TIC_end()
    cls(bgc)
    if hrz~=bgc then
        rect(0,68,240,136,hrz)
        rect(0,68,240,1,7)
    end
    local star_s = "*"
    for i=1,cur_level do
        star_s=star_s.." *"
    end
    star_s="-  "..star_s.."  "
    local w_done = print("Well Done", 0, -10, 2, false, 2)
    local w_diff = print("Difficulty", 0, -10, 0)
    local w_star = print(star_s.."+", 0, -10, 0)
    local w_play = print("z: play  x: exit", 0, -10, 0)
    -- local w_exit = print("exit", 0, -15, 0)
    print("Well Done", 120-w_done//2, 20, 2, false, 2)
    print("Difficulty", 120-w_diff//2, 37, 2)
    print(star_s.."+", 120-w_star//2, 45, 2)
    print("z: play  x: exit", 120-w_play//2, 54, 2)
    -- print("play", 120-w_play//2, 11, 0)
    -- print("exit", 120-w_exit//2, 17, 0)
    tick=tick+1
    if tick%120<60 then
        local w_star_2 = print(star_s, 0, -10, 0)
        local w_play_2 = print("z: play  ", 0, -10, 0)
        print("-", 120-w_star//2, 45, 10)
        print("+", 120-w_star//2+w_star_2, 45, 10)
        print("z", 120-w_play//2, 54, 10)
        print("x", 120-w_play//2+w_play_2, 54, 10)
    end
    if btn(2) and tick-diff_change>10 then
        if cur_level-1>=0 then
            cur_level = cur_level - 1
        else
            sfx(0,"C-0",2,0,8)
        end
        diff_change = tick
    end
    if btn(3) and tick-diff_change>10 then
        if cur_level+1<=cur_max_level then
            cur_level = cur_level + 1
        else
            sfx(0,"C-0",2,0,8)
        end
        diff_change = tick
    end
    if btn(4) then
        state="play"
        vars3d_restart()
    end
    if btn(5) then
        exit()
    end
end

function TIC_game()
    local six,cox,siy,coy=trc()
    render()
    if tick<50 then
        local w_level=print("level "..cur_level+1, 0, -10)
        print("level "..cur_level+1, 120-w_level//2, 28, 7)
    end
    if btn(4) and tick>10 then 
        crx=crx+2
        if crx>=360 then crx=0 end
    end
    if btn(5) and tick>10 then 
        crx=crx-2
        if crx<=0 then crx=360 end
    end
    if btn(6) and tick-diff_change>=10 then
        diff_change=tick
        if cur_level>=3 then
            crx=crx+90*math.random(0,3)
            if crx >= 360 then crx=crx-360 end
        elseif cur_level>=2 then
            crx=crx+90
            if crx >=360 then crx=crx-360 end
        end
        if global_color=='yellow' then
            global_color='red'
            bgc=14
            if cur_level>=4 then    
                local random_color=math.random(0,1)
                bgc=bgc+random_color
                yellow_add=8*random_color
            end
        elseif global_color=='red' then
            global_color='yellow'
            bgc=15
            if cur_level>=4 then    
                local random_color=math.random(0,1)
                bgc=bgc-random_color
                yellow_add=8-8*random_color
            end
        end
    end
    -- if btn(7) and global_color~='yellow' then
    --     if cur_level>=2 then
    --         -- 
    --     end
    --     if cur_level>=3 then
    --     end
    --     bgc=15
    --     global_color='yellow'
    --     if cur_level>=4 then    
    --         local random_color=math.random(0,1)
    --         bgc=bgc-random_color
    --         yellow_add=8-8*random_color
    --     end
    -- end

    -- if btn(7) then 
    --     cry=cry+1
    --     if cry>360 then cry=0 end
    -- end
    -- if btn(6) then 
    --     cry=cry-1 
    --     if cry<0 then cry=360 end
    -- end
    local nearest={}
    if global_color=='red' then
        for i=#objs_red-2,#objs_red do
            nearest[i-#objs_red+3]=objs_red[i]
        end
    else
        for i=#objs_yellow-2,#objs_yellow do
            nearest[i-#objs_yellow+3]=objs_yellow[i]
        end
    end        
    -- print("X: "..cx,1,1)
    -- print("Y: "..cy,1,8)
    -- print("Z: "..cz,1,15)
    -- print("n1: "..nearest[1].ox.." "..nearest[1].oz.." "..nearest[1].ol.." "..nearest[1].ow,1,22,15)
    -- print("n2: "..nearest[2].ox.." "..nearest[2].oz.." "..nearest[2].ol.." "..nearest[2].ow,1,29,15)
    -- print("n3: "..nearest[3].ox.." "..nearest[3].oz.." "..nearest[3].ol.." "..nearest[3].ow,1,36,15)
    if btn(0) then
        if not inAnyItems(cx-six, cz+cox, nearest) then 
            cz=cz+cox
            cx=cx-six
        else
            cz=cz-cox/10
            cx=cx+six/10
            sfx(0,"C-0",2,0,8)
        end
    end
    if btn(1) then 
        if not inAnyItems(cx+six, cz-cox, nearest) then
            cz=cz-cox
            cx=cx+six
        else
            cz=cz+cox/10
            cx=cx-six/10
            sfx(0,"C-0",2,0,8)
        end
    end
    if btn(2) then 
        if not inAnyItems(cx-cox, cz-six, nearest) then
            cz=cz-six
            cx=cx-cox
        else
            cz=cz+six/10
            cx=cx+cox/10
            sfx(0,"C-0",2,0,8)
        end
    end
    if btn(3) then 
        if not inAnyItems(cx+cox, cz+six, nearest) then
            cz=cz+six
            cx=cx+cox
        else
            cz=cz-six/10
            cx=cx-cox/10
            sfx(0,"C-0",2,0,8)
        end
    end
	-- if key(4) then cy=cy-1 end
	-- if key(3) then cy=cy+1 end
end

function trc()
    -- convert from deg to decimal
    local ccx=crx
    local ccy=cry
    local flr=math.floor
    local sin=math.sin
    local cos=math.cos
    local rad=math.rad
    -- sin,cos,return
    local sinx=flr(sin(rad(ccx))*1000)/1000
    local cosx=flr(cos(rad(ccx))*1000)/1000
    local siny=flr(sin(rad(ccy))*1000)/1000
    local cosy=flr(cos(rad(ccy))*1000)/1000
    return sinx,cosx,siny,cosy
end

function render()
    cls(bgc)
    if hrz~=bgc then
        rect(0,68,240,136,hrz)
        rect(0,68,240,1,7)
    end
    -- print("X: "..cx,1,1)
    -- print("Y: "..cy,1,8)
    -- print("Z: "..cz,1,15)
    -- print("Xrot: "..crx,1,22,9)
    -- print("Yrot: "..cry,1,29,9)
    -- print("3D Engine",1,130,0)
    -- print("Culling edition :)",153,130,0)
    if tick==0 then
        --
        -- Define 3d Objects Here
        --
        genMaze(maze_red)
        genMaze(maze_yellow)
        genWalls(maze_red,h_walls_red,v_walls_red)
        genWalls(maze_yellow,h_walls_yellow,v_walls_yellow)
        if cur_level >= 1 then
            -- extra wall
            for i=2,row_num do
                for j=1,col_num do
                    if h_walls_yellow[i][j]==0 and h_walls_red[i][j]==0 then
                        if math.random(0,2)>0 then
                            if math.random(0,1)==0 then
                                h_walls_red[i][j]=1
                            else
                                h_walls_yellow[i][j]=1
                            end
                        end
                    end
                end
            end
            for i=1,row_num do
                for j=2,col_num do
                    if v_walls_red[i][j]==0 and v_walls_yellow[i][j]==0 then
                        if math.random(0,2)>0 then
                            if math.random(0,1)==0 then
                                h_walls_red[i][j]=1
                            else
                                h_walls_yellow[i][j]=1
                            end
                        end                        
                    end
                end
            end
        end
        genCubes(objs_red,h_walls_red,v_walls_red)
        genCubes(objs_yellow,h_walls_yellow,v_walls_yellow)
        -- genitem(0,0,0,50,10,10,10,3,true,14)
        -- genitem(0,0,0,-50,10,10,10,11,true,10)
        -- genitem(0,50,0,0,10,10,10,8,true,0)
        -- genitem(0,-50,0,0,10,10,10,12,false,12)
        -- genitem(1,0,-12,50,20,20,2,6,true,7)
    end
    tick=tick+1
    if global_color=='red' then
        -- print("red",1,8)
        getandarrangeobjs(objs_red)
    else
        getandarrangeobjs(objs_yellow)
        -- print("yellow",1,8)
    end
end

function genMaze(maze)
    -- maze={}
    for i=1,row_num do
        maze[i]={}
        for j=1,col_num do
            maze[i][j]={}
            for k=1,5 do
                maze[i][j][k]=0
            end
        end
    end
    local history={{1, 1}}
    local idx, cell, row, col, check, direction
    while(#history>0) do
        idx=math.random(#history)
        cell=table.remove(history,idx)
        row=cell[1]
        col=cell[2]
        -- print("row "..row, 1, 36, 9)
        -- print("col "..col, 1, 43, 9)
        maze[row][col][5]=1
        check={}
        if col>1 then
            if maze[row][col-1][5]==1 then
                table.insert(check,"L")
            elseif maze[row][col-1][5]==0 then
                table.insert(history,{row,col-1})
                maze[row][col-1][5]=2
            end
        end
        if row>1 then
            if maze[row-1][col][5]==1 then
                table.insert(check,"U")
            elseif maze[row-1][col][5]==0 then
                table.insert(history,{row-1,col})
                maze[row-1][col][5]=2
            end
        end
        if col<col_num then
            if maze[row][col+1][5]==1 then
                table.insert(check,"R")
            elseif maze[row][col+1][5]==0 then
                table.insert(history,{row,col+1})
                maze[row][col+1][5]=2
            end
        end
        if row<row_num then
            if maze[row+1][col][5]==1 then
                table.insert(check,"D")
            elseif maze[row+1][col][5]==0 then
                table.insert(history,{row+1,col})
                maze[row+1][col][5]=2
            end
        end
        if #check>0 then
            idx=math.random(#check)
            direction=table.remove(check,idx)
            if direction=="L" then
                maze[row][col][1]=1
                maze[row][col-1][3]=1
            elseif direction=="U" then
                maze[row][col][2]=1
                maze[row-1][col][4]=1
            elseif direction=="R" then
                maze[row][col][3]=1
                maze[row][col+1][1]=1
            else
                maze[row][col][4]=1
                maze[row+1][col][2]=1
            end
        end
    end
    maze[1][1][1]=1
    maze[row_num][col_num][3]=1
end

function genWalls(maze, h_walls, v_walls)
    -- 1L 2U 3R 4D
    -- h_walls={}
    -- v_walls={}
    local row_num=#maze
    local col_num=#maze[1]
    for i=1,row_num+1 do
        h_walls[i]={}
        for j=1,col_num do
            if i==1 or i==row_num+1 then
                h_walls[i][j]=1
            else
                if maze[i-1][j][4]==0 or maze[i][j][2]==0 then
                    h_walls[i][j]=1
                else
                    h_walls[i][j]=0
                end
            end
        end
    end
    -- h_walls[1][1]=1
    for i=1,row_num do
        v_walls[i]={}
        for j=1,col_num+1 do
            if j==1 then
                v_walls[i][j]=1-maze[i][j][1]
            elseif j==col_num+1 then
                v_walls[i][j]=1-maze[i][j-1][3]
            else
                if maze[i][j-1][3]==0 or maze[i][j][1]==0 then
                    v_walls[i][j]=1
                else
                    v_walls[i][j]=0
                end
            end
        end
    end
    v_walls[1][1]=1
end

function genCubes(objs, h_walls, v_walls)
    -- h_walls: row + 1, col
    -- v_walls: row, col + 1
    for i=1,row_num+1 do
        for j=1,col_num do
            if h_walls[i][j] == 1 then
                genItem(objs,1,(i-1)*unit_length,0,(j-0.5)*unit_length,2,unit_length,unit_length,3,true,7)
            end
        end
    end
    for i=1,row_num do
        for j=1,col_num+1 do
            if v_walls[i][j] == 1 then
                genItem(objs,1,(i-0.5)*unit_length,0,(j-1)*unit_length,unit_length,2,unit_length,3,true,7)
            end
        end
    end
end

function inItem(x, z, objt)
    if math.abs(x-objt.ox)<objt.ol/2+air_wall and math.abs(z-objt.oz)<objt.ow/2+air_wall then
        return true
    else
        return false
    end
end
    
function inAnyItems(x, z, objts)
    for i=1,#objts do
        if inItem(x, z, objts[i]) then
            return true
        end
    end
    return false
end
function genItem(objs,type,x,y,z,r1,r2,r3,col,fill,lcol)
	table.insert(objs,{ox=x,oy=y,oz=z,od=1000,ot=type,ol=r1,ow=r2,oh=r3,oc=col,of=fill,lc=lcol})
end

function getandarrangeobjs(objs)
    for i=1,(#objs) do
        local x=objs[i].ox
        local y=objs[i].oy
        local z=objs[i].oz
        local dist=math.abs(math.sqrt((x-cx)^2+(y-cy)^2+(z-cz)^2))
        objs[i].od=dist
    end
    table.sort(objs,function(a,b) return a.od>b.od end)
    for i=1,(#objs) do
        local x=objs[i].ox
        local y=objs[i].oy
        local z=objs[i].oz
        local l=objs[i].ol
        local w=objs[i].ow
        local h=objs[i].oh
        local c=5-objs[i].od//unit_length
        if c<0 then
            c=0
        end
        if global_color=='yellow' then
            c=c+yellow_add
        end
        if global_color=='red' and cur_level>=4 then
            c=c+yellow_add
        end
        local lc=objs[i].lc
        local f=objs[i].of
        local tp=objs[i].ot
        if tp==0 then
            drawcube(x,y,z,l,c,f,lc)
        end
        if tp==1 then
            drawrprism(x,y,z,l,w,h,c,f,lc)
        end
    end
end

function drawcube(x,y,z,r,c,f,flc)
	local lcol=0
	if f then lcol=flc else lcol=c end
	if f then
	    tri3(x-r,y-r,z-r,x-r,y-r,z+r,x+r,y-r,z-r,c,true,flc,false,true,false) -- up     1 2 4  cw
		tri3(x+r,y-r,z+r,x+r,y-r,z-r,x-r,y-r,z+r,c,true,flc,false,true,false) -- up     3 4 2  cw
		tri3(x-r,y+r,z-r,x-r,y+r,z+r,x+r,y+r,z-r,c,true,flc,false,false,false) -- down  8 7 5 ccw
		tri3(x+r,y+r,z+r,x+r,y+r,z-r,x-r,y+r,z+r,c,true,flc,false,false,false) -- down  6 5 7 ccw
        tri3(x-r,y-r,z-r,x-r,y+r,z-r,x+r,y-r,z-r,c,true,flc,false,false,false) -- front 1 8 4 ccw
		tri3(x+r,y-r,z-r,x+r,y+r,z-r,x-r,y+r,z-r,c,true,flc,false,true,false) -- front  4 5 8  cw
		tri3(x-r,y-r,z+r,x-r,y+r,z+r,x+r,y-r,z+r,c,true,flc,false,true,false) -- back   2 7 3  cw
		tri3(x+r,y-r,z+r,x+r,y+r,z+r,x-r,y+r,z+r,c,true,flc,false,false,false) -- back  3 6 7 ccw
		tri3(x-r,y-r,z-r,x-r,y+r,z-r,x-r,y-r,z+r,c,true,flc,false,true,false) -- left   1 8 2  cw
		tri3(x-r,y-r,z+r,x-r,y+r,z+r,x-r,y+r,z-r,c,true,flc,false,false,false) -- left  2 7 8 ccw
		tri3(x+r,y-r,z-r,x+r,y+r,z-r,x+r,y-r,z+r,c,true,flc,false,false,false) -- right 4 5 3 ccw
		tri3(x+r,y-r,z+r,x+r,y+r,z+r,x+r,y+r,z-r,c,true,flc,false,true,false) -- right  3 6 5  cw
	else
		line3(x-r,y-r,z-r,x-r,y+r,z-r,flc)
		line3(x-r,y-r,z+r,x-r,y+r,z+r,flc)
		line3(x+r,y-r,z+r,x+r,y+r,z+r,flc)
		line3(x+r,y-r,z-r,x+r,y+r,z-r,flc)
		tile(x,y-r,z,r,c,f,flc)
	    tile(x,y+r,z,r,c,f,flc)
	end
end

function drawrprism(x,y,z,len,wdt,hgt,c,f,flc)
	-- local lcol=0
	local l=len/2
	local w=wdt/2
	local h=hgt/2
	-- if f then lcol=flc else lcol=c end
	if f then
	    tri3(x-l,y-h,z-w,x-l,y-h,z+w,x+l,y-h,z-w,c,true,flc,false,true,false)
		tri3(x+l,y-h,z+w,x+l,y-h,z-w,x-l,y-h,z+w,c,true,flc,false,true,false)
		tri3(x-l,y+h,z-w,x-l,y+h,z+w,x+l,y+h,z-w,c,true,flc,false,false,false)
		tri3(x+l,y+h,z+w,x+l,y+h,z-w,x-l,y+h,z+w,c,true,flc,false,false,false)
        tri3(x-l,y-h,z-w,x-l,y+h,z-w,x+l,y-h,z-w,c,true,flc,false,false,false)
		tri3(x+l,y-h,z-w,x+l,y+h,z-w,x-l,y+h,z-w,c,true,flc,false,true,false)
		tri3(x-l,y-h,z+w,x-l,y+h,z+w,x+l,y-h,z+w,c,true,flc,false,true,false)
		tri3(x+l,y-h,z+w,x+l,y+h,z+w,x-l,y+h,z+w,c,true,flc,false,false,false)
		tri3(x-l,y-h,z-w,x-l,y+h,z-w,x-l,y-h,z+w,c,true,flc,false,true,false)
		tri3(x-l,y-h,z+w,x-l,y+h,z+w,x-l,y+h,z-w,c,true,flc,false,false,false)
		tri3(x+l,y-h,z-w,x+l,y+h,z-w,x+l,y-h,z+w,c,true,flc,false,false,false)
		tri3(x+l,y-h,z+w,x+l,y+h,z+w,x+l,y+h,z-w,c,true,flc,false,true,false)
	else
		line3(x-l,y-h,z-w,x-l,y+h,z-w,flc)
		line3(x-l,y-h,z+w,x-l,y+h,z+w,flc)
		line3(x+l,y-h,z+w,x+l,y+h,z+w,flc)
		line3(x+l,y-h,z-w,x+l,y+h,z-w,flc)
	end
end

function tri3(x1,y1,z1,x2,y2,z2,x3,y3,z3,c,o,oc,dh,cs,ic)
    -- Get pts
    local ax,ay=convp(x1,y1,z1)
    local bx,by=convp(x2,y2,z2)
    local cx,cy=convp(x3,y3,z3)
    local render=true
    -- Culling
    if (((bx-ax)*(ay+by))+(((ax-cx)*(cy+ay))+((cx-bx)*(cy+by))))<0 and ic==false then
        if cs then
            render=true
        else
            render=false
        end
    else
        if cs then
            render=false
        else
            render=true
        end
    end
    -- Overflow check
    if (ax~=-2 and bx~=-2 and cx~=-2) and render then
    -- if render then
        tri(ax,ay,bx,by,cx,cy,c)
        -- print(c,1,15)
        if o then
            -- Draw Hypotenuse
            if dh==false then
                local dist1=math.abs(math.sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2))
                local dist2=math.abs(math.sqrt((x3-x2)^2+(y3-y2)^2+(z3-z2)^2))
                local dist3=math.abs(math.sqrt((x1-x3)^2+(y1-y3)^2+(z1-z3)^2))
                if dist1>dist2 and dist1>dist3 then
                    line3(x2,y2,z2,x3,y3,z3,oc)
                    line3(x3,y3,z3,x1,y1,z1,oc)
                elseif dist2>dist1 and dist2>dist3 then
                    line3(x1,y1,z1,x2,y2,z2,oc)
                    line3(x3,y3,z3,x1,y1,z1,oc)
                elseif dist3>dist2 and dist3>dist1 then
                    line3(x1,y1,z1,x2,y2,z2,oc)
                    line3(x2,y2,z2,x3,y3,z3,oc)
                else
                    line3(x1,y1,z1,x2,y2,z2,oc)
                    line3(x2,y2,z2,x3,y3,z3,oc)
                    line3(x3,y3,z3,x1,y1,z1,oc)
                end
            else
                line3(x1,y1,z1,x2,y2,z2,oc)
                line3(x2,y2,z2,x3,y3,z3,oc)
                line3(x3,y3,z3,x1,y1,z1,oc)
            end
        end
    end
end

function line3(x1,y1,z1,x2,y2,z2,col)
    local ax,ay=convp(x1,y1,z1)
    local bx,by=convp(x2,y2,z2)
    -- checks if out of render distance
    if not(bx==-2 and by==-2 and ax~=-2 and ay~=-2) then
        if not(bx~=-2 and by~=-2 and ax==-2 and ay==-2) then
        -- line based on screen pts
        line(ax,ay,bx,by,col)
        end
    end
end

function tile(x,y,z,r,c,f,flc)
    local lcol=0
    if f then lcol=flc else lcol=c end
    if f then
        tri3(x-r,y,z-r,x-r,y,z+r,x+r,y,z-r,c,true,flc,false,false,false)
        tri3(x+r,y,z+r,x+r,y,z-r,x-r,y,z+r,c,true,flc,false,false,false)
    else
        line3(x-r,y,z-r,x+r,y,z-r,lcol)
        line3(x+r,y,z-r,x+r,y,z+r,lcol)
        line3(x+r,y,z+r,x-r,y,z+r,lcol)
        line3(x-r,y,z+r,x-r,y,z-r,lcol)
    end
end

function convp(x,y,z)
    -- define trigs and v-pts
    local six,cox,siy,coy=trc()
    local vx,vy,vz
 
    -- 1st round
    local vx,vy,vz=x-cx,y-cy,z-cz
	-- 2nd round
	vy=(coy*vy)+(siy*vz)
	-- vz=(coy*vz)-(siy*y)
    vz=(coy*vz)-(siy*(y-cy))
    -- vz=(coy*vz)-(siy*(y+cy))
	-- 3rd round
	local ox=(cox*vx)+(six*vz)
	vz=(cox*vz)-(six*vx)
    -- vz=(cox*vz)-(six*x)
	vx=ox
 
    -- set screen pts
    local scx=vf*(vx/vz)+120
    local scy=vf*(vy/vz)+64
    -- render distance
    --  if (vz<1*vf) and (vz>0) then
    -- return scx,scy
    if vz>0 then
    -- if vz>-unit_length then
        return scx,scy
    else
        return -2,-2    
    end
end
