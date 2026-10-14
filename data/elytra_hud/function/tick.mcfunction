scoreboard players enable @a elytra_hud
execute as @a[scores={elytra_hud=1..}] run function elytra_hud:toggle
execute as @a[predicate=elytra_hud:gliding] unless score @s eh.off matches 1 run function elytra_hud:glide
execute as @a[scores={eh.was=1},predicate=!elytra_hud:gliding] run scoreboard players reset @s eh.was
