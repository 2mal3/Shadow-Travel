
predicate in_overworld {
  "condition": "minecraft:location_check",
  "predicate": {
    "dimension": "minecraft:overworld"
  }
}

predicate in_shadow_lands {
  "condition": "minecraft:location_check",
  "predicate": {
    "dimension": "shtr:shadow_lands"
  }
}


dir random {
  predicate 10 {
    "condition": "minecraft:random_chance",
    "chance": 0.1
  }

  predicate 20 {
    "condition": "minecraft:random_chance",
    "chance": 0.2
  }

  predicate 50 {
    "condition": "minecraft:random_chance",
    "chance": 0.5
  }
}


function random {
  # Generate random number
  scoreboard players operation .rng shtr.random *= $multiplier shtr.random
  scoreboard players operation .rng shtr.random += $increment shtr.random

  # Swap bits
  scoreboard players operation .bitSwap shtr.random = .rng shtr.random
  scoreboard players operation .bitSwap shtr.random /= $65536 shtr.random
  scoreboard players operation .rng shtr.random *= $65536 shtr.random
  scoreboard players operation .rng shtr.random += .bitSwap shtr.random

  # Return output
  scoreboard players operation .temp0 shtr.data = .in1 shtr.data
  scoreboard players operation .temp0 shtr.data -= .in0 shtr.data
  scoreboard players add .temp0 shtr.data 1
  scoreboard players operation .out0 shtr.data = .rng shtr.random
  scoreboard players operation .out0 shtr.data %= .temp0 shtr.data
  scoreboard players operation .out0 shtr.data += .in0 shtr.data
}
