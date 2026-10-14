execute store success score #t eh unless score @s eh.off matches 1
scoreboard players operation @s eh.off = #t eh
scoreboard players reset @s eh.was
scoreboard players set @s elytra_hud 0
execute if score @s eh.off matches 1 run tellraw @s {"text":"Elytra HUD off","color":"gray"}
execute unless score @s eh.off matches 1 run tellraw @s {"text":"Elytra HUD on","color":"green"}
