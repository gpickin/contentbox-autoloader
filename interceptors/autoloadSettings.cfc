component {

	property name="permissionService"   		inject="provider:permissionService@cb";
	property name="permissionGroupService"   	inject="provider:permissionGroupService@cb";
	property name="settingService"   		inject="provider:settingService@cb";
	
	property name="moduleSettings"   			inject="coldbox:setting:modules";
	
	void function configure() {}

	/**
	* Upon afterConfigurationLoad, this interceptor will read the module settings, looking for a key called `contentboxAutoLoaders`. If this key exists this interceptor will try to autoload the following types of entities. Permissions, PermissionGroups, PermissionGroupPermissions and Settings
	*
	* @arugments.interceptData.moduleConfig.settings.contentboxAutoLoaders The struct to hold all the entity related information. Please refer to the readme for an example of this configuration.
	*/
	function afterConfigurationLoad( event, rc, prc, interceptData, buffer ) {

		for( var key in moduleSettings ){
			var module = moduleSettings[ key ];
			if( structKeyExists( module.settings, "contentboxAutoLoaders" ) ){
				var cbAutoLoaders = module.settings.contentboxAutoLoaders;
				
				if( structKeyExists( cbAutoLoaders, "permission" ) && arrayLen( cbAutoLoaders.permission ) ){
					loadPermissions( cbAutoLoaders.permission  );
				}
				
				if( structKeyExists( cbAutoLoaders, "permissionGroup" ) && arrayLen( cbAutoLoaders.permissionGroup ) ){
					loadPermissionGroups( cbAutoLoaders.permissionGroup );
				}
				
				if( structKeyExists( cbAutoLoaders, "permissionGroupPermission" ) && arrayLen( cbAutoLoaders.permissionGroupPermission ) ){
					loadPermissionGroupPermissions( cbAutoLoaders.permissionGroupPermission );
				}
				
				if( structKeyExists( cbAutoLoaders, "setting" ) && arrayLen( cbAutoLoaders.setting ) ){
					loadSettings( cbAutoLoaders.setting );
				}
			}
		}
	}
	
	
	/**
	* Load permissions from the Array of structs passed in, if the permission is not already in the system. The array consists of structs, with 2 possible keys
	*  
	* settings.struct.permission The name/slug of the permission to be added
	* settings.struct.description The description of the permission to be added
	*/
	private function loadPermissions( required array permissions ){
		//writeDump( "try to import #arrayLen( arguments.permissions )# permissions" );    	
		for( var permission in arguments.permissions ){
			if( structKeyExists( permission, "permission" ) ){
				//writeDump( "trying to add permission #permission.permission#" );
				var oPermission = permissionService.findWhere( { permission = permission.permission } );
				if( isNull( oPermission ) ){
					oPermission = permissionService.new();
					oPermission.setPermission( permission.permission );
					if( structKeyExists( permission, "description" ) ){
						oPermission.setDescription( permission.description );
					}
					permissionService.save( oPermission );
					//writeDump( "added permission #permission.permission#" );
				} else {
					//writeDump( "permission #permission.permission# already exists" );
				}	
			}
		}
	}
	
	
	/**
	* Load PermissionGroups from the Array of structs passed in, if the PermissionGroups is not already in the system. The array consists of structs, with 2 possible keys
	*  
	* settings.struct.name The name/slug of the PermissionGroup to be added
	* settings.struct.description The description of the PermissionGroup to be added
	*/
	private function loadPermissionGroups( required array permissionGroups ){
		//writeDump( "try to import #arrayLen( arguments.permissionGroups )# permissionGroups" );   
		for( var permissionGroup in arguments.permissionGroups ){
			if( structKeyExists( permissionGroup, "name" ) ){
				//writeDump( "trying to add permissionGroup #permissionGroup.name#" );
				var oPermissionGroup = permissionGroupService.findWhere( { name = permissionGroup.name } );
				if( isNull( oPermissionGroup ) ){
					oPermissionGroup = permissionGroupService.new();
					oPermissionGroup.setName( permissionGroup.name );
					if( structKeyExists( permissionGroup, "description" ) ){
						oPermissionGroup.setDescription( permissionGroup.description );
					}
					permissionGroupService.save( oPermissionGroup );
					//writeDump( "added permissionGroup #permissionGroup.name#" );
				} else {
					//writeDump( "permissionGroup #permissionGroup.name# already exists" );
				}	
			}
		} 	
	}
	
	
	/**
	* Load PermissionGroup Permissions from the Array of structs passed in, if the Permission Group does not already have that permission. Note, this does not create new permission groups 
	* or permissions, just connects those via a Many to Many relationship. The array consists of structs, with 2 possible keys
	*  
	* settings.struct.permissionGroupName The name/slug of the permissionGroup, for which the permissions are to be added
	* settings.struct.permissions An array of structs, containing a single key, the permission
	*/
	private function loadPermissionGroupPermissions( required array permissionGroupPermissions ){
		//writeDump( "try to import #arrayLen( arguments.permissionGroupPermissions )# permissionGroupPermissions" );   
		for( var permissionGroup in arguments.permissionGroupPermissions ){
			if( structKeyExists( permissionGroup, "permissionGroupName" ) ){
				//writeDump( "trying to add permissionGroup #permissionGroup.permissionGroupName#" );
				var oPermissionGroup = permissionGroupService.findWhere( { name = permissionGroup.permissionGroupName } );
				if( isNull( oPermissionGroup ) ){
					//writeDump( "permissionGroup #permissionGroup.permissionGroupName# does not exist." );
				} else {
					//writeDump( "permissionGroup #permissionGroup.permissionGroupName# exists - looping through permissions" );
					if( structKeyExists( permissionGroup, "permissions" ) ){
						for( var permission in permissionGroup.permissions ){
							if( structKeyExists( permission, "permission" ) ){
								//writeDump( "trying to add permission #permission.permission# to #permissionGroup.permissionGroupName#" );
								var oPermission = permissionService.findWhere( { permission = permission.permission } );
								if( isNull( oPermission ) ){
									//writeDump( "#permission.permission# does not exists" );
								} else {
									if( oPermissionGroup.hasPermission( oPermission ) ){
										//writeDump( "permission #permission.permission# already exists in #permissionGroup.permissionGroupName#" );
									} else {
										//writeDump( "permission #permission.permission# does not exist in #permissionGroup.permissionGroupName#" );
										oPermissionGroup.addPermission( oPermission );
										permissionGroupService.save( oPermissionGroup );
										//writeDump( "permission #permission.permission# now added to #permissionGroup.permissionGroupName#" );
									}
								}	
							}
						}
					} else {
						//writeDump( "no permissions to load" );
					}	
				}	
			}
		} 	
	}
	
	
	/**
	* Load settings from the Array of structs passed in, if the setting is not already in the system. The array consists of structs, with 2 possible keys
	*  
	* settings.struct.name The name/slug of the setting to be added
	* settings.struct.value The value of the setting to be added
	*/
	private function loadSettings( required array settings ){
		//writeDump( "try to import #arrayLen( arguments.settings )# settings" ); 
		for( var setting in arguments.settings ){
			if( structKeyExists( setting, "name" ) ){
				//writeDump( "trying to add setting #setting.name#" );
				var oSetting = settingService.findWhere( { name = setting.name } );
				if( isNull( oSetting ) ){
					oSetting = settingService.new();
					oSetting.setName( setting.name );
					if( structKeyExists( setting, "value" ) ){
						oSetting.setValue( setting.value );
					}
					settingService.save( oSetting );
					//writeDump( "added setting #setting.name#" );
				} else {
					//writeDump( "setting #setting.name# already exists" );
				}	
			}
		}
	}
	
}
