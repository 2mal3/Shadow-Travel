import ../../macros/log.mcm


function load {
  log ShadowTravel info server <Datapack reloaded>

  scoreboard objectives add shtr.data dummy

  # Initializes the datapack at the first startup or new version
  execute unless score %installed shtr.data matches 1 run {
    name install

    log ShadowTravel info server <Datapack installed>
    scoreboard players set %installed shtr.data 1

    scoreboard objectives add shtr.data dummy
    scoreboard objectives add shtr.random dummy
    scoreboard objectives add shtr.portalCooldown dummy
    scoreboard objectives add shtr.darknessTime dummy
    scoreboard objectives add shtr.shadowTime dummy
    scoreboard objectives add 2mal3.debugMode dummy
    #declare score_holder .temp0
    #declare score_holder .temp1
    schedule 1s replace {
      scoreboard players set _1 const -1
    }
    #declare storage shtr:data
    data merge storage shtr:data {root:{directions:{}}}
    # Set the version in format: xx.xx.xx
    scoreboard players set $version shtr.data 000100
    # Set up random number generator
    execute store result score .rng shtr.random run seed
    scoreboard players set $65536 shtr.random 65536
    scoreboard players set $multiplier shtr.random 1664525
    scoreboard players set $increment shtr.random 1013904223
    scoreboard players set .bitSwap shtr.random 0

    gamerule maxCommandChainLength 999999999

    schedule 4s replace {
      tellraw @a {"text":"Shadow Travel Datapack v0.1.0 by 2mal3 was installed!","color":"green"}
    }
  }
  execute if score %installed shtr.data matches 1 unless score $version shtr.data matches 000100 run {
    log ShadowTravel info server <Updated datapack>
    scoreboard players set $version shtr.data 000100
  }
}


advancement shtr {
  "display": {
    "title": "Shadow Travel v0.1.0",
    "description": "Travel through the world with the help of the shadows",
    "icon": {
      "item": "minecraft:black_concrete"
    },
    "announce_to_chat": false,
    "show_toast": false
  },
  "parent": "global:2mal3",
  "criteria": {
    "trigger": {
      "trigger": "minecraft:tick"
    }
  }
}


function uninstall {
  log ShadowTravel info server <Datapack uninstalled>

  # Deletes the scoreboards
  scoreboard objectives remove shtr.data
  scoreboard objectives remove shtr.random
  scoreboard objectives remove shtr.portalCooldown
  scoreboard objectives remove shtr.darknessTime
  scoreboard objectives remove shtr.shadowTime
  scoreboard objectives remove 2mal3.debugMode

  # Delete entities
  kill @e[type=minecraft:marker,tag=shtr.portal]
  kill @e[type=minecraft:marker,tag=shtr.island]

  # Sends an uninstallation message to all players
  tellraw @a {"text":"Shadow Travel Datapack v0.1.0 by 2mal3 was successfully uninstalled.","color": "green"}

  # Disables the datapack
  datapack disable "file/Shadow-Travel"
  datapack disable "file/Shadow-Travel.zip"
}
