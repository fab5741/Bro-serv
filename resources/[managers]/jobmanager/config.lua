config = {
    jobs = {
        Fermiers = {
            label= "Fermiers",
            lockers = {
                {
                    coords = vector3(2307.13,4883.27,41),
                    blip = {
                    sprite = 496,
                    scale  = 1.2,
                    color  = 5,
                    string = "locker",
                    },
                    action = "lockers",
                }
            },
            collect = {
                {
                    coords = vector3(2572.38, 4523.48, 35.2),
                    blip = {
                    sprite = 496,
                    scale  = 1.2,
                    color  = 5,
                    string = "collect",
                    },
                    action = "collect",
                    items = {
                       {name="wheat", label="Blé", amount="1", type="16"},
                       {name="orge", label="Orge", amount="1", type="17"},
                    }
                }
            },
            process = {
                {
                    coords = vector3(463.28,3566.37,32.2),
                    blip = {
                    sprite = 202,
                    scale  = 1.2,
                    color  = 5,
                    string = "process",
                    },
                    action = "process",
                    items = {
                        {name="wheat", label="Blé", amount="1", type="16", to="15", amountTo="1"},
                        {name="orge", label="Orge", amount="1", type="17", to="15", amountTo="1"},
                    }
                },
                {
                    coords = vector3(470.25,3565.63,32.45),
                    blip = {
                    sprite = 202,
                    scale  = 1.2,
                    color  = 5,
                    string = "process",
                    },
                    action = "process",
                    items = {
                        {name="flour", label="Farine", amount="1", type="15", to="13", amountTo="1"},
                    }
                }
             },
            sell = {
                {
                    coords = vector3(1212.65,-1261.7,34.43),
                    blip = {
                    sprite = 50,
                    scale  = 1.2,
                    color  = 5,
                    string = "sell",
                    },
                    action = "sell",
                    items = {
                        {name="bread", label="Pain", amount="1", type="13", price="5"},
                    }
                }
            }
        },
        Vignerons = {
            label= "Vignerons",
            lockers = {
                {
                    coords = vector3(-1921.31, 2054.82,139.5),
                    blip = {
                    sprite = 496,
                    scale  = 1.2,
                    color  = 5,
                    string = "locker",
                    },
                    action = "lockers",
                }
            },
            collect = {
                {
                    coords = vector3(-1819.93,2134.48,123.8),
                    blip = {
                    sprite = 496,
                    scale  = 1.2,
                    color  = 5,
                    string = "collect",
                    },
                    action = "collect",
                    items = {
                        {name="Raisin", label="Raisin", amount="1", type="18"},
                     }
                }
            },
            process = {
                {
                coords = vector3(1731.98,3031.5,61.5),
                blip = {
				sprite = 202,
				scale  = 1.2,
                color  = 5,
                string = "process",
                },
                action = "process",
                items = {
                    {name="Raisin", label="Raisin", amount="1", type="18", to="19", amountTo="1"},
                }
            }
            },
            sell = {
                {
                    coords = vector3(1211.98,-1256.05,34.1),
                    blip = {
                    sprite = 50,
                    scale  = 1.2,
                    color  = 5,
                    string = "sell",
                    },
                    action = "sell",
                    items = {
                        {name="Jus de raisin", label="Jus de raisin", amount="1", type="19", price="5"},
                    }
                }
            },
            grades = {
                stagiaire = {
                    label= "Stagiaire",
                    skin_male = {
                        tshirt_1 = 19,  tshirt_2 = 1,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 5,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = 46,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    skin_female = {
                        tshirt_1 = 36,  tshirt_2 = 1,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = 45,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
               }
            }
        },
        Mecanos = {
            coords = vector3(-362.1,-129.6,37.6),
            blip = {
            sprite = 446,
            scale  = 1.8,
            color  = 5,
            string = "Mécanicien",
            },
            lockers = {
                {
                    coords = vector3(-342.291, -133.370, 38.009),
                    blip = {
                    sprite = 496,
                    scale  = 0.4,
                    color  = 5,
                    string = "locker",
                    },
                    action = "lockers",
                }
            },
            collect = {
            },
            process = {
            },
            sell = {
            }
        }
    }
}

config.DrawDistance               = 20.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

config.Marker                     = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}

config.bindings = {
    interact_position = 51, -- E
    use_job_menu = 166, -- F5
}

config.skins = {
        [0] = {
            {name="Fermier", model="a_m_m_farmer_01", job="food"},
            },
        [1] = {
            {name="Vigneron", model="a_m_m_eastsa_01", job="wine"},
            },
}