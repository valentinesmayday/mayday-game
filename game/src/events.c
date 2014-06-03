#include "global.h"

static void on_window_closing(lua_State * L) {
	lua_getglobal(L, "on_window_closing");
	if (lua_isnil(L, 1)) return;
	if (lua_pcall(L, 0, 0, 0)) error(lua_tostring(L, -1));
}

static void on_mouse_down(lua_State * L, const SDL_MouseButtonEvent * e) {
	if (e->type == SDL_MOUSEBUTTONDOWN && e->button == SDL_BUTTON_LEFT) {
		assert(lua_gettop(L) == 0);
		lua_getglobal(L, "on_touch");
		assert(lua_gettop(L) == 1);
		if (lua_isnil(L, 1)) {
			lua_settop(L, 0);
			return;
		}
		lua_pushinteger(L, e->x);
		lua_pushinteger(L, e->y);
		if (lua_pcall(L, 2, 0, 0)) error(lua_tostring(L, -1));
	}
}

static void on_key_down(lua_State * L, const SDL_KeyboardEvent * e) {
	if (e->keysym.sym == SDLK_r) {
		assert(lua_gettop(L) == 0);
		lua_getglobal(L, "on_keydown_r");
		assert(lua_gettop(L) == 1);
		if (lua_isnil(L, 1)) {
			lua_settop(L, 0);
			return;
		}
		if (lua_pcall(L, 0, 0, 0)) error(lua_tostring(L, -1));
	}
}

bool process_event_queue(lua_State * L) {
	SDL_Event e;

	//assert(lua_gettop(L) == 0);
	while (SDL_PollEvent(&e)) {
		if      (e.type == SDL_QUIT)          { on_window_closing(L);  return false; } 
		else if (e.type == SDL_MOUSEBUTTONDOWN) on_mouse_down(L, &e.button);
		else if (e.type == SDL_KEYDOWN)         on_key_down(L, &e.key);
	}
	lua_settop(L, 0);
	//assert(lua_gettop(L) == 0);
	return true;
}

