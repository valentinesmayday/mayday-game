#ifndef APP_GLOBAL_H
#define APP_GLOBAL_H

#include <stdlib.h>
#include <assert.h>
#include <string.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#include "SDL.h"
#include "SDL_ttf.h"

#define APP_TITLE  "Sample SDL Lua Project"
#define APP_WIDTH  640
#define APP_HEIGHT 480
#define MAX_ADJUSTED_FILENAME_LEN 256

typedef int bool;
#define false 0
#define true 1

extern SDL_Renderer * renderer;

extern const SDL_Color APP_WHITE;

void error(const char * msg);
void fatal(const char * msg);
void prepend_data_path(char * dst, const char * src, int maxlen);
void prepend_pref_path(char * dst, const char * src, int maxlen);

#endif

