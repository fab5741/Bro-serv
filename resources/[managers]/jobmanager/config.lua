config = {
    jobs = {
        Fermiers = {
            label= "Fermiers",
            lockers = {
                {
                    coords = vector3(2030.2646484375,4979.7456054688,42.098190307617),
                    sprite = 496,
                    action = "lockers",
                }
            },
            collect = {
                {
                    coords = vector3(2572.38, 4523.48, 35.2),
                    sprite = 496,
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
                    sprite = 202,
                    action = "process",
                    items = {
                        {name="wheat", label="Blé", amount="1", type="16", to="15", amountTo="1"},
                        {name="orge", label="Orge", amount="1", type="17", to="15", amountTo="1"},
                    }
                },
                {
                    coords = vector3(470.25,3565.63,32.45),
                    sprite = 202,
                    action = "process",
                    items = {
                        {name="flour", label="Farine", amount="1", type="15", to="13", amountTo="1"},
                    }
                }
             },
            sell = {
            },
            safes = {
                {
                    coords = vector3(2016.3625488281,4986.939453125,42.098285675049),
                    sprite = 496,
                    action = "safe",
                }
            },
            parking = {
                {
                    coords = vector3(2035.1791992188,4989.015625,39.695823669434),
                    spawn = vector3(2036.4399414062,4986.6323242188,40.001270294189),
                    heading = -100.0,
                    sprite = 357,
                    action = "parking",
                }
            },
            grades = {
                stagiaire = {
                    label= "Stagiaire",
                    skin_male = {
                        tshirt_1 = 58,  tshirt_2 = 1,
                        torso_1 = 22,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 10,   pants_2 = 0,
                        shoes_1 = 22,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    },
                    skin_female = {
                        tshirt_1 = 58,  tshirt_2 = 1,
                        torso_1 = 22,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 10,   pants_2 = 0,
                        shoes_1 = 22,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
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
                        {name="Jus de raisin", label="Jus de raisin", amount="1", type="19", price="2"},
                    }
                }
            },
            parking = {
                coords = vector3(2034.92, 4989.24, 39.38),
                blip = {
                sprite = 357,
                scale  = 1.2,
                color  = 5,
                string = "Parking",
                },
                action = "Parking",
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
            },
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
            },
            parking = {
                coords = vector3(2034.92, 4989.24, 39.38),
                blip = {
                sprite = 357,
                scale  = 1.2,
                color  = 5,
                string = "Parking",
                },
                action = "Parking",
            },
        },
        LSMS = {
            lockers = {
                {
                    coords = vector3(336.27508544922, -580.03137207031, 28.791479110718),
                    blip = {
                    sprite = 51,
                    scale  = 0.4,
                    color  = 5,
                    string = "locker",
                    },
                    action = "lockers",
                }
            },
            parking = {
                {
                    coords = vector3(339.56744384766,-562.45819091797,28.743431091309),
                    spawn = vector3(344.1618347168, -556.84796142578, 28.743431091309),
                    heading = -15.0,
                    blip = {
                        sprite = 357,
                        scale  = 1.2,
                        color  = 5,
                        string = "Parking",
                    },
                    action = "parking",
                }
            },
            homes = {
                {
                    coords = vector3(341.41842651367,-582.73522949219,28.791477203369),
                    sprite = 500,
                    action = "homes",
                },
            },
            grades = {
                stagiaire = {
                    label= "Stagiaire",
                    skin_male = {
                        tshirt_1 = 59,  tshirt_2 = 1,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
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
        LSPD = {
            lockers = {
                {
                    coords = vector3(457.06948852539,-992.75042724609,30.689332962036),
                    sprite = 51,
                    action = "lockers",
                }
            },
            parking = {
                {
                    coords = vector3(455.12176513672,-1020.779296875,28.307716369629),
                    spawn = vector3(452.06982421875,-1020.469909668,28.381450653076),
                    heading = 90.0,
                    sprite = 357,
                    action = "parking",
                }
            },
            armories = {
                {
                    coords = vector3(451.75173950195,-980.27758789062,30.689315795898),
                    sprite = 549,
                    action = "armories",
                },
            },
            homes = {
                {
                    coords = vector3(441.18566894531,-981.09637451172,30.689331054688),
                    sprite = 500,
                    action = "homes",
                },
            },
            grades = {
                stagiaire = {
                    label= "Stagiaire",
                    skin_male = {
                        tshirt_1 = 59,  tshirt_2 = 1,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
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
        }
    }
}

config.DrawDistance               = 20.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

config.Marker                     = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}

config.bindings = {
    interact_position = 51, -- E
    use_job_menu = 166, -- F5
}