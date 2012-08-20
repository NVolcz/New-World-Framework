module nwf.configLoader;

import std.xml;
import std.conv;

import nwf.config;
import nwf.state; 

public class configLoader 
{
	public this(string path, Config config) 
	{
		//TODO fix temp
		State state;
		
		auto configFile = new DocumentParser(cast(string)std.file.read(path));
		
		configFile.onEndTag["application/resolution/width"] = (in Element e)
		{
			//TODO handle errors. If the types is invalid
			state.config.application.resolution.width = to!(int)(e.text);
		};
		
		configFile.onEndTag["application/resolution/height"] = (in Element e) 
		{
			state.config.application.resolution.height = to!(int)(e.text);			
		};
		
		configFile.onEndTag["application/resolution/bbp"] = (in Element e) 
		{
			state.config.application.resolution.bpp = to!(int)(e.text);
		};
		
		configFile.onEndTag["application/fullscreen"] = (in Element e) 
		{
			state.config.application.fullscreen = to!(bool)(e.text);
		};
	}
}

