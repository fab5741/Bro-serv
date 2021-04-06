Config = {}

-- Language du menu
-- Menu language
Config.Locale = 'fr'

-- Location du spawn joueur après la création du personnage
-- Rental of player spawn after character creation
Config.PlayerSpawn = {x = -1031.9937744141, y =-2733.0832519531, z = 13.756637573242, h = -30.0}

-- Name of parents for inheritance (Do not add / remove character, you can just replace them)
-- Nom des parents pour l'héritage (Ne pas ajouter / supprimer de personnage, vous pouvez juste les remplacés)
Config.MotherList = { "Hannah", "Aubrey", "Jasmine", "Gisele", "Amelia", "Isabella", "Zoe", "Ava", "Camila", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Gracie", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma" }
Config.FatherList = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony",  "Claude", "Niko" }

-- List of outfit
-- Liste des tenues
Config.Outfit = {
	{
		label = 'Confortable',
		id = {
			male = {
				tshirt = {2, -1},
				torso = {0, 0},
				decals = {0, 0},
				arms = {0, 0},
				pants = {0, 0},
				shoes = {1, 0},
				chain = {0, 0},
				helmet = {-1, 0},
				glasses = {0, 0}
			},
			female = {
				tshirt = {3, 0},
				torso = {3, 0},
				decals = {0, 0},
				arms = {3, 0},
				pants = {4, 0},
				shoes = {1, 0},
				chain = {0, 0},
				helmet = {57, 0},
				glasses = {-1, 0}
			}
		}
	},
}
