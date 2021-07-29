-- title:  PocketCube
-- author: Peterwu4084
-- email:  peterwu4084@outlook.com
-- desc:   Play PocketCube(2x2x2) in Tic80
-- script: lua
points = {}
l = 5
res = 9 -- resolution
pi = 3.14
pivot = {x=0, y=0, z=0}
lookbetter = 0.5
face_front = {
    tl_tile={z=res+lookbetter, y=-res, x=-res, c=10},
    tr_tile={z=res+lookbetter, y=0,    x=-res, c=10},
    dl_tile={z=res+lookbetter, y=-res, x=0,    c=10},
    dr_tile={z=res+lookbetter, y=0,    x=0,    c=10},
    surround_tiles={}
} -- blue
face_top = {
    tl_tile={z=-res, y=-res, x=-res-lookbetter, c=4},
    tr_tile={z=-res, y=0,    x=-res-lookbetter, c=4},
    dl_tile={z=0,    y=-res, x=-res-lookbetter, c=4},
    dr_tile={z=0,    y=0,    x=-res-lookbetter, c=4},
    surround_tiles={}
} -- yellow
face_right = {
    tl_tile={z=0,    y=res+lookbetter, x=-res, c=2},
    tr_tile={z=-res, y=res+lookbetter, x=-res, c=2},
    dl_tile={z=0,    y=res+lookbetter, x=0,    c=2},
    dr_tile={z=-res, y=res+lookbetter, x=0,    c=2},
    surround_tiles={}
} -- red
face_back = {
    tl_tile={z=-res-lookbetter, y=0,    x=-res, c=7},
    tr_tile={z=-res-lookbetter, y=-res, x=-res, c=7},
    dl_tile={z=-res-lookbetter, y=0,    x=0,    c=7},
    dr_tile={z=-res-lookbetter, y=-res, x=0,    c=7},
    surround_tiles={}
} -- green
face_down = {
    tl_tile={z=0,    y=-res, x=res+lookbetter, c=12},
    tr_tile={z=0,    y=0,    x=res+lookbetter, c=12},
    dl_tile={z=-res, y=-res, x=res+lookbetter, c=12},
    dr_tile={z=-res, y=0,    x=res+lookbetter, c=12},
    surround_tiles={}
} -- white
face_left = {
    tl_tile={z=-res, y=-res-lookbetter, x=-res, c=3},
    tr_tile={z=0,    y=-res-lookbetter, x=-res, c=3},
    dl_tile={z=-res, y=-res-lookbetter, x=0,    c=3},
    dr_tile={z=0,    y=-res-lookbetter, x=0,    c=3},
    surround_tiles={}
} -- orange
face_front.surround_tiles = {
    face_left.tr_tile,
    face_left.dr_tile,
    face_down.tl_tile,
    face_down.tr_tile,
    face_right.dl_tile,
    face_right.tl_tile,
    face_top.dr_tile,
    face_top.dl_tile
}
face_top.surround_tiles = {
    face_left.tl_tile,
    face_left.tr_tile,
    face_front.tl_tile,
    face_front.tr_tile,
    face_right.tl_tile,
    face_right.tr_tile,
    face_back.tl_tile,
    face_back.tr_tile
}
face_right.surround_tiles = {
    face_front.tr_tile,
    face_front.dr_tile,
    face_down.tr_tile,
    face_down.dr_tile,
    face_back.dl_tile,
    face_back.tl_tile,
    face_top.tr_tile,
    face_top.dr_tile,
}
face_back.surround_tiles = {
    face_right.tr_tile,
    face_right.dr_tile,
    face_down.dr_tile,
    face_down.dl_tile,
    face_left.dl_tile,
    face_left.tl_tile,
    face_top.tl_tile,
    face_top.tr_tile
}
face_left.surround_tiles = {
    face_front.dl_tile,
    face_front.tl_tile,
    face_top.dl_tile,
    face_top.tl_tile,
    face_back.tr_tile,
    face_back.dr_tile,
    face_down.dl_tile,
    face_down.tl_tile
}
face_down.surround_tiles = {
    face_front.dr_tile,
    face_front.dl_tile,
    face_left.dr_tile,
    face_left.dl_tile,
    face_back.dr_tile,
    face_back.dl_tile,
    face_right.dr_tile,
    face_right.dl_tile
}
see_front = face_front
see_right = face_right
see_top = face_top
-- see_front = face_back
-- see_right = face_left
-- see_top = face_down
t0=0
t=0
cx=0
cy=0
cz=300
ax=0
ay=0
az=0
delta_t = 200
pre_t = -delta_t
pre_clockwise = -delta_t
clockwise = 1
shuffle = 1
finish = 0
step = 100
function TIC()
    if btn(0) then ax = ax-1/128 end
    if btn(1) then ax = ax+1/128 end
    if btn(2) then ay = ay+1/128 end
    if btn(3) then ay = ay-1/128 end
    cls(15)
    if finish ~= 1 then 
        if shuffle == 1 then
            shuffleCube()
            shuffle = 0
            t0 = time()
        end
        if (ax + 1/6) % 2 <=0.5 or (ax + 1/6) % 2 > 1.5 then
            see_top = face_top
            if (ay % 2) < 0.3 or (ay % 2) >= 1.8 then
                see_front = face_front
                see_right = face_right
            elseif (ay % 2) >= 0.3 and (ay % 2) < 0.8 then
                see_front = face_right
                see_right = face_back
            elseif (ay % 2) >= 0.8 and (ay % 2) < 1.3 then
                see_front = face_back
                see_right = face_left
            else
                see_front = face_left
                see_right = face_front
            end
        else
            see_top = face_down
            if (ay % 2) < 0.3 or (ay % 2) >= 1.8 then
                see_front = face_left
                see_right = face_back
            elseif (ay % 2) >= 0.3 and (ay % 2) < 0.8 then
                see_front = face_front
                see_right = face_left
            elseif (ay % 2) >= 0.8 and (ay % 2) < 1.3 then
                see_front = face_right
                see_right = face_front
            else
                see_front = face_back
                see_right = face_right
            end
        end
        t = time()
        if btn(4) then 
            if t - pre_t >= delta_t then
                rotateSeq({see_front.tl_tile, see_front.dl_tile, see_front.dr_tile, see_front.tr_tile}, clockwise)
                rotateSeq(see_front.surround_tiles, clockwise)
                rotateSeq(see_front.surround_tiles, clockwise)
                pre_t = t
            end
        end
        if btn(5) then
            if t - pre_t >= delta_t then
                rotateSeq({see_right.tl_tile, see_right.dl_tile, see_right.dr_tile, see_right.tr_tile}, clockwise)
                rotateSeq(see_right.surround_tiles, clockwise)
                rotateSeq(see_right.surround_tiles, clockwise)
                pre_t = t
            end
        end
        if btn(6) then
            if t - pre_clockwise >= delta_t then
                pre_clockwise = t
                clockwise = (1 + clockwise) % 2
            end
        end
        if btn(7) then
            if t - pre_t >= delta_t then
                rotateSeq({see_top.tl_tile, see_top.dl_tile, see_top.dr_tile, see_top.tr_tile}, clockwise)
                rotateSeq(see_top.surround_tiles, clockwise)
                rotateSeq(see_top.surround_tiles, clockwise)
                pre_t = t
            end
        end
        -- print(string.format("ax: %f", ax), 150, 30, 0)
        -- print(string.format("ay: %f", ay), 150, 40, 0)
        if checkCube() == 1 then
            finish = 1
        end
        if clockwise == 1 then 
            print("CW", 114, 5, 0)
        else
            print("CCW", 111, 5, 0)
        end
        local w_time = print(string.format("%d", (t-t0)//1000), 0, -10, 0)
        print(string.format("%d", (t-t0)//1000), 120-w_time//2, 11, 0)
    else
        --        TIME
        --      20.5040
        -- Z: retry X: exit
        local w_TIME = print("TIME", 0, -5, 0)
        local w_time = print(string.format("time: %f", (t-t0)/1000), 0, -10, 0)
        local w_ZX = print("Z: retry  X: exit", 0, -15, 0)
        print("TIME", 120-w_TIME//2, 5, 0)
        print(string.format("time: %f", (t-t0)/1000), 120-w_time//2, 11, 0)
        print("Z: retry  X: exit", 120-w_ZX//2, 17, 0)
        -- 120, 68
        if time() - t > 500 then
            if btn(4) then
                ax = 0
                ay = 0
                az = 0
                pre_t = time()
                pre_clockwise = -delta_t
                clockwise = 1
                shuffle = 1
                finish = 0
            end
            if btn(5) then
                exit()
            end
        end
    end
    createCube()
    rotateCube(pi/6+pi*ax, -pi*4/5+pi*ay, pi/2) -- ax, ay, az
    drawCube()
end

function rotate(p3d,center,ax,ay,az)
	local a,b,c
	local a1,b1,c1
	local a2,b2,c2
	local a3,b2,c3
	local np3d={x=0,y=0,z=0,c=0}

	a = p3d.x-center.x
	b = p3d.y-center.y
	c = p3d.z-center.z
	
	a1 = a*math.cos(az)-b*math.sin(az) 
    b1 = a*math.sin(az)+b*math.cos(az)
	c1 = c

	c2 = c1*math.cos(ay)-a1*math.sin(ay) 	
	a2 = c1*math.sin(ay)+a1*math.cos(ay)
    b2 = b1
	
	b3 = b2*math.cos(ax)-c2*math.sin(ax) 	
	c3 = b2*math.sin(ax)+c2*math.cos(ax)
    a3 = a2		
			
	np3d.x=a3
	np3d.y=b3
	np3d.z=c3
	np3d.c=p3d.c
	return np3d
end

function zsort(p1,p2)
	return p1.z>p2.z
end

function p2d(p3d)
	local fov = 180
	local x0 = p3d.x + cx
	local y0 = p3d.y + cy
	local z0 = p3d.z + cz
	local x2d = fov * x0 / z0
	local y2d = fov * y0 / z0
	
	x2d = x2d + 120 --center w
	y2d = y2d + 68  --center h
	
	return x2d,y2d
end

function createTile(tile, axis_id)
    for i=0,res do
        for j=0,res do
            if i == 0 or i == res or j == 0 or j == res then
                pc = 0
            else
                pc = tile.c
            end

            if axis_id == 0 then
                px = (tile.x + i) * l
                py = (tile.y + j) * l
                pz = tile.z * l
            elseif axis_id == 1 then
                px = (tile.x + i) * l
                pz = (tile.z + j) * l
                py = tile.y * l
            else -- axis_id == 2
                pz = (tile.z + i) * l
                py = (tile.y + j) * l
                px = tile.x * l
            end

            p = {x=px, y=py, z=pz, c=pc}
            table.insert(points, p)
        end
    end
end

function createFace(face, axis_id)
    -- axis_id: 0 - z, 1 - y, 2 - x
    for k, v in pairs(face) do
        if k ~= 'surround_tiles' then
            createTile(v, axis_id)
        end
    end
end

function createCube()
    points={}
    createFace(face_front, 0)
    createFace(face_back, 0)
    createFace(face_right, 1)
    createFace(face_left, 1)
    createFace(face_top, 2)
    createFace(face_down, 2)
end

function checkFace(face)
    if face.tr_tile.c ~= face.tl_tile.c then
        return 0
    elseif face.tl_tile.c ~= face.dl_tile.c then
        return 0
    elseif face.dl_tile.c ~= face.dr_tile.c then
        return 0
    else
        return 1
    end
end

function checkCube()
    if checkFace(face_front) ~= 1 then
        return 0
    elseif checkFace(face_right) ~= 1 then
        return 0
    elseif checkFace(face_left) ~= 1 then
        return 0
    elseif checkFace(face_back) ~= 1 then
        return 0
    elseif checkFace(face_down) ~= 1 then
        return 0
    elseif checkFace(face_top) ~= 1 then
        return 0
    else
        return 1
    end
end

function shuffleCube()
    local direction
    local face
    for i=1,step do
        direction = math.random(0, 1)
        face = math.random(6)
        if face == 1 then
            rotateSeq({face_back.tl_tile, face_back.dl_tile, face_back.dr_tile, face_back.tr_tile}, direction)
            rotateSeq(face_back.surround_tiles, direction)
            rotateSeq(face_back.surround_tiles, direction)
        elseif face == 2 then
            rotateSeq({face_down.tl_tile, face_down.dl_tile, face_down.dr_tile, face_down.tr_tile}, direction)
            rotateSeq(face_down.surround_tiles, direction)
            rotateSeq(face_down.surround_tiles, direction)
        elseif face == 3 then
            rotateSeq({face_front.tl_tile, face_front.dl_tile, face_front.dr_tile, face_front.tr_tile}, direction)
            rotateSeq(face_front.surround_tiles, direction)
            rotateSeq(face_front.surround_tiles, direction)

        elseif face == 4 then
            rotateSeq({face_left.tl_tile, face_left.dl_tile, face_left.dr_tile, face_left.tr_tile}, direction)
            rotateSeq(face_left.surround_tiles, direction)
            rotateSeq(face_left.surround_tiles, direction)
        elseif face == 5 then
            rotateSeq({face_right.tl_tile, face_right.dl_tile, face_right.dr_tile, face_right.tr_tile}, direction)
            rotateSeq(face_right.surround_tiles, direction)
            rotateSeq(face_right.surround_tiles, direction)
        else
            rotateSeq({face_top.tl_tile, face_top.dl_tile, face_top.dr_tile, face_top.tr_tile}, direction)
            rotateSeq(face_top.surround_tiles, direction)
            rotateSeq(face_top.surround_tiles, direction)
        end
    end
end

function drawCube()
	table.sort(points,zsort)
	for k,p in pairs(points)do
			i,j = p2d(p)		
			rect(i,j,l,l,p.c)
	end		
end

function rotateCube(ax, ay, az)
	for k, p in pairs(points) do
        pr = rotate(p, pivot, ax, ay, az)
        points[k] = pr	
    end	
end

function rotateSeq(seq, clockwise)
    local lnth = #seq
    if clockwise == 1 then
        local temp_c = seq[1].c
        for i = 1,lnth-1 do
            seq[i].c = seq[i+1].c
        end
        seq[lnth].c = temp_c
    else
        local temp_c = seq[lnth].c
        for i = lnth,2,-1 do
            seq[i].c = seq[i-1].c
        end
        seq[1].c = temp_c
    end
end