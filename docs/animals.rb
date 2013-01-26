[{
  :deer => 
  {:id => 1,
    :name => "deer",
    :plural => "deer",
    :habitats => [:forest,:open],
    :max_hp => 30,
    :when_attacked => {:flee => 60},
    :loot => {:raw_meat => 8, :pelt => 1},
    :loot_bonus => {:raw_meat => 2}
  },
  
  :boar =>
  {:id => 2,
    :name => "wild boar",
    :plural => "wild boars",
    :habitats => [:forest],
    :max_hp => 20,
    :attack_dmg => 2,
    :hit_msg => "gores you with its tusk",
    :when_attacked => {:flee => 25, :attack => 25},
    :loot => {:raw_meat => 3, :pelt => 1},
    :loot_bonus => {:raw_meat => 1}
  },
  
  :wolf =>
  {:id => 3,
    :name => "wolf",
    :plural => "wolves",
    :habitats => [:forest,:open],
    :attack_dmg => 3,
    :max_hp => 50,
    :when_attacked => {:attack => 45},
    :hit_msg => "sinks it's teeth into your thigh",
    :loot => {:raw_meat => 6, :wolf_pelt => 1},
    :loot_bonus => {:raw_meat => 2}
  },
  
  :hare =>
  {:id => 4,
    :name => "hare",
    :plural => "hares",
    :habitats => [:open],
    :max_hp => 10,
    :attack_dmg => 1,
    :hit_msg => "kicks you",
    :when_attacked => {:flee => 80, :attack => 10},
    :loot => {:raw_meat => 2, :small_pelt => 1},
    :loot_bonus => {:raw_meat => 1}
  },
  
  :mountain_lion =>
  {:id => 5,
    :name => "mountain lion",
    :plural => "mountain lions",
    :habitats => [:open, :hills],
    :attack_dmg => 3,
    :max_hp => 70,
    :when_attacked => {:attack => 45},
    :hit_msg => "sinks it's teeth into your thigh",
    :loot => {:raw_meat => 8, :lion_pelt => 1},
    :loot_bonus => {:raw_meat => 2}
  },
  
  :sabre_tooth =>
  {:id => 6,
    :name => "sabre-tooth tiger",
    :plural => "sabre-tooth tigers",
    :habitats => [:open],
    :attack_dmg => 5,
    :max_hp => 100,
    :when_attacked => {:attack => 45},
    :hit_msg => "sinks it's teeth into your thigh",
    :loot => {:raw_meat => 10, :pelt => 1, :sabre_tooth => 2},
    :loot_bonus => {:raw_meat => 3}
  },
  
  :bear =>
  {:id => 7,
    :name => "bear",
    :plural => "bears",
    :habitats => [:forest],
    :attack_dmg => 3,
    :max_hp => 200,
    :when_attacked => {:attack => 30, :flee => 8},
    :hit_msg => "sinks it's teeth into your thigh",
    :loot => {:raw_meat => 20, :bear_skin => 1},
    :loot_bonus => {:raw_meat => 5}
  },
  
  :squirrel =>
  {:id => 8,
    :name => "squirrel",
    :plural => "squirrel",
    :habitats => [:forest],
    :attack_dmg => 1,
    :max_hp => 6,
    :when_attacked => {:attack => 10, :flee => 80},
    :hit_msg => "nips you on the pinky",
    :loot => {:raw_meat => 1, :small_pelt => 1},
    :loot_bonus => {:raw_meat => 1}
  },
  
  :croc =>
  {:id => 9,
    :name => "crocodile",
    :plural => "crocodiles",
    :habitats => [:wetland, :shallow_water, :beach],
    :max_hp => 100,
    :attack_dmg => 5,
    :hit_msg => "bites you",
    :when_attacked => {:flee => 10, :attack => 40},
    :loot => {:croc_skin => 1, :raw_meat => 7},
    :loot_bonus => {:raw_meat => 2}
  },
  
  :goose =>
  {:id => 10,
    :name => "goose",
    :plural => "geese",
    :habitats => [:shallow_water, :deep_water, :beach, :wetland],
    :max_hp => 15,
    :when_attacked => {:flee => 60},
    :loot => {:raw_meat => 3},
    :loot_bonus => {:raw_meat => 1}
  },
  
  :buffalo =>
  {:id => 11,
    :name => "buffalo",
    :plural => "buffalo",
    :habitats => [:open],
    :max_hp => 100,
    :attack_dmg => 4,
    :hit_msg => "tramples you with its hooves",
    :when_attacked => {:flee => 15, :attack => 40},
    :loot => {:raw_meat => 20, :pelt => 1, :horn => 2},
    :loot_bonus => {:raw_meat => 5}
  },
  
  :pheasant =>
  {:id => 12,
    :name => "pheasant",
    :plural => "pheasants",
    :habitats => [:forest],
    :max_hp => 10,
    :when_attacked => {:flee => 60},
    :loot => {:raw_meat => 3},
    :loot_bonus => {:raw_meat => 1}
  },
  
  :stag => 
  {:id => 13,
    :name => "stag",
    :plural => "stags",
    :habitats => [:forest,:open],
    :max_hp => 45,
    :when_attacked => {:flee => 60},
    :loot => {:raw_meat => 10, :pelt => 1, :antler => 2},
    :loot_bonus => {:raw_meat => 3}
  },
  
  :beehive =>
  {:id => 14,
    :name => "beehive",
    :plural => "beehives",
    :habitats => [:forest],
    :immobile => :true,
    :max_hp => 20,
    :attack_dmg => 1,
    :hit_msg => "is surrounded by a swarm of angry bees, which sting you",
    :when_attacked => {:attack => 80},
    :loot => {:honeycomb => 3},
  },
  
  :mammoth => 
  {:id => 15,
    :name => "mammoth",
    :plural => "mammoths",
    :habitats => [:open],
    :max_hp => 750,
    :attack_dmg => 8,
    :hit_msg => "tramples you underfoot",
    :when_attacked => {:flee => 15, :attack =>70},
    :loot => {:raw_meat => 65, :tusk => 2},
    :loot_bonus => {:raw_meat => 17}
  }]
