[{  
  :hut =>
  {:id => 1,
    :name => 'hut',
    :size => :small,
    :floors => 1,
    :max_hp => 30,
    :ap_recovery => +0.5,
    :build_ap => 40,
    :build_xp => 25,
    :build_skill => :construction,
    :materials => {:stick => 20, :staff => 5},
    
    :interior => "You are inside a crude hut. " +
    "Shafts of sunlight break through the wooden staves",
    :build_msg =>  "Planting the tall staves in the ground, you weave in the sticks to build a crude wooden hut."
  },
  
  :longhouse1 => 
  {:id => 21,
    :name => 'longhouse (1/2)',
    :size => :large,
    :floors => 0,
    :tools => [:stone_carpentry],
    :materials => {:timber => 12},
    :max_hp => 30,
    :settlement_level => :village,
    :build_skill => :construction,
    :build_ap => 50,
    :build_xp => 35,
    :build_msg => "You dig trenches for a foundation, then set to work building the walls of the longhouse. It isn't finished yet: you still need to build the roof."
  },
  
  :longhouse2 => 
  {:id => 2,
    :name => 'longhouse',
    :size => :large,
    :floors => 1,
    :tools => [:stone_carpentry],
    :ap_recovery => +1,
    :build_ap => 50,
    :build_xp => 35,
    :max_hp => 50,
    :settlement_level => :village,
    :prereq => :longhouse1,
    :build_skill => :construction,
    :materials => {:timber => 12},
    
    :interior => "You are inside a large wooden longhouse. " +
    "Pelts are strewn across the packed earth floor. " +
    "They look comfortable enough to sleep on",
    :build_msg => "You build the roof, and the longhouse is complete."
  },
  
  :stockpile =>
  {:id => 3,
    :name => 'stockpile',
    :size => :small,
    :floors => 0,
    :actions => [:take, :give],
    :max_hp => 10,
    :build_ap => 10,
    :build_xp => 3,
    :materials => {:stone => 8},
    :build_msg => "You stake out a stockpile on the ground."
  },
  
  :totem =>
  {:id => 4,
    :name => "totem pole",
    :special => :settlement,
    :size => :small,
    :floors => 0,
    :actions => [:join],
    :unwritable => true,
    
    :build_ap => 30,
    :build_xp => 0,
    :max_hp => 30,
    :materials => {:log => 1},
    :build_skill => :settling
  },
  
  :campfire =>
  {:id => 5,
    :name => 'campfire',
    :size => :tiny,
    :floors => 0,
    :actions => [:add_fuel],
    :unwritable => true,
    :ap_recovery => +0.3,
    :max_hp => 30,
    :build_hp => 15,
    :build_ap => 10,
    :build_xp_type => :wander,
    :build_xp => 5,
    :materials => {:stick => 10},
    :build_msg => "You rub two sticks together, gradually heating them up. Eventually you produce a few embers, and soon there is a roaring fire in front of you.",
  },
  
  :workshop =>
  {:id => 6,
    :name => 'workshop',
    :size => :large,
    :floors => 1,
    :build_skill => :artisanship,
    :build_ap => 25,
    :build_xp => 25,
    :max_hp => 50,
    :prereq => :longhouse2,
    :settlement_level => :village,
    :materials => {:timber => 6, :stone_carpentry => 4},
    
    :build_msg => "You assemble work benches and organise your tools, setting up a workshop in this building.",
    :interior => "You are inside a large wooden building. " +
    "Workbenches and carpentry tools are scattered around, " +
    "and scraps of timber are piled up in the corner"
  },
  
  :hospital =>
  {:id => 7,
    :name => 'hospital',
    :size => :large,
    :floors => 1,
    :build_ap => 25,
    :build_xp_type => :herbal,
    :build_xp => 25,
    :build_skill => :hospitaller,
    :prereq => :longhouse2,
    :settlement_level => :village,
    :max_hp => 50,
    :materials => {:thyme => 7, :bark => 7, :poultice => 7},
    
    :use_skill => :medicine,
    :effect_bonus => {:heal => 1.5, :revive => 1.5},
    :craft_ap_bonus => {:heal => 0.7, :revive => 0.7},
    
    :build_msg => "You organise your medicinal supplies and establish a hospital in this building.",
    :interior => "You are inside a large wooden building. " +
    "Various medicinal supplies are arranged here, " +
    "and dried herbs hang from the ceiling"
  },
  
  :signpost =>
  {:id => 8,
    :name => 'signpost',
    :size => :tiny,
    :floors => 0,
    :max_hp => 5,
    :build_skill => :trailblazing,
    :build_ap => 8,
    :build_xp => 5,
    :materials => {:timber => 2},
    :build_msg => "You build a signpost."
  },
  
  :field => 
  {:id => 9,
    :name => 'field',
    :special => :terrain,
    :terrain_type => :empty_field,
    :tools => [:digging_stick],
    :build_hp => 4,
    :build_ap => 30,
    :build_xp => 10,
    :build_xp_type => :herbal,
    :build_skill => :agriculture,
    :build_msg => "It's tiring work, but you manage to turn over the soil in the area, leaving several furrows in which to plant crops. The newly ploughed soil is rich and fertile."
  },
  
  :dirt_track => 
  {:id => 10,
    :name => 'dirt track',
    :special => :terrain,
    :terrain_type => :dirt_track,
    :tools => [:digging_stick],
    :build_hp => 0,
    :build_ap => 20,
    :build_xp => 12,
    :build_skill => :trailblazing,
    :build_msg => "It's tiring work, but you manage to remove the turf in the area, leaving a dirt track."
  },
  
  :hunters_shrine =>
  {:id => 11,
    :name => "hunter's shrine",
    :size => :small,
    :prereq => :hut,
    :floors => 1,
    :max_hp => 50,
    :ap_recovery => +1,
    :build_ap => 50,
    :build_xp => 50,
    :build_skill => :divine_inspiration,
    :materials => {:pelt => 1,  :small_pelt => 1, :stone_spear => 3, :sabre_tooth => 2, :wolf_pelt => 1, :lion_pelt => 1, :bear_skin => 1, :croc_skin => 1, :horn => 2, :antler => 2},
    
    :build_msg =>  "Incanting the ritual words of the hunter's song, you make your offering to the animal spirits. You sense that they are pleased with your gifts; this building is now a shrine for all hunters.",
    :interior => "You are in a wooden shrine, decorated with hunter's trophies. " +
    "A faint echo of birdsong catches your ear. " +
    "Despite the tranquil atmosphere within this building, " +
    "you tread carefully, fearful of angering the animal spirits"
  },
  
  :stonemasonry =>
  {:id => 12,
    :name => 'stonemasonry',
    :size => :large,
    :floors => 1,
    :max_hp => 50,
    
    :build_skill => :masonry,
    :build_ap => 35,
    :build_xp => 35,
    :prereq => :workshop,
    :settlement_level => :village,
    :materials => {:boulder => 2, :stone => 6, :masonry_tools => 4},
    
    :build_msg => "You assemble work benches and organise your tools, " +
    "setting up a stonemasonry in this building.",
    :interior => "You are inside a large wooden building. " +
    "Workbenches and stone-working tools are lying around, " +
    "and chips of stone are scattered across the floor"
  },
  
  :cottage1 =>
  {:id => 131,
    :name => 'cottage (1/2)',
    :size => :small,
    :floors => 0,
    :max_hp => 40,
    
    :build_ap => 50,
    :build_xp => 35,
    :build_skill => :masonry,
    :tools => [:masonry_tools],
    :materials => {:stone_block => 6},
    :build_msg =>  "You dig trenches for a foundation, then set to work building the walls of the cottage. It isn't finished yet: you still need to build the roof."
  },
  
  :cottage2 => 
  {:id => 13,
    :name => 'cottage',
    :size => :small,
    :floors => 1,
    :ap_recovery => +1,
    :max_hp => 70,
    
    :build_ap => 50,
    :build_xp => 35,
    :prereq => :cottage1,
    :build_skill => :construction,
    :materials => {:timber => 10},
    :build_msg => "You build the roof, and the cottage is complete.",
    :interior => "You are inside a cosy stone cottage. " +
    "Sunlight streams through the open doorway"
  },
  
  :kiln =>
  {:id => 14,
    :name => 'kiln',
    :size => :small,
    :floors => 0,
    :max_hp => 50,
    :settlement_level => :village,
    :build_ap => 50,
    :build_xp => 35,
    :build_skill => :masonry,
    :tools => [:masonry_tools],
    :materials => {:stone_block => 7},
    :build_msg =>  "Digging a small firepit in the ground, you build a stone covering around and over it, creating a kiln."
  },
  
  :bakery =>
  {:id => 15,
    :name => 'bakery',
    :size => :big,
    :floors => 1,
    :max_hp => 50,
    :settlement_level => :village,
    :prereq => :longhouse2,
    
    :build_ap => 50,
    :build_xp => 35,
    :build_skill => :masonry,
    :tools => [:masonry_tools],
    :materials => {:stone_block => 7},
    :build_msg =>  "You build a stone oven in the building, " +
    "converting it into a bakery.",
    :interior => "You are inside a wooden building. " +
    "The smell of baking bread hits your nose and a pleasant warmth fills the air"
  },

  :fertility_shrine =>
  {:id => 16,
    :name => "fertility shrine",
    :size => :small,
    :prereq => :hut,
    :floors => 1,
    :max_hp => 50,
    :ap_recovery => +1,
    :build_ap => 50,
    :build_xp => 50,
    :build_skill => :divine_inspiration,
    :materials => {:water_pot => 3,  :wheat => 10, :stone_sickle => 3, :poultice => 10, :tea => 10,},
    
    :build_msg =>  "Placing your offerings on a small altar, you ask for the blessings of the spirits of fertility. You sense that they are pleased with your gifts; this building is now a fertility shrine.",
    :interior => "You are in a wooden shrine decorated with offerings to the fertility spirits. " +
    "Fresh food sits on a small altar, offerings to the fertility spirits in hopes of a bountiful harvest. " +
    "You feel at peace within the shrine's walls"
  },
   
   :wall =>
  {:id => 17,
    :name => 'stone wall',
    :max_hp => 80,
    :size => :large,
    :special => :walls,
    :terrain_type => :wall,
    :build_ap => 50,
    :build_xp => 35,
    :build_skill => :masonry,
    :tools => [:masonry_tools],
    :materials => {:stone_block => 8},
    :build_msg =>  "You carefully survey the ground before you, and set the stone blocks into a sturdy stone wall."
  },

   :guardstand1 =>
  {:id => 171,
    :name => 'guard stand (1/2)',
    :max_hp => 40,
    :special => :walls,
    :terrain_type => :wall_low,
    :size => :large,
    :settlement_level => :village,
    :build_ap => 50,
    :build_xp => 35,
    :build_skill => :masonry,
    :tools => [:masonry_tools],
    :materials => {:stone_block => 5},
    :build_msg =>  "You dig trenches for a foundation, then set to work building the walls of the guard stand. It isn't finished yet: you still need to build the roof and ladder."
  },

   :guardstand2 =>
  {:id => 172,
    :name => 'guard stand',
    :max_hp => 70,
    :prereq => :guardstand1,
    :special => :walls,
    :terrain_type => :wall_low,
    :size => :tiny,
    :floors => 1,
    :settlement_level => :village,
    :ap_recovery => +0.5,
    :build_ap => 50,
    :build_xp => 35,
    :build_skill => :construction,
    :materials => {:timber => 8},
    :tools => [:stone_carpentry],
    :build_msg => "You build the roof and ladder, and the guard stand is complete.",
    :interior => "You are inside a sparsely-equipped, stone guard stand. " +
    "Sunlight streams through the open doorway"
  },
  
  :ruin =>
  {:id => 18,
    :name => 'ruined building',
    :special => :ruins,
    :size => :large,
    :floors => 1,
    :max_hp => 100,
    :ap_recovery => +0.3,
    :build_skill => :god_powers,
    :interior => "You are inside a ruined building within the village. The air is acrid, " +
    "and the lack of light makes it hard to tell if there may be anything of value amongst " +
    "the rubble"
  },

   :gatehouse1 =>
  {:id => 191,
    :name => 'gate house (1/2)',
    :max_hp => 40,
    :special => :walls,
    :terrain_type => :gate_open,
    :size => :large,
    :settlement_level => :village,
    :build_ap => 50,
    :build_xp => 35,
    :build_skill => :masonry,
    :tools => [:masonry_tools],
    :materials => {:stone_block => 6},
    :build_msg =>  "You dig trenches for a foundation, then set to work building the stone walls and archway. It isn't finished yet: you still need to build the actual gate."
  },

   :gatehouse2 =>
  {:id => 19,
    :name => 'gate house',
    :max_hp => 70,
    :prereq => :gatehouse1,
    :special => :walls,
    :terrain_type => :gate,
    :size => :tiny,
    :floors => 0,
    :settlement_level => :village,
    :build_ap => 50,
    :build_xp => 35,
    :build_skill => :construction,
    :materials => {:timber => 12},
    :tools => [:stone_carpentry],
    :build_msg => "You craft the gate and fix it into the stone walls, and the gate house is complete.",
  },
}]
