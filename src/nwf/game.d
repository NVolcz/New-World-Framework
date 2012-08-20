module nwf.game;

import std.stdio;
import std.string;
import std.random;
import std.datetime;

import core.thread;

import derelict.sdl2.sdl;
import derelict.opengl3.gl3;

import nwf.state;
import nwf.service;
import nwf.component;
import nwf.input.inputService;

public class Game : IServiceProvider
{		
	IService[TypeInfo_Class] services;
	IComponent[] components;
	
	private State state;	
	private const string CONFIG = "config.file";
	public bool finished = false;
		
	public this(State state)
	{
		this.state = state;
		
		writefln("Registering InputService");
		addService(InputService.classinfo, new InputService());
		writefln("Registering InputService. done");
	}
	
	public void initialize()
	{
		writefln(":: Initialise engine");
		
		writefln("\t:: Load dynamic link libraries (.dll)");
		DerelictSDL2.load();
		DerelictGL3.load();
						
		writefln("\t:: Initialise SDL");
		initSDL();
		
		writefln("\t:: Create a new window");
		state.window = createWindow();
		SDL_GL_CreateContext(state.window);
		DerelictGL3.reload();
		
		writefln("\t:: Initialise OpenGL");
		initOpenGL();
		
		writefln("\t:: Initialise random seed");
		Random gen = unpredictableSeed();
		
		writefln("\t:: Initialise services");
		initializeServices();
		
		writefln(":: Engine got succesfully initialised");
	}
	
	private void initializeServices() 
	{
		foreach(IService service; services)
		{
			service.initialize();
		}
	}
	
	public void run()
	{
		int nextGameTick = SDL_GetTicks();
		while(!finished) 
		{
			uint loops = 0;
			
			while( SDL_GetTicks() > nextGameTick && loops < state.config.graphic.maxFrameSkip) 
			{
				update();
				nextGameTick += state.config.graphic.tickRate;
				loops++;
			}
			render();
		}
	}
	
	void update()
	{
		foreach(IService service; services)
		{
			service.update();
		}
		
		//collectSDLEvents(this);
		//EventHandler.check(this);
		
		//if(!isFinished)
		//{
			//Keybindings.check(this);
			//Mousebindings.check(this);
			
			//Renderer.update(this, Shapes, Particles);
		//}
	}
	
	private void initSDL() 
	{
		if (SDL_Init(SDL_INIT_VIDEO) < 0) {
            writeln("Couldn't initialize SDL: %s\n", SDL_GetError());
        }	
		
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
		
		// Set OpenGL attributes
	    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
	    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
	}
	
	private void initOpenGL()
	{
		glEnable(GL_DEPTH_TEST);
		glClearColor(0,0,0,0);
		
	}
	
	private SDL_Window* createWindow()
	{
		SDL_Window* window;
		int videoModeFlags = SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL;
		
		
		window = SDL_CreateWindow(toStringz(state.config.application.name), SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, state.config.application.resolution.width, state.config.application.resolution.height, videoModeFlags);
		
		if(!window) 
		{
			writeln(stderr, "Couldn't set create window: %s\n", SDL_GetError());
			quit();
		}
		
		return window;
	}
	
	public void render()
	{
		Thread.sleep(dur!("msecs")(5));
	}
	
	public void addService(TypeInfo_Class type, IService service)
	{
		services[type] = service;
	}
	
	public IService getService(TypeInfo_Class type)
	{
		return services[type];
	}
	
	public void quit() {
		SDL_Quit();
	}
	
}
