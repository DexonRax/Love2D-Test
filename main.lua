function readMapFile(filename)
    local mapArray = {}

    local file = io.open(filename, "r")

    if file then
        for line in file:lines() do
            local row = {}
            for value in line:gmatch("([^;]+)") do
                table.insert(row, tonumber(value))
            end
            table.insert(mapArray, row)
        end

        file:close()
    else
        print("Error opening file: " .. filename)
    end

    return mapArray
end



function love.load()
    love.window.setTitle("love2d test")

    wf = require 'lib/windfield'
    camera = require 'lib/camera'

    world = wf.newWorld(0,0)

    cam = camera()

    env = {}
    env.cell_width = 48
    env.cell_height = 48
    env.walls = {}

    map = readMapFile("map1.txt")
    map_size_x = #map 
    map_size_y = #map[1] 
    --print(str(map_size_x)+ " "+str(map_size_y))
    print(map)
    player = {}
    player.x = 10
    player.y = 10
    player.speed = 200
    player.size = 32
    player.collision_shape = world:newRectangleCollider(0,0,player.size,player.size)
    player.collision_shape:setFixedRotation(true)

    map_collision_reload = true
    generate = true

end



function generate_world(x,y,seed,scale)
    local file = io.open("map1.txt", "w")

    for i=1, x, 1 do
        for j=1, y, 1 do
            local one = love.math.noise(i*scale,j*scale,seed)
            file:write(tostring(math.ceil(one-1.5)))
            file:write(";")
        end
        file:write("\n")
    end
    file:close()
end

function get_input()

    local vx = 0
    local vy = 0

    if love.keyboard.isDown('w') then
        vy = player.speed * -1
    end

    if love.keyboard.isDown('s') then
        vy = player.speed * 1
    end

    if love.keyboard.isDown('a') then
        vx = player.speed * -1
    end

    if love.keyboard.isDown('d') then
        vx = player.speed * 1
    end

    player.collision_shape:setLinearVelocity(vx,vy)

    player.x = player.collision_shape:getX() - player.size/2
    player.y = player.collision_shape:getY() - player.size/2

end


function love.update(dt)
    get_input()
    cam:lookAt(player.x, player.y)
    world:update(dt)
end

function draw_map()

    for y = 1,map_size_x,1 do 
        for x = 1,map_size_y,1 do 
            love.graphics.setColor(1,0,1)

            if map[y][x] == -1 then
                love.graphics.setColor(0.08,0.42,0.9)
            end

            if map[y][x] == 0 then
                love.graphics.setColor(0.1,0.6,0.1)
            end

            if map[y][x] == 1 then
                love.graphics.setColor(0.6,0.1,0.1)
            end
            love.graphics.rectangle("fill", env.cell_width*(x-1),env.cell_height*(y-1), env.cell_width,env.cell_height)
        end
    end 
end

function map_collision()

    for x = 1,map_size_x,1 do 
        for y = 1,map_size_y,1 do 
            if map[y][x] == 1 then
                local wall = world:newRectangleCollider(env.cell_width*(x-1),env.cell_height*(y-1), env.cell_width,env.cell_height)
                wall:setType("static")
                table.insert(env.walls,wall)
            end
        end
    end 
end


function love.draw()
    cam:attach()

        draw_map()

        if generate then
            generate_world(64,64,99,0.05)
            generate = false
        end

        if map_collision_reload then
            map_collision()
            map_collision_reload = false
        end

        --world:draw()
        love.graphics.setColor(0.7,0,0)
        love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)
        love.graphics.setColor(1,1,1)
        love.graphics.print("hello world")
    cam:detach()

end