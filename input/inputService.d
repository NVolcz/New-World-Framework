module engine.input.inputService;

import std.stdio;

import derelict.sdl2.sdl;

import engine.service;
import engine.input.action;


class InputService : IService
{
	private Action[] actions;
	private Action[int] bindings;
	
	public this()
	{
		actions = new Action[0];
	}
	
	public void addAction(Action action, int keysym)
	{	
		bindings[keysym] = action;
	}	
	
	public void update()
	{
		SDL_Event event;
		while(SDL_PollEvent(&event))
		{
			writeln("Polling a event!");
			switch(event.type)
			{
				case SDL_KEYDOWN:
					writeln("Begin: ", event.key.keysym.sym);
					Action action = bindings.get(event.key.keysym.sym, null);
					action = bindings[event.key.keysym.sym];
					if(action !is null) {
						writeln("Found binding");
						action.begin();
					}
					break;
				case SDL_KEYUP:				
					writeln("End: ", event.key.keysym.sym);
					Action action = bindings.get(event.key.keysym.sym, null);
					if(action !is null) {
						action.end();
					}
				default:
					break;
			}
		}
	}
	
	public void initialize() 
	{
		
	}
}
