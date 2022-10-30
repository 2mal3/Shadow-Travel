import ../../macros/option.mcm
import ../../macros/log.mcm


function clock {
  execute as @e[type=minecraft:marker,tag=shtr.current] at @s run {
    tag @s remove shtr.current

    # Get the distance to the target
    execute store result score .x shtr.data run data get entity @s Pos[0]
    execute store result score .y shtr.data run data get entity @s Pos[1]
    execute store result score .z shtr.data run data get entity @s Pos[2]
    eq .dx shtr.data = $x shtr.data - .x shtr.data
    eq .dy shtr.data = $y shtr.data - .y shtr.data
    eq .dz shtr.data = $z shtr.data - .z shtr.data


    eq .length shtr.data = 0
    # Determines the possible directions in which the path could move
    data merge storage shtr:data {root:{directions:[]}}
    option x +
    option x -
    option z +
    option z -
    option y +
    option y -

    # eq .temp1 shtr.data = .length shtr.data / 10
    # block {
    #   execute if block ~ ~-2 ~ minecraft:air if block ~ ~2 ~ minecraft:air run option y +
    #   execute if block ~ ~-2 ~ minecraft:air if block ~ ~2 ~ minecraft:air run option y -

    #   scoreboard players remove .temp1 shtr.data 1
    #   execute if score .temp1 shtr.data matches 1.. run function $block
    # }

    # Choose a random and possible direction
    eq .in0 shtr.data = 0
    eq .in1 shtr.data = .length shtr.data
    function shtr:utilities/random
    eq .temp0 shtr.data = .out0 shtr.data

    block {
      name remove

      execute if score .temp0 shtr.data matches 2.. run {
        data remove storage shtr:data root.directions[0]
        scoreboard players remove .temp0 shtr.data 1
        function shtr:path/remove
      }
    }

    # tellraw @p {"nbt":"root.directions[0]","storage":"shtr:data"}
    execute if data storage shtr:data root.directions[0].+x positioned ~4 ~ ~ run function shtr:path/marker
    execute if data storage shtr:data root.directions[0].-x positioned ~-4 ~ ~ run function shtr:path/marker
    execute if data storage shtr:data root.directions[0].+y positioned ~ ~1 ~ run function shtr:path/marker
    execute if data storage shtr:data root.directions[0].-y positioned ~ ~-1 ~ run function shtr:path/marker
    execute if data storage shtr:data root.directions[0].+z positioned ~ ~ ~4 run function shtr:path/marker
    execute if data storage shtr:data root.directions[0].-z positioned ~ ~ ~-4 run function shtr:path/marker

    eq .temp0 shtr.data = .dx shtr.data
    eq .temp1 shtr.data = .dy shtr.data
    eq .temp2 shtr.data = .dz shtr.data
    execute if score .temp0 shtr.data matches ..-1 run scoreboard players operation .temp0 shtr.data *= _1 const
    execute if score .temp1 shtr.data matches ..-1 run scoreboard players operation .temp1 shtr.data *= _1 const
    execute if score .temp2 shtr.data matches ..-1 run scoreboard players operation .temp2 shtr.data *= _1 const

    eq .temp3 shtr.data = 0
    execute if score .temp0 shtr.data matches ..5 if score .temp1 shtr.data matches ..1 if score .temp2 shtr.data matches ..5 run eq .temp3 shtr.data = 1
    execute if score .temp3 shtr.data matches 0 run function shtr:path/clock
  }
}


function marker {
  summon minecraft:marker ~ ~ ~ {Tags: ["shtr.path", "shtr.current", "shtr.work"]}
}
