
advancement shadow_lands {
  "display": {
    "icon": {
      "item": "minecraft:black_concrete"
    },
    "title": "The Shadow Lands",
    "description": [
      "Enter the Shadow Lands by standing in the dark for too long",
      {
        "text": "\nShadow Travel",
        "color": "gray",
        "italic": true
      }
    ]
  },
  "parent": "minecraft:adventure/root",
  "criteria": {
    "requirement": {
      "trigger": "minecraft:changed_dimension",
      "conditions": {
        "to": "shtr:shadow_lands"
      }
    }
  }
}
