
dir clock {
  clock 1s {
    name 1s

    execute as @a at @s run {
      execute if predicate shtr:utilities/in_shadow_lands run {
        scoreboard players add @s shtr.shadowTime 1

        execute if score @s shtr.shadowTime matches 120 run {
          LOOP(3, i) {
            summon minecraft:phantom ~ ~20 ~
          }
        }
        execute if score @s shtr.shadowTime matches 180.. run effect give @s minecraft:wither 2 1 true
      }
      execute unless predicate shtr:utilities/in_shadow_lands run {
        execute if score @s shtr.shadowTime matches 1.. run scoreboard players reset @s shtr.shadowTime
      }
    }

    execute as @e[type=minecraft:marker,tag=shtr.path] at @s run {
      tag @s remove shtr.path
      tag @s add shtr.island

      execute(if entity @e[type=minecraft:marker,tag=shtr.island,tag=!shtr.work,distance=0.1..4]) {
        kill @s
      } else {
        function shtr:shadow/place
      }
    }

    tag @e[type=minecraft:marker,tag=shtr.work] remove shtr.work
  }
}


function place {
  # Build base structure
  fill ~-1 ~-1 ~-1 ~1 ~-1 ~1 minecraft:blackstone
  fill ~ ~-1 ~ ~ ~-4 ~ minecraft:blackstone

  setblock ~1 ~-2 ~ minecraft:blackstone
  setblock ~-1 ~-2 ~ minecraft:blackstone
  setblock ~ ~-2 ~1 minecraft:blackstone
  setblock ~ ~-2 ~-1 minecraft:blackstone
  execute if predicate shtr:utilities/random/50 run setblock ~1 ~-3 ~ minecraft:blackstone
  execute if predicate shtr:utilities/random/50 run setblock ~-1 ~-3 ~ minecraft:blackstone
  execute if predicate shtr:utilities/random/50 run setblock ~ ~-3 ~1 minecraft:blackstone
  execute if predicate shtr:utilities/random/50 run setblock ~ ~-3 ~-1 minecraft:blackstone

  execute if predicate shtr:utilities/random/20 run setblock ~1 ~-2 ~1 minecraft:blackstone_wall
  execute if predicate shtr:utilities/random/20 run setblock ~1 ~-2 ~-1 minecraft:blackstone_wall
  execute if predicate shtr:utilities/random/20 run setblock ~-1 ~-2 ~-1 minecraft:blackstone_wall
  execute if predicate shtr:utilities/random/20 run setblock ~-1 ~-2 ~1 minecraft:blackstone_wall

  # Replace with random blocks
  execute positioned ~-1 ~-4 ~-1 run {
    LOOP(3, x) {
      LOOP(4, y) {
        LOOP(3, z) {
          execute unless block ~<%x%> ~<%y%> ~<%z%> minecraft:air run {
            eq .in0 shtr.data = 0
            eq .in1 shtr.data = 8
            function shtr:utilities/random

            execute if score .out0 shtr.data matches 0..3 run setblock ~<%x%> ~<%y%> ~<%z%> minecraft:blackstone
            execute if score .out0 shtr.data matches 4 run setblock ~<%x%> ~<%y%> ~<%z%> minecraft:polished_blackstone
            execute if score .out0 shtr.data matches 5 run setblock ~<%x%> ~<%y%> ~<%z%> minecraft:deepslate_bricks
            execute if score .out0 shtr.data matches 7 run setblock ~<%x%> ~<%y%> ~<%z%> minecraft:polished_blackstone_bricks
            execute if score .out0 shtr.data matches 8 run setblock ~<%x%> ~<%y%> ~<%z%> minecraft:deepslate_tiles
          }
        }
      }
    }
  }

  # Destroy a bit
}
