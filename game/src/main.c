#include "global.h"

#define SDL_INIT_FLAGS (SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS)
#define DESIRED_MILLIS_PER_FRAME (1000 / 60)
#define RENDERER_INIT_FLAGS (SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC)

bool process_event_queue(lua_State * L);

bool running = true;
SDL_Renderer * renderer;
char * data_path = NULL;
char * pref_path = NULL;

static lua_State  * L;
static SDL_Window * window;

void register_util_functions(lua_State * L);
void register_texture_functions(lua_State * L);
void register_audio_functions(lua_State * L);
void register_font_functions(lua_State * L);

static void register_global_functions(lua_State * L) {
	register_util_functions(L);
	register_texture_functions(L);
	register_audio_functions(L);
	register_font_functions(L);
}

static void set_package_path(lua_State * L, const char * path) {
	assert(lua_gettop(L) == 0);
	lua_getglobal(L, "package");
	lua_pushstring(L, "path");
	lua_pushstring(L, path);
	lua_settable(L, 1);
	lua_settop(L, 0);
}

static void clear_canvas() {
	SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
	SDL_RenderClear(renderer);
}

/*
	Shutdown systems in the reverse order in which they were started.
*/
static void shutdown() {
	lua_close(L);
	TTF_Quit();
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
}

int SDLCALL eventFilter(void * userdata, SDL_Event * event)
{
	if (event->type == SDL_APP_LOWMEMORY) {
		lua_gc(L, LUA_GCCOLLECT, 0);
	} else if (event->type == SDL_APP_TERMINATING) {
		running = false;
	} else {
		// Not a special event to handle, so let it go onto the event queue.
		return 1;
	}
        return 0;
}

/*
	Initialize SDL, SDL_ttf and Lua.
	Register the app's C functions with Lua.
	Call the app's init script.

	The main purpose of the init script is to define the following
	global functions:
		on_draw
		on_touch
		on_quit
*/
static void init() {
	char * base_path;
	char buf[MAX_ADJUSTED_FILENAME_LEN];
	char package_path[MAX_ADJUSTED_FILENAME_LEN * 2];

	if (SDL_Init(SDL_INIT_FLAGS)) fatal(SDL_GetError());

	// Determine the data-path (resource files).
	base_path = SDL_GetBasePath();
	if (base_path) {
		data_path = SDL_strdup(base_path);
		SDL_free(base_path);
	} else {
		data_path = SDL_strdup("./");
	}
	printf("data_path = %s\n", data_path);

	// Determine the pref-path (game save files).
	base_path = SDL_GetPrefPath("cse441", APP_TITLE);
	if (base_path) {
		pref_path = SDL_strdup(base_path);
		SDL_free(base_path);
	} else {
		// Writing save file not possible.
		pref_path = NULL;
	}
	printf("pref_path = %s\n", pref_path);

	window = SDL_CreateWindow(
		APP_TITLE, 
		SDL_WINDOWPOS_CENTERED,
		SDL_WINDOWPOS_CENTERED,
		APP_WIDTH,
		APP_HEIGHT,
		0);
	if (!window) fatal(SDL_GetError());

	renderer = SDL_CreateRenderer(window, -1, RENDERER_INIT_FLAGS);
	if (!renderer) fatal(SDL_GetError());
    
	SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "linear");

	if (SDL_RenderSetLogicalSize(renderer, APP_WIDTH, APP_HEIGHT)) {
		fatal(SDL_GetError());
	}

	SDL_AddEventWatch(eventFilter, NULL);

	clear_canvas();

	if (TTF_Init()) fatal(TTF_GetError());

	L = luaL_newstate();
	if (!L) fatal("Can not create Lua state.");

	luaL_openlibs(L);

	prepend_data_path(package_path, "scripts/?.lua;", MAX_ADJUSTED_FILENAME_LEN);
	set_package_path(L, package_path);

	assert(lua_gettop(L) == 0);
	register_global_functions(L);
	assert(lua_gettop(L) == 0);

	prepend_data_path(buf, "scripts/init.lua", MAX_ADJUSTED_FILENAME_LEN);
	if (luaL_dofile(L, buf)) fatal(luaL_checkstring(L, -1));
	assert(lua_gettop(L) == 0);
}

/*
	The draw function is called after the canvas has been cleared to black
	and before the next call to present the canvas, so this is the time for
	Lua scripts to draw to the canvas.

	If on_draw is found in global scope, then call it. Otherwise do nothing.
*/
static void draw() {
	SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
	SDL_RenderClear(renderer);
	assert(lua_gettop(L) == 0);
	lua_getglobal(L, "on_draw");
	assert(lua_gettop(L) == 1);
        if (lua_isnil(L, -1)) {
		lua_pop(L, 1);
		assert(lua_gettop(L) == 0);
		return;
	}
	if (lua_pcall(L, 0, 0, 0)) {
		fatal(lua_tostring(L, -1));
	}
	assert(lua_gettop(L) == 0);
	SDL_RenderPresent(renderer);
}

/*
	Pad each pass through the main loop with a delay
	to achieve the DESIRED_MILLIS_PER_FRAME.

	Loop until either process_event_queue returns false
	or running gets set to false.
*/
void loop() {
	Uint32 frame_start_time;
	Uint32 frame_elapsed_time;

	assert(lua_gettop(L) == 0);
	while (running) {
		frame_start_time = SDL_GetTicks();

		// Process all queued events;
		// quit loop when event processor returns false.
		assert(lua_gettop(L) == 0);
		if (!process_event_queue(L)) break;
		assert(lua_gettop(L) == 0);

		draw();
		assert(lua_gettop(L) == 0);

		// Add delay to achieve DESIRED_MILLIS_PER_FRAME;
		// delay at least 1 milliseconds to let any waiting threads run.
		frame_elapsed_time = SDL_GetTicks() - frame_start_time;
		if (frame_elapsed_time < DESIRED_MILLIS_PER_FRAME) {
			SDL_Delay(DESIRED_MILLIS_PER_FRAME - frame_elapsed_time);
		} else {
			SDL_Delay(1);
		}
	}
}

int main(int argc, char * argv[]) {
	init();
	loop();
	shutdown();
	return 0;
}

