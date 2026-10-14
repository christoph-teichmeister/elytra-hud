# g = (g + n/g) / 2 ; stop at 0 (n = 0)
execute if score #g eh matches 0 run return 0
scoreboard players operation #t eh = #n eh
scoreboard players operation #t eh /= #g eh
scoreboard players operation #g eh += #t eh
scoreboard players operation #g eh /= #2 eh
