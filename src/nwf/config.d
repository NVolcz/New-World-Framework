module engine.config;

import std.datetime;

struct ApplicationConfig
{
	string name;
	bool fullscreen;
	Resolution resolution;
}

struct Resolution
	{
		int width;
		int height;
		int bpp;
	}

struct InputConfig
{
	float MouseSensitivity;
	bool catchMouse;
}

struct GraphicConfig
{
	int ticksPerSecond = 25;
	//1000/ticksPerSecond
    int tickRate = 1000/25;	
    int maxFrameSkip = 5;
	
	uint OpenGLVersion;
	
	float Interpolation;
	
	ulong FrameCounter;
	ulong Frames;
	uint FPS;
	float AverageFPS;
	
	void Frame()
	{
		FrameCounter++;
		Frames++;
	}
}

struct Config
{
	ApplicationConfig application;
	InputConfig input;
	GraphicConfig graphic;
}

