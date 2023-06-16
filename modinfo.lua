name = "Traducción al Español"
author = "Aivan"
version = "2.15"
description = "\nTraducción de Don't Starve y sus DLC: Reign of Giants, Shipwrecked y Hamlet. Personajes en progreso.\nVersión " .. version

forumthread = "/files/file/1962-hamlet-traducción-al-español-semioficial/"

api_version = 6

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
hamlet_compatible = true

configuration_options =
{
	{
	    name = "translationFile",
		label = "Traducción",
		options =
		{
			{description = "Semioficial", data = "SO"},
			{description = "Español MX", data = "MX"},
			{description = "Español ES", data = "ES"},
		},
		default = "SO",
	},
	{
		name = "showAdjectives",
		label = "Mostrar adjetivos",
		options =
		{
			{description = "Sí", data = true},
			{description = "No", data = false},
		},
		default = true,
	},
	{
		name = "dialogueGender",
		label = "Género en diálogos",
		options =
		{
			{description = "Automático", data = "auto"},
			{description = "Masculino", data = "male"},
			{description = "Femenino", data = "female"},
			{description = "Neutro", data = "robot"},
		},
		default = "auto",
	},
	{
		name = "stackStyle",
		label = "Estilo de apilables",
		options =
		{
			{description = "Clásico", data = "classic"},
			{description = "Espaciado", data = "mathematician"},
			{description = "Paréntesis", data = "parenthesis"},
		},
		default = "classic",
	},
	{
		name = "talkingWormwood",
		label = "Fuente de Wormwood",
		options =
		{
			{description = "Especial", data = "wormwoodFont"},
			{description = "Normal", data = "normalFont"},
		},
		default = "wormwoodFont",
	},
}
