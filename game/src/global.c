#include "global.h"

extern char * data_path;
extern char * pref_path;
const SDL_Color APP_WHITE = { 255, 255, 255, 255 };

void error(const char * msg) {
	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_INFORMATION, APP_TITLE, msg, NULL); 
}

void fatal(const char * msg) {
	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, APP_TITLE, msg, NULL);
	exit(1);
}

char * string_cat(const char * s1, const char * s2) {
	int len = SDL_strlen(s1) + SDL_strlen(s2) + 1;
	char * buf = malloc(len);
	SDL_strlcpy(buf, s1, len);
	SDL_strlcat(buf, s2, len);
	return buf;
}

void prepend_data_path(char * dst, const char * src, int maxlen) {
	if (SDL_strlcpy(dst, data_path, maxlen) >= maxlen) {
		fatal("not enough space for data_path");
	}
	if (SDL_strlcat(dst, src, maxlen) >= maxlen) {
		char * msg = string_cat(src, " too long");
		fatal(msg);
	}
}

void prepend_pref_path(char * dst, const char * src, int maxlen) {
	if (SDL_strlcpy(dst, pref_path, maxlen) >= maxlen) {
		fatal("not enough space for pref_path");
	}
	if (SDL_strlcat(dst, src, maxlen) >= maxlen) {
		char * msg = string_cat(src, " too long");
		fatal(msg);
	}
}

