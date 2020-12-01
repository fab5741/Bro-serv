resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

dependencies {
	"bf",
	"jobManager"
}

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/taximeter.ttf',
	'html/cursor.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_scripts {
	"functions.lua",
	"client.lua"
}
server_scripts{
	"server.lua"
}
