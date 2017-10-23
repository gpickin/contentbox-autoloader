component {

	this.title        = "contentbox-autoLoader";
	this.description  = "A module to help ensure permissions, permission groups, permission groups' permissions and setting required by the module, are loaded and exist, by using conventions in the ModuleConfig for a given module.";
	this.version      = "0.0.1";
	this.cfmapping    = "contentbox-autoLoader";
	this.dependencies = [];

	function configure() {
		settings = {};
	}

	function onLoad() {
		controller.getInterceptorService().registerInterceptor(
			interceptorClass = "#moduleMapping#.interceptors.autoloadSettings",
			interceptorProperties = settings
		);
	}

}
