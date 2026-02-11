-- TNT-Server ACCELERATED Stages Configuration
-- Objetivo: Level 1200+ em 1 mês (atualmente level 540 em 1 mês)
-- Multiplicador base aumentado ~2.5x para compensar a progressão atual

-- EXPERIENCE STAGES - ACELERADAS
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 8,
		multiplier = 100, -- Era 40x → Agora 120x (3x maior)
	},
	{
		minlevel = 9,
		maxlevel = 50,
		multiplier = 100, -- Era 65x → Agora 150x (2.3x maior)
	},
	{
		minlevel = 51,
		maxlevel = 100,
		multiplier = 90, -- Era 48x → Agora 110x (2.3x maior)
	},
	{
		minlevel = 101,
		maxlevel = 150,
		multiplier = 80, -- Era 32x → Agora 80x (2.5x maior)
	},
	{
		minlevel = 151,
		maxlevel = 200,
		multiplier = 60, -- Era 24x → Agora 60x (2.5x maior)
	},
	{
		minlevel = 201,
		maxlevel = 300,
		multiplier = 35, -- Era 12x → Agora 35x (2.9x maior)
	},
	{
		minlevel = 301,
		maxlevel = 400,
		multiplier = 25, -- Era 10x → Agora 28x (2.8x maior)
	},
	{
		minlevel = 401,
		maxlevel = 500,
		multiplier = 20, -- Era 8x → Agora 22x (2.75x maior)
	},
	{
		minlevel = 501,
		maxlevel = 600,
		multiplier = 10, -- Era 6x → Agora 18x (3x maior) - FOCO AQUI
	},
	{
		minlevel = 601,
		maxlevel = 700,
		multiplier = 8, -- Era 5x → Agora 15x (3x maior)
	},
	{
		minlevel = 701,
		maxlevel = 800,
		multiplier = 6, -- Era 4x → Agora 12x (3x maior)
	},
	{
		minlevel = 801,
		maxlevel = 900,
		multiplier = 5, -- Era 3x → Agora 10x (3.33x maior)
	},
	{
		minlevel = 901,
		maxlevel = 1000,
		multiplier = 3, -- Era 2x → Agora 8x (4x maior)
	},
	{
		minlevel = 1001,
		maxlevel = 1200,
		multiplier = 2, -- Era 1.5x → Agora 6x (4x maior)
	},
	{
		minlevel = 1201,
		maxlevel = 1400,
		multiplier = 1.5, -- Era 1.2x → Agora 4x (3.33x maior)
	},
	{
		minlevel = 1401,
		maxlevel = 1600,
		multiplier = 1.3, -- Novo range para high levels
	},
	{
		minlevel = 1601,
		maxlevel = 1800,
		multiplier = 1.2, -- Manter desafio nos níveis muito altos
	},
	{
		minlevel = 1801,
		maxlevel = 2000,
		multiplier = 1.1,
	},
	{
		minlevel = 2001,
		multiplier = 1.0, -- End game permanece desafiador
	},
}

-- SKILL STAGES - TAMBÉM ACELERADAS
skillsStages = {
	{
		minlevel = 1,
		maxlevel = 80,
		multiplier = 12, -- Era 8x → Agora 20x (2.5x maior)
	},
	{
		minlevel = 81,
		maxlevel = 100,
		multiplier = 10, -- Era 6x → Agora 15x (2.5x maior)
	},
	{
		minlevel = 101,
		maxlevel = 120,
		multiplier = 5, -- Era 3x → Agora 8x (2.67x maior)
	},
	{
		minlevel = 121,
		maxlevel = 140,
		multiplier = 3, -- Novo range intermediário
	},
	{
		minlevel = 141,
		maxlevel = 300,
		multiplier = 1.5, -- Era 1.5x → Agora 3x (2x maior)
	},
}

-- MAGIC LEVEL STAGES - ACELERADAS
magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 80,
		multiplier = 12, -- Era 8x → Agora 20x (2.5x maior)
	},
	{
		minlevel = 81,
		maxlevel = 100,
		multiplier = 10, -- Era 6x → Agora 15x (2.5x maior)
	},
	{
		minlevel = 101,
		maxlevel = 120,
		multiplier = 5, -- Era 3x → Agora 8x (2.67x maior)
	},
	{
		minlevel = 121,
		maxlevel = 130,
		multiplier = 3, -- Era 2.5x → Agora 6x (2.4x maior)
	},
	{
		minlevel = 131,
		maxlevel = 140,
		multiplier = 2, -- Novo range
	},
	{
		minlevel = 141,
		maxlevel = 300,
		multiplier = 1.5, -- Era 1.5x → Agora 3x (2x maior)
	},
}