module engine.state;

import derelict.sdl2.sdl;

import engine.config;

public class State
{
	public Config config;
	SDL_Window* window;
	SDL_Renderer* renderer;
	
	public this() 
	{
	}
}
