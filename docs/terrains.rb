[{
  :grassland =>
  {:id => 1,
    :ap => 1,
    :altitude => 0,
    :image => 'p_grass.jpg',
    :build_tiny? => true,
    :build_small? => true,
    :build_large? => true,
    :class => :open,
    :search => {:onion => 3, :thyme => 18, :wheat => 6},
    :dig => {:onion => 25},
    :actions => [:dig],
    :Spring => 'You are walking through a verdant grassland. Some small flowers are starting to grow here.',
    :Summer => 'You are walking through a verdant grassland, with many dandelions and other flowers. Crickets are chirping in the long grass.',
    :Autumn => 'You are walking through a grassland. The cold weather is beginning to turn the grass brown.',
    :Winter => 'You are walking through a grassland. Frost has hardened the ground, and there is little sign of life.',
  },
  
  :forest =>
  {:id => 2,
    :ap => {:forest_walk => 1, :default => 2},
    :xp => 0.2,
    :altitude => 0,
    :image => 'p_forest.jpg',
    :class => :forest,
    :transition => :thick_forest,
    :transition_odds => {:default => 0, :Spring => 15, :Summer => 30},
    :build_tiny? => true,
    :build_small? => true,
    :actions => [:chop_tree],
    :search => {:stick => 25, :staff => 8, :bark => 10, :chestnut => 15},
    :Spring => 'You are in a forest. Shafts of sunlight shine through the trees.',
    :Summer => 'You are in a forest. The leafy tree cover overhead provides some shade from the hot sun.',
    :Autumn => 'You are in a forest, walking through a thick carpet of orange and brown leaves.',
    :Winter => 'You are in a forest. The bare branches of the trees are stark against the winter sky.',
  },
  
  :pine_forest_1 =>
  {:id => 21,
    :ap => 1,
    :xp => 0.1,
    :altitude => 0,
    :image => 'p_lightforest.jpg',
    :class => :forest,
    :transition => :pine_forest_2,
    :transition_odds => {:default => 0, :Spring => 25, :Summer => 40},
    :build_tiny? => true,
    :build_small? => true,
    :actions => [:chop_tree],
    :search => {:stick => 25, :staff => 8},
    
    :description => 'A number of tall pine trees tower above you here.',
    :Autumn => 'A number of tall pine trees tower above you here, ' +
    'and pine cones crunch underfoot.',
    :Winter => 'A number of tall pine trees tower above you here, ' +
    'with snow hanging off the branches of the trees.',
  },
  
  :pine_forest_2 =>
  {:id => 22,
    :ap => {:forest_walk => 1, :default => 2},
    :xp => 0.2,
    :altitude => 0,
    :image => 'p_forest.jpg',
    :class => :forest,
    :transition => :pine_forest_3,
    :transition_odds => {:default => 0, :Spring => 25, :Summer => 40},
    :build_tiny? => true,
    :build_small? => true,
    :actions => [:chop_tree],
    :search => {:stick => 25, :staff => 8},
    
    :Spring => 'You are in an evergreen forest. Tall pine trees tower above you.',
    :Summer => 'You are in an evergreen forest. Shafts of sunlight shine ' +
    'through the tall pine trees.',
    :Autumn => 'You are in an evergreen forest. Pine cones crunch underfoot.',
    :Winter => 'You are in a pine forest. Snow hangs heavy on the branches ' +
    'of the trees.',
  },
  
  :pine_forest_3 =>
  {:id => 23,
    :ap => {:forest_walk => 2, :default => 3},
    :xp => 0.3,
    :altitude => 0,
    :image => 'p_denseforest.jpg',
    :class => :forest,
    :build_tiny? => true,
    :build_small? => true,
    :actions => [:chop_tree],
    :search => {:stick => 25, :staff => 8},
    
    :description => 'You are walking through a dense evergreen forest, ' +
    'your journey hampered by a thick wall of pine branches.',
    :Summer => 'You are in an evergreen forest. ' +
    'Sunlight barely penetrates the thick tangle of pine branches overhead.',
    :Winter => 'You are in a dense pine forest. Snow hangs heavy on the branches ' +
    'of the trees.',
  },

  :cleared_pine =>
  {:id => 24,
    :ap => 1,
    :build_tiny? => true,
    :build_small? => true,
    :build_large? => true,
    :class => :open,
    :altitude => 0,
    :image => 'p_grass.jpg',
    :search => {:onion => 3, :thyme => 18, :wheat => 6},
    :dig => {:onion => 25}, 
    :actions => [:dig],    
    :transition => :pine_forest_1,
    :transition_odds => {:default => 0, :Spring => 10},
    
    :Spring => 'You are walking through a verdant grassland. Some small flowers are starting to grow here.',
    :Summer => 'You are walking through a verdant grassland, with many dandelions and other flowers. Crickets are chirping in the long grass.',
    :Autumn => 'You are walking through a grassland. The cold weather is beginning to turn the grass brown.',
    :Winter => 'You are walking through a grassland. Frost has hardened the ground, and there is little sign of life.',
  },
   
  :wilderness =>
  {:id => 3,
    :ap => 2,
    :altitude => 0,
    :image => 'p_wilderness.jpg',
    :search => {'You can\'t expect to find anything in the wilderness!' => 90, 'You find nothingness - whiteness - endlessness - stretching beyond the human imagination... <i>desolation of the soul...</i> OH MY GOD!' => 10},
    :Spring => 'You are wandering through a seemingly endless wilderness.',
    :Summer => 'You are wandering through a seemingly endless wilderness. The hot sun beats down upon you.',
    :Autumn => 'You are wandering through a seemingly endless wilderness.',
    :Winter => 'You are wandering through a seemingly endless wilderness. A cold wind whistles through the desolate landscape.',
  },
  
  :cleared_wood =>
  {:id => 4,
    :ap => 1,
    :build_tiny? => true,
    :build_small? => true,
    :build_large? => true,
    :class => :open,
    :altitude => 0,
    :image => 'p_grass.jpg',
    :search => {:onion => 3, :thyme => 18, :wheat => 6},
    :dig => {:onion => 25},
    :actions => [:dig],
    :transition => :woodland,
    :transition_odds => {:default => 0, :Spring => 10},
    
    :Spring => 'You are walking through a verdant grassland. Some small flowers are starting to grow here.',
    :Summer => 'You are walking through a verdant grassland, with many dandelions and other flowers. Crickets are chirping in the long grass.',
    :Autumn => 'You are walking through a grassland. The cold weather is beginning to turn the grass brown.',
    :Winter => 'You are walking through a grassland. Frost has hardened the ground, and there is little sign of life.',
    
  },
  
  :low_hillside =>
  {:id => 31,
    :ap => 1,
    :xp => 0.2,
    :altitude => 1, 
    :image => 'p_hill1_side.jpg',
    :search => {:flint => 10, :stone => 10},
    :class => :hill,
    :Spring => 'You are on the side of a hill, at low elevation. A light breeze is blowing.',
    :Summer => 'You are on the side of a hill, at low elevation. The hot sun shines down upon you.',
    :Autumn => 'You are on the side of a hill, at low elevation. A stiff breeze is blowing.',
    :Winter => 'You are on the side of a hill, at low elevation. A cold wind is blowing.',
  },
  
  :low_hilltop =>
  {:id => 41,
    :ap => 1,
    :xp => 0.2,
    :altitude => 1,
    :class => :hill,
    :image => 'p_hill1_top.jpg', 
    :build_tiny? => true,
    :build_small? => true,
    :search => {:flint => 10, :stone => 10},
    
    :Spring => 'You are atop a low hill, looking at the countryside stretching away in all directions.',
    :Summer => 'You are atop a low hill, looking at the verdant countryside stretching away in all directions.',
    :Autumn => 'You are atop a low hill, looking at the countryside slowly dissapearing into the autumn mist.',
    :Winter => 'You are atop a low hill, looking at the countryside stretching away in all directions. A cold wind is blowing.',
  },
  
  :mid_hillside =>
  {:id => 32,
    :ap => 1,
    :xp => 0.3,
    :altitude => 2, 
    :class => :hill,
    :image => 'p_hill2_side.jpg',
    :search => {:flint => 20, :stone => 10},
    :Spring => 'You are on the side of a hill, at medium elevation. A light breeze is blowing.',
    :Summer => 'You are on the side of a hill, at medium elevation. The hot sun shines down upon you.',
    :Autumn => 'You are on the side of a hill, at medium elevation. A stiff breeze is blowing.',
    :Winter => 'You are on the side of a hill, at medium elevation. A cold wind is blowing.',
  },
  
  :mid_hilltop =>
  {:id => 42,
    :ap => 1,
    :xp => 0.3,
    :altitude => 2,
    :class => :hill,
    :build_tiny? => true,
    :build_small? => true,
    
    :search => {:flint => 20, :stone => 10},
    :image => 'p_hill2_top.jpg',
    :Spring => 'You are atop a medium hill, looking at the countryside stretching away in all directions.',
    :Summer => 'You are atop a medium hill, looking at the verdant countryside stretching away in all directions.',
    :Autumn => 'You are atop a medium hill, looking at the countryside slowly dissapearing into the autumn mist.',
    :Winter => 'You are atop a medium hill, looking at the countryside stretching away in all directions. A cold wind is blowing.',
  },
  
  :high_hillside =>
  {:id => 33,
    :ap => 1,
    :xp => 0.4,
    :altitude => 3, 
    :class => :hill,
    :search => {:flint => 25, :stone => 10},
    :image => 'p_hill3_side.jpg',
    :Spring => 'You are on the side of a hill, at high elevation. A light breeze is blowing.',
    :Summer => 'You are on the side of a hill, at high elevation. The hot sun shines down upon you.',
    :Autumn => 'You are on the side of a hill, at high elevation. A stiff breeze is blowing.',
    :Winter => 'You are on the side of a hill, at high elevation. A cold wind is blowing.',
  },
  
  :high_hilltop =>
  {:id => 43,
    :ap => 1,
    :xp => 0.4,
    :altitude => 3,
    :class => :hill,
    :build_tiny? => true,
    :build_small? => true,
    :search => {:flint => 25, :stone => 10},
    :image => 'p_hill3_top.jpg',
    :Spring => 'You are atop a high hill, looking at the countryside stretching away in all directions.',
    :Summer => 'You are atop a high hill, looking at the verdant countryside stretching away in all directions.',
    :Autumn => 'You are atop a high hill, looking at the countryside slowly dissapearing into the autumn mist.',
    :Winter => 'You are atop a high hill, looking at the countryside stretching away in all directions. A cold wind is blowing.',
  },

  :wall =>
  {:id => 44,
    :ap => 1,
    :ap_recovery => -1,
    :altitude => 0,
    :restore_odds => 0,
    :class => :wall,
    :build_tiny? => true,
    :image => 'p_wall.jpg',
    :Spring => 'You are standing high atop a stone wall. The wind roars, requiring all your strength to maintain your balance.',
    :Summer => 'You are standing high atop a stone wall. Hot summer winds roar, requiring all your strength to maintain your balance.',
    :Autumn => 'You are standing high atop a stone wall. The wind roars, requiring all your strength to maintain your balance.',
    :Winter => 'You are standing high atop a stone wall. Icy winds batter your position, requiring all your strength to maintain your balance.',
  },
  
  :wall_low =>
  {:id => 45,
    :ap => 5,
    :altitude => 0,
    :restore_odds => 0,
    :class => :wall,
    :build_tiny? => true,
    :image => 'p_wall.jpg',
    :description => 'You are standing atop a low stone wall.'
  },

  :gate_open =>
  {:id => 46,
    :ap => 1,
    :altitude => 0,
    :restore_odds => 0,
    :class => :wall,
    :build_tiny? => true,
    :image => 'p_dirt.jpg',
    :description => 'The groundwork has been laid, but without a gate anyone can easily pass through.'
  },

  :gate =>
  {:id => 47,
    :ap => 5,
    :ap_recovery => -1,
    :altitude => 0,
    :restore_odds => 0,
    :class => :wall,
    :build_tiny? => true,
    :image => 'p_gate.jpg',
    :description => 'Well crafted stone and woodwork stands testament to the people of Shintolin\'s efforts to keep themselves protected.'
  },

  :stream =>
  {:id => 5,
    :class => :shallow_water,
    :ap => {:swimming => 2, :default => 4},
    :altitude => 0, 
    :image => 'p_river.jpg',
    :actions => [:fill],
    
    :Spring => 'You are wading through a small stream, cool water running over your feet.',
    :Summer => 'You are paddling through a small stream. The water is slow and murky.',
    :Autumn => 'You are wading through a small stream, cool water running over your feet.',
    :Winter => 'You are wading through a small stream. The water is ice cold and rapid.',
  },
  
  :lake_shore =>
  {:id => 51,
    :ap => 1,
    :altitude => 0,
    :class => :beach,
    :image => 'p_rshore.jpg',
    :search => {:stone => 25},
    :build_tiny? => true,
    :build_small? => true,
    :Spring => 'You are on the rocky shore of a lake, sunlight glinting off the crests of small waves.',
    :Summer => 'You are on the rocky shore of a lake. The placid surface reflects the almost cloudless blue sky.',
    :Autumn => 'You are on the rocky shore of a lake. The water is grey and choppy.',
    :Winter => 'You are on the rocky shore of a lake. The water is grey and choppy.',
  },
  
  :shallow_lake =>
  {:id => 52,
    :class => :shallow_water,
    :ap => {:swimming => 2, :default => 4},
    :altitude => 0,
    :actions => [:fill],
    
    :image => 'p_river.jpg',
    :Spring => 'You are wading through shallow water, at the edge of a lake.',
    :Summer => 'You are wading through the shallow edge of a lake. The cool water brings relief from the heat of the sun.',
    :Autumn => 'You are wading through shallow water, at the edge of a lake.',
    :Winter => 'You are wading through shallow water, at the edge of a lake. The ice cold water chills you to the bone.', 
  },
  
  :deep_lake =>
  {:id => 53,
    :class => :deep_water,
    :ap => {:swimming => 4},
    :altitude => 0, 
    :image => 'p_dwater.jpg',
    :Spring => 'You are swimming through the deep water of a lake.',
    :Summer => 'You are swimming through the deep water of a lake. The cool water brings relief from the heat of the sun.',
    :Autumn => 'You are swimming through the deep water of a lake.',
    :Winter => 'You are swimming through the deep water of a lake. The cold water chills you to the bone.',
  },
  
  :rapids =>
  {:id => 54,
    :ap => 4,
    :altitude => 1, 
    :image => 'p_rapids.jpg',
    :Spring => 'You are wading through a rapid stream, tumbling down the hillside.',
    :Summer => 'You are wading through a rapid stream, tumbling down the hillside.',
    :Autumn => 'You are wading through a rapid stream, tumbling down the hillside.',
    :Winter => 'You are wading through a rapid stream, tumbling down the hillside.',
  },
  
  :shallow_river =>
  {:id => 55,
    :class => :shallow_water,
    :ap => {:swimming => 2, :default => 4},
    :altitude => 0, 
    :actions => [:fill],
    :image => 'p_river.jpg',
    
    :Spring => 'You are wading through a small river, cool water running over your feet.',
    :Summer => 'You are paddling through a small river. The water is slow and murky.',
    :Autumn => 'You are wading through a small river, cool water running over your feet.',
    :Winter => 'You are wading through a small river. The water is ice cold and rapid.',
    
  },
  
  :deep_river =>
  {:id => 56,
    :class => :deep_water,
    :ap => {:swimming => 4},
    :altitude => 0, 
    :image => 'p_dwater.jpg',
    :Spring => 'You are swimming through a deep river.',
    :Summer => 'You are swimming through a deep river. The cool water brings relief from the heat of the sun.',
    :Autumn => 'You are swimming through a deep river.',
    :Winter => 'You are swimming through a deep river. The cold water chills you to the bone.',
    
    
  },
  
  :flood_plain =>
  {:id => 57,
    :ap => 1.5,
    :altitude => 0, 
    :image => {:Spring => 'p_rapids.jpg', :default => 'p_flood.jpg'},
    :class => :wetland,
    :search => {:wheat => 15},
    :dig => {:clay => 40, :stone => 10, :gold_coin => 1},
    :actions => [:dig],
    
    :Spring => "You are wading through ankle-deep water; the Spring floods have come to the plains.",
    :Summer => "You are walking across a flood plain. The ground bakes beneath the sun.",
    :Autumn => "You are walking across a flood plain.",
    :Winter => "You are walking across a flood plain.",
  },
  
  :sand_beach =>
  {:id => 58,
    :ap => 1,
    :altitude => 0,
    :class => :beach,
    :image => 'p_beach.jpg',
    :search => {"Maybe you've found the place where you can stop searching..." => 100},
    :build_tiny? => true,
    :Spring => 'You are walking along a white sandy beach. Sunlight dapples on the water.',
    :Summer => 'You are walking along a white sandy beach. A cool breeze blows from the water, bringing relief from the hot sun.',
    :Autumn => 'You are walking along a white sandy beach.',
    :Winter => 'You are walking along a white sandy beach.',
  },
  
  :hot_spring =>
  {:id => 59,
    :ap => 3,
    :altitude => 0,
    :class => :shallow_water,
    :image => 'p_spring.jpg',
    :ap_recovery => +0.5,
    :actions => [:fill],
    
    :description => 'You are bathing in a hot spring. ' +
    'Sulphurous-smelling water bubbles out from under the ground.',
    :Autumn => 'You are bathing in a hot spring. ' +
    'The heat of the water brings welcome relief from the chilly air.',
    :Winter => 'You are bathing in a hot spring. ' +
    'The heat of the water brings welcome relief from the chilly air.'
  },
  
  :shallow_sea =>
  {:id => 151,
    :class => :shallow_water,
    :ap => {:swimming => 2, :default => 4},
    :altitude => 0,
    :actions => [:fill],
    :image => 'p_river.jpg',
    
    :Spring => 'You are paddling through shallow water, ' +
    'at the edge of an ocean that stretches to the horizon. ' +
    'Waves crash against the shore.',
    :Summer => 'You are paddling through shallow water, ' +
    'at the edge of an ocean that stretches to the horizon. ' +
    'Sunlight glints off the crest of the waves.',
    :Autumn => 'You are paddling through shallow water, ' +
    'at the edge of an ocean that stretches to the horizon. ' +
    'Waves crash against the shore.',
    :Winter => 'You are paddling through shallow water, ' +
    'at the edge an ocean that stretches to the horizon. ' +
    'Violent waves crash against the shore, sending up a spray of salt water.'
  },
  
  :deep_sea =>
  {:id => 152,
    :class => :deep_water,
    :ap => {:swimming => 4},
    :altitude => 0,
    :actions => [:fill],
    :image => 'p_ocean.jpg',
    
    :Spring => 'You are swimming in the ocean. ' +
    'Animals are hiding behind the rocks (except the little fish).',
    :Summer => 'You are swimming in the ocean. ' +
    'The cool water brings relief from the heat of the sun.',
    :Autumn => 'You are swimming in the ocean.',
    :Winter => 'You are swimming in the ocean. ' +
    'The cold water chills you to the bone.'
  },
  
  :thick_forest =>
  {:id => 6,
    :ap => {:forest_walk => 2, :default => 3},
    :altitude => 0,
    :class => :forest,
    :build_tiny? => true,
    :build_small? => true,
    :image => 'p_denseforest.jpg',
    :actions => [:chop_tree],
    :search => {:stick => 25, :staff => 8, :bark => 10, :chestnut => 15},
    :Spring => 'You are in a dense forest. Almost no light can be seen through the thick tree cover overhead.',
    :Summer => 'You are in a dense forest. Almost no light can be seen through the thick tree cover overhead.',
    :Autumn => 'You are in a dense forest. The thick tree cover overhead is russet and gold in colour.',
    :Winter => 'You are in a dense forest. The bare branches form a thick tangle overhead.',
  },
  
  :woodland =>
  {:id => 7,
    :ap => 1,
    :xp => 0.1,
    :altitude => 0,
    :class => :forest,
    :transition => :forest,
    :build_tiny? => true,
    :build_small? => true,
    :transition_odds => {:default => 0, :Spring => 15, :Summer => 30},
    :image => 'p_lightforest.jpg',
    :actions => [:chop_tree],
    :search => {:stick => 25, :staff => 8, :bark => 10, :chestnut => 15},
    :Spring => 'You are walking though an open woodland.',
    :Summer => 'You are walking though an open woodland.',
    :Autumn => 'You are walking though an open woodland, the leaves turning golden and brown with autumn.',
    :Winter => 'You are walking though an open woodland. The tree branches are bare.',
  },
  
  :dirt_track =>
  {:id => 8,
    :ap => 0.5,
    :altitude => 0,
    :restore_odds => 0,
    :class => :open,
    :transition => :grassland,
    :transition_odds => {:default => 0, :Spring => 10},
    :build_tiny? => true,
    :build_small? => true,
    :build_large? => true,
    :image => 'p_dirt.jpg',
    :Spring => 'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.',
    :Summer => 'You are standing on bare dirt; the dusty ground here has seen the passage of many feet.',
    :Autumn => 'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.',
    :Winter => 'You are standing on bare dirt; the frozen ground here has seen the passage of many feet.',
  },

  :track_forest =>
  {:id => 81,
    :ap => 0.5,
    :build_tiny? => true,
    :build_small? => true,
    :build_large? => true,
    :class => :open,
    :altitude => 0,
    :image => 'p_dirt.jpg',      
    :transition => :cleared_wood,
    :transition_odds => {:default => 0, :Spring => 15},
    :build_tiny? => true,
    :build_small? => true,
    :build_large? => true,
    :Spring => 'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.',
    :Summer => 'You are standing on bare dirt; the dusty ground here has seen the passage of many feet.',
    :Autumn => 'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.',
    :Winter => 'You are standing on bare dirt; the frozen ground here has seen the passage of many feet.',      
  },
  
  :track_pine =>
  {:id => 82,
    :ap => 0.5,
    :build_tiny? => true,
    :build_small? => true,
    :build_large? => true,
    :class => :open,
    :altitude => 0,
    :image => 'p_dirt.jpg',      
    :transition => :cleared_pine,
    :transition_odds => {:default => 0, :Spring => 15},
    :build_tiny? => true,
    :build_small? => true,
    :build_large? => true,
    :Spring => 'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.',
    :Summer => 'You are standing on bare dirt; the dusty ground here has seen the passage of many feet.',
    :Autumn => 'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.',
    :Winter => 'You are standing on bare dirt; the frozen ground here has seen the passage of many feet.',      
  },

  :empty_field =>
  {:id => 9,
    :ap => 1,
    :altitude => 0, 
    :image => 'p_efield.jpg',
    :restore_odds => 0,
    :actions => [:sow],
    :class => :field,
    :transition => :grassland,
    :transition_odds => {:default => 0, :Summer => 30},
    :Spring => 'You are standing in a ploughed field. The soil has been turned up, leaving a number of shallow furrows.',
    :Summer => 'You are standing in a ploughed field. The soil has been turned up, leaving a number of shallow furrows.',
    :Autumn => 'You are standing in a ploughed field. The soil has been turned up, leaving a number of shallow furrows.',
    :Winter => 'You are standing in a ploughed field. The soil has been turned up, leaving a number of shallow furrows.', 
  }, 
  
  :wheat_field =>
  {:id => 91,
    :ap => 1,
    :altitude => 0,
    :restore_odds => 0, 
    :image => {:Summer => 'p_sfield.jpg', :Autumn => 'p_afield.jpg', :default => 'p_efield.jpg'},
    :actions => [:harvest, :water],
    :class => :open,
    :transition => :empty_field,
    :transition_odds => {:default => 0, :Winter => 100},
    :Spring => 'You are standing in a ploughed field. It looks like something was recently planted here, though nothing has grown yet.',
    :Summer => 'You are standing in a field. Wheat is growing here, green and unripe.',
    :Autumn => 'You are standing in a field. Ripe, golden wheat stalks are waving in the breeze.',
    :Winter => 'It looks like there was a crop growing in this field, but it was left unharvested and has rotted.',
  },

  :wheat_field_watered =>
  {:id => 92,
    :ap => 1,
    :altitude => 0,
    :restore_odds => 0, 
    :image => {:Summer => 'p_sfield.jpg', :Autumn => 'p_afield.jpg', :default => 'p_efield.jpg'},
    :actions => [:harvest], # removed watering
    :class => :open,
    :transition => :wheat_field, # instead of empty_field
    :transition_odds => 100, # always changes back to normal wheat field at the end of the day
    :Spring => 'You are standing in a ploughed field. It looks like something was recently planted here, though nothing has grown yet. It has been recently watered.',
    :Summer => 'You are standing in a field. Wheat is growing here, green and unripe. It has been recently watered.',
    :Autumn => 'You are standing in a field. Ripe, golden wheat stalks are waving in the breeze.',
    :Winter => 'It looks like there was a crop growing in this field, but it was left unharvested and has rotted.',
  },  


  :marsh =>
  {:id => 10,
    :class => :wetland,
    :ap => 1.5,
    :xp => 0.15,
    :altitude => 0, 
    :image => 'p_marsh.jpg',
    :Spring => 'You are wading through a marsh.',
    :Summer => 'You are wading through a marsh.',
    :Autumn => 'You are wading through a marsh. You can barely see anything through the thick Autumn mist.',
    :Winter => 'You are wading through a marsh.'
  },
  
  :rocky_flat =>
  {
    :id => 11,
    :class => :open,
    :ap => 1,
    :altitude => 0,
    :build_tiny? => true,
    :build_small? => true,
    :build_large? => true, 
    :image => 'p_lightgrey.jpg',
    :search => {:stone => 10, :flint => 15, :huckleberry => 15},
    
    :Spring => 'This area is almost devoid of vegetation, with many rocks scattered around.',
    :Summer => 'This area is almost devoid of vegetation, with many rocks scattered across the dusty ground.',
    :Autumn => 'This area is almost devoid of vegetation, with many rocks scattered around.',
    :Winter => 'This area is almost devoid of vegetation, with many rocks scattered around. A cold wind howls through the desolate landscape.'
  },
  
  :cliff_bottom =>
  {
    :id => 110,
    :class => :open,
    :ap => 1.5,
    :altitude => 0, 
    :build_tiny? => true,
    :image => 'p_grey.jpg',
    :search => {:stone => 10, :flint => 15, :huckleberry => 15},
    :actions => [:quarry],
    
    :description => 'You are standing at the bottom of a cliff. Many large boulders, broken free from the rock face, are lying around.',
  },
  
  :low_cliff_face =>
  {
    :id => 111,
    :class => :cliff,
    :ap => {:mountaineering => 5},
    :altitude => 1, 
    :image => 'p_rshore.jpg',
    
    :description => 'You are clinging to the side of a cliff, at low elevation.'
  },
  
  :ruins =>
  {
    :id => 99,
    :class => :open,
    :ap => 1.5,
    :altitude => 0,
    :build_tiny? => true,
    :image => 'p_ruins.jpg',
    :search => {:stone => 10, :flint => 15},
    :description => 'You are standing on the remnants of a strange village. You don\'t ' +
    'recognise its architecture or origins.'
  },
}]
