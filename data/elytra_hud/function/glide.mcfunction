# position in milliblocks.
# ponytail: int scores saturate beyond +-2,147,483 blocks from 0,0; HUD reads 0 there.
execute store result score #x eh run data get entity @s Pos[0] 1000
execute store result score #y eh run data get entity @s Pos[1] 1000
execute store result score #z eh run data get entity @s Pos[2] 1000
execute if score @s eh.was matches 1 run function elytra_hud:show
scoreboard players operation @s eh.px = #x eh
scoreboard players operation @s eh.py = #y eh
scoreboard players operation @s eh.pz = #z eh
scoreboard players set @s eh.was 1
