config = {
    jobs = {
        food = {
            label = "Fermiers",
            id = 'food',
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
        wine = {
            label = "Vignerons",
            id = 'wine',
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
                }
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