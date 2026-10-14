# delta since last tick (milliblocks/tick); skip teleports
scoreboard players operation #dx eh = #x eh
scoreboard players operation #dx eh -= @s eh.px
scoreboard players operation #dy eh = #y eh
scoreboard players operation #dy eh -= @s eh.py
scoreboard players operation #dz eh = #z eh
scoreboard players operation #dz eh -= @s eh.pz
execute unless score #dx eh matches -10000..10000 run return 0
execute unless score #dy eh matches -10000..10000 run return 0
execute unless score #dz eh matches -10000..10000 run return 0

# n = dx^2 + dy^2 + dz^2
scoreboard players operation #n eh = #dx eh
scoreboard players operation #n eh *= #dx eh
scoreboard players operation #t eh = #dy eh
scoreboard players operation #t eh *= #dy eh
scoreboard players operation #n eh += #t eh
scoreboard players operation #t eh = #dz eh
scoreboard players operation #t eh *= #dz eh
scoreboard players operation #n eh += #t eh

# g = sqrt(n), Newton from 1500 (8 steps: within 0.1 b/s)
scoreboard players set #g eh 1500
function elytra_hud:newton
function elytra_hud:newton
function elytra_hud:newton
function elytra_hud:newton
function elytra_hud:newton
function elytra_hud:newton
function elytra_hud:newton
function elytra_hud:newton

# speed in 0.1 b/s: mb/tick * 20 / 100 = /5
scoreboard players operation #g eh /= #5 eh
scoreboard players operation #si eh = #g eh
scoreboard players operation #si eh /= #10 eh
scoreboard players operation #sf eh = #g eh
scoreboard players operation #sf eh %= #10 eh

# climb rate in 0.1 b/s, as sign + magnitude
execute store success score #up eh if score #dy eh matches 0..
execute if score #up eh matches 0 run scoreboard players operation #dy eh *= #-1 eh
scoreboard players operation #dy eh /= #5 eh
scoreboard players operation #vi eh = #dy eh
scoreboard players operation #vi eh /= #10 eh
scoreboard players operation #vf eh = #dy eh
scoreboard players operation #vf eh %= #10 eh

# altitude
scoreboard players operation #alt eh = #y eh
scoreboard players operation #alt eh /= #1000 eh

execute if score #up eh matches 1 run title @s actionbar [{"text":"Speed ","color":"gray"},{"score":{"name":"#si","objective":"eh"},"color":"white"},{"text":".","color":"white"},{"score":{"name":"#sf","objective":"eh"},"color":"white"},{"text":" b/s   Y ","color":"gray"},{"score":{"name":"#alt","objective":"eh"},"color":"white"},{"text":"   ▲ ","color":"green"},{"score":{"name":"#vi","objective":"eh"},"color":"green"},{"text":".","color":"green"},{"score":{"name":"#vf","objective":"eh"},"color":"green"},{"text":" b/s","color":"gray"}]
execute if score #up eh matches 0 run title @s actionbar [{"text":"Speed ","color":"gray"},{"score":{"name":"#si","objective":"eh"},"color":"white"},{"text":".","color":"white"},{"score":{"name":"#sf","objective":"eh"},"color":"white"},{"text":" b/s   Y ","color":"gray"},{"score":{"name":"#alt","objective":"eh"},"color":"white"},{"text":"   ▼ ","color":"red"},{"score":{"name":"#vi","objective":"eh"},"color":"red"},{"text":".","color":"red"},{"score":{"name":"#vf","objective":"eh"},"color":"red"},{"text":" b/s","color":"gray"}]
