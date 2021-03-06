-- SPEC ID 266
NetherMachine.rotation.register(266, {

  --------------------
  -- Start Rotation --
  --------------------
  
  -- Something Something Buffs
  { "Dark Intent", "!player.buff(Dark Intent)" },
  { "Curse of the Elements", "!target.debuff(Curse of the Elements)" },

  -- Cooldowns
  { "Summon Doomguard", "modifier.cooldowns" },

  -- Rotation
  { "Command Demon", "pet.energy > 60" },

  -- Metamorphosis Rotation
  {{
  { "Immolation Aura", "modifier.multitarget" },
  { "Dark Soul: Knowledge", "modifier.cooldowns" },
  { "Corruption", "target.debuff(Doom).duration < 10" },
  { "Soul Fire", "player.buff(Molten Core)" },
  
  { "/cancelaura Metamorphosis", { 
    "player.demonicfury < 700", 
    "!player.buff(Dark Soul: Knowledge)",
  }},
  
  { "Void Ray", "modifier.multitarget" },
  { "Shadow Bolt" },
  
  }, "player.buff(Metamorphosis)" },

  -- Regular Rotation (w/o Meta)
  {{
  { "Life Tap", { 
    "player.mana < 40", 
    "player.health > 70",
  }},
  
  { "Corruption", "!target.debuff(Corruption)" },
  { "Metamorphosis", "player.demonicfury > 900" },
  { "Hand of Gul'dan", "!target.debuff(Shadowflame)" },
  { "Soul Fire", "player.buff(Molten Core)" },
  { "Harvest Life", "modifier.multitarget" },
  { "Shadow Bolt" }
  }, "!player.buff(Metamorphosis)" },
  
  ------------------
  -- End Rotation --
  ------------------

})