module engine.service;

interface IService
{
	public void initialize();
	public void update();
}

interface IServiceProvider
{
	public void addService(TypeInfo_Class type, IService service);
	public IService getService(object.TypeInfo_Class type);	
}
