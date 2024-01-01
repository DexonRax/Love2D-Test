function get_input()
    if love.keyboard.isDown('w') then
        player.y = player.y - player.speed
    end

    if love.keyboard.isDown('s') then
        player.y = player.y + player.speed
    end

    if love.keyboard.isDown('a') then
        player.x = player.x - player.speed
    end

    if love.keyboard.isDown('d') then
        player.x = player.x + player.speed
    end
end

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

    map = readMapFile("map.txt")
    map_size_x = #map 
    map_size_y = #map[1] 
    --print(str(map_size_x)+ " "+str(map_size_y))
    print(map)
    player = {}
    player.x = 10
    player.y = 10
    player.speed = 1
    player.size = 64

    world = {}

    world.cell_width = 64
    world.cell_height = 64

end




function love.update(dt)
    get_input()
end


function love.draw()

    --draw world
    --love.graphics.setColor(0.1,0.6,0.1)
    for x = 1,map_size_x,1 do 
        for y = 1,map_size_y,1 do 
            love.graphics.setColor(0,0,1)
            if map[y][x] == 0 then
                love.graphics.setColor(0.1,0.6,0.1)
            end

            if map[y][x] == 1 then
                love.graphics.setColor(0.6,0.1,0.1)
            end
            love.graphics.rectangle("fill", world.cell_width*(x-1),world.cell_height*(y-1), world.cell_width,world.cell_height)
        end
    end


    --draw player
    love.graphics.setColor(0.7,0,0)
    love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)

    love.graphics.setColor(1,1,1)
    --love.graphics.print("hello world")
    --love.graphics.print(map)
    --love.graphics.print(map[1][1])

end