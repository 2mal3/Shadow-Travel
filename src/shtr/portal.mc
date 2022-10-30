import ../../macros/log.mcm


clock 1s {
  name clock

  execute as @a[gamemode=!spectator] at @s run {
    scoreboard players remove @s[scores={shtr.portalCooldown=1..}] shtr.portalCooldown 1

    execute if predicate shtr:utilities/in_overworld run {
      execute(if predicate shtr:portal/in_darkness) {
        scoreboard players add @s shtr.darknessTime 1
      } else {
        execute if score @s shtr.darknessTime matches 1.. run scoreboard players reset @s shtr.darknessTime
      }

      execute if score @s shtr.darknessTime matches 60.. if predicate shtr:utilities/random/10 unless entity @e[type=minecraft:marker,tag=shtr.portal,distance=..128] run function shtr:portal/create
    }
  }

  execute as @e[type=minecraft:marker,tag=shtr.portal] at @s run {
    LOOP(64, i) {
      particle minecraft:portal ~<%Math.sin(i*360)*0.75%> ~1.5 ~<%Math.cos(i*360)*0.75%> 0 -1.5 0 1 0 force
    }
    particle minecraft:end_rod ~ ~0.1 ~ 0 0.1 0 1 0 force
    execute if entity @s[tag=shtr.shadow] run playsound minecraft:ambient.soul_sand_valley.mood block @a ~ ~ ~ 0.5 0.1

    execute if entity @s[tag=shtr.overworld] as @p[distance=..0.5] unless score @s shtr.portalCooldown matches 1.. at @s run function shtr:portal/change/overworld
    execute if entity @s[tag=shtr.shadow] as @p[distance=..0.5] unless score @s shtr.portalCooldown matches 1.. at @s run function shtr:portal/change/shadow

    execute if predicate shtr:utilities/in_overworld unless predicate shtr:portal/in_darkness run function shtr:portal/destroy
  }
}

predicate in_darkness {
  "condition": "minecraft:location_check",
  "predicate": {
    "light": {
      "light": 0
    }
  }
}


function destroy {
  log ShadowTravel info entity <Destroyed Portal>

  stopsound @a[distance=..5] block minecraft:ambient.soul_sand_valley.mood
  playsound minecraft:item.bottle.empty block @a ~ ~ ~ 1 2
  playsound minecraft:block.sculk_sensor.clicking block @a ~ ~ ~ 1 2

  LOOP(32,i){
    particle minecraft:item black_concrete ~ ~ ~ <%Math.sin(i*360)*0.75%> 1 <%Math.cos(i*360)*0.75%> 0.25 0 force
  }

  execute in shtr:shadow_lands run kill @e[type=minecraft:marker,tag=shtr.portal,distance=..0.5]
  kill @s
}


function create {
  log ShadowTravel info entity <Created portal>
  scoreboard players set @s shtr.portalCooldown 5

  playsound minecraft:block.respawn_anchor.charge block @a ~ ~ ~ 1 0.1
  playsound minecraft:item.lodestone_compass.lock block @a ~ ~ ~ 1 0.1
  playsound minecraft:block.beacon.power_select block @a ~ ~ ~ 1 0.1

  execute in minecraft:overworld run summon minecraft:marker ~ ~ ~ {Tags:["shtr.portal", "shtr.shadow"]}
  execute in shtr:shadow_lands run {
    forceload add ~ ~
    summon minecraft:marker ~ ~ ~ {Tags:["shtr.portal", "shtr.overworld", "shtr.init"]}
  }
}


dir change {
  function change {
    scoreboard players set @s shtr.portalCooldown 10
    effect give @s minecraft:blindness 1 0 true

    playsound minecraft:entity.ender_eye.death master @s ~ ~ ~ 1 0.5
    playsound minecraft:block.beacon.power_select master @s ~ ~ ~ 1 1

    tag @s add shtr.particle
    schedule 10t replace {
      execute as @a[tag=shtr.particle] at @s run {
        tag @s remove shtr.particle
        particle minecraft:enchant ~ ~1.5 ~ 0 0 0 2 50
      }
    }
  }

  function overworld {
    execute at @e[type=minecraft:marker,tag=shtr.portal,sort=nearest,limit=1] in minecraft:overworld run {
      tp @s ~ ~ ~
      function shtr:portal/change/change
    }
  }

  function shadow {
    execute at @e[type=minecraft:marker,tag=shtr.portal,sort=nearest,limit=1] in shtr:shadow_lands run {
      tp @s ~ ~ ~
      function shtr:portal/change/change

      execute if entity @e[type=minecraft:marker,tag=shtr.init] run {
        log ShadowTravel debug entity <First travel through portal>

        function shtr:shadow/place
        setblock ~ ~ ~ minecraft:light[level=15]
        effect give @s minecraft:levitation 5 255 true

        execute(if entity @e[type=minecraft:marker,tag=shtr.overworld,tag=!shtr.init]) {
          log ShadowTravel debug server <Other portal found>
          schedule function shtr:portal/generate/init 1s replace
        } else {
          log ShadowTravel debug server <No other portal found>
          tag @e[type=minecraft:marker,tag=shtr.init] remove shtr.init
        }
      }
    }
  }
}


dir generate {
  function init {
    log ShadowTravel debug server <Generate new paths>

    tag @e[type=minecraft:marker,tag=shtr.overworld,tag=!shtr.init] add shtr.pathTo
    function shtr:portal/generate/clock
  }

  function clock {
    log ShadowTravel debug server <Generate path>

    execute as @e[type=minecraft:marker,tag=shtr.pathTo,sort=random,limit=1] run {
      tag @s remove shtr.pathTo

      execute store result score $x shtr.data run data get entity @s Pos[0]
      execute store result score $y shtr.data run data get entity @s Pos[1]
      execute store result score $z shtr.data run data get entity @s Pos[2]
    }
    execute as @e[type=minecraft:marker,tag=shtr.overworld,tag=shtr.init] at @s run function shtr:path/marker

    function shtr:path/clock

    execute(if entity @e[type=minecraft:marker,tag=shtr.pathTo]) {
      schedule function shtr:portal/generate/clock 1s replace
    } else {
      tag @e[type=minecraft:marker,tag=shtr.init] remove shtr.init
    }
  }
}
