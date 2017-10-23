# contentbox-autoloader

## A module to help ensure permissions, permission groups, permission groups' permissions and setting required by the module, are loaded and exist, by using conventions in the ModuleConfig.

### Usage

To ensure your module has the permissions, permission groups, permission groups' permissions and settings that it needs, you can define them quickly in your ModuleConfig, and ContentBox-AutoLoader will do the rest. After configuration load, this module loops through all the modules, and creates the appropriate permissions / settings, if they do not already exist.

#### How to add Autoloader config

Inside your ModuleConfig.cfc, in the configure function, you can define module settings. To use the Autoloader, please add a key called `contentBoxAutoLoaders` and inside of that key, we'll set a struct. Inside that struct, you can place config for any of the items to be autoloaded ( details below ).

```
function configure() {
		settings = {
			contentboxAutoLoaders = {}
		};
}
```

#### Adding Permissions Config

To ensure permissions exist in the ContentBox application, your module can define the list of permissions in the `permission` key inside of the `contentboxAutoLoaders` key setting. For a permission to be autoloaded, it is required to be a struct, with a `permission` key, which will be used as the slug for the permission. Description is optional, and if present, will be added to the permission.

```
function configure() {
		settings = {
			contentboxAutoLoaders = {
				"permission" = [
					{ "permission" = "Because" },
					{ 
						"permission" = "MyNewSetting", 
						"description" = "My New setting I have to have"
					}
				]
			}
		};
}
```

#### Adding Permission Group config

To ensure permission groups exist in the ContentBox application, your module can define the list of permissions in the `permissionGroup` key inside of the `contentboxAutoLoaders` key setting. For a permission group to be autoloaded, it is required to be a struct, with a `name` key, which will be used as the slug for the permission group. Description is optional, and if present, will be added to the permission group.

```
function configure() {
		settings = {
			contentboxAutoLoaders = {
				"permissionGroup" = [
					{ 
						"name" = "MyNewGroup", 
						"description" = "My New Group I have to have"
					},
					{ 
						"name" = "MyNewGroup2", 
						"description" = "My New Group I have to have"
					}
				]
			}
		};
}
```

#### Adding PermissionGroup's Permission Config

Adding Permission Groups, and Permissions is not much help, without allowing you to define which Permission Groups has which permissions. This config allows you to set that relationship. Add the `permissionGroupPermission` key to the `contentboxAutoLoaders` struct. Inside of the `permissionGroupPermission`, define an array of structs, containing 2 keys, `permissionGroupName`, the permissionGroup you would like to add permissions to, and `permissions` an array of permissions. The array of permissions, is an array of structs, containing just 1 key, the `permission` which is the name / slug of the permission.

_Note: This does not create the permission or the permission group. Please use the config above to add the permissions and permission groups, before setting their relationships with this config._

```
function configure() {
		settings = {
			contentboxAutoLoaders = {
				"permissionGroupPermission" = [
					{ 
						"permissionGroupName" 	= "mynewgroup",
						"permissions"		= [
							{ "permission" = "mynewsetting" },
							{ "permission" = "mynewsetting2" },
							{ "permission" = "mynewsetting3" },
							{ "permission" = "mynewsetting4" },
							{ "permission" = "mynewsetting5" },
							{ "permission" = "mynewsetting6" }
						]
					},
				]
			}
		};
}
```

#### Adding Setting config

To ensure settings exist in the ContentBox application, your module can define the list of settings in the `setting` key inside of the `contentboxAutoLoaders` struct. For a setting to be autoloaded, it is required to be a struct, with a `name` key, which will be used as the slug for the setting, and the `value` key, which will be the value of the setting.

```
function configure() {
		settings = {
			contentboxAutoLoaders = {
				"setting" = [
					{ 
						"name" = "RC_New1", 
						"value" = "yes"
					},
					{ 
						"name" = "RC_New2", 
						"value" = "no"
					}
				]
			}
		};
}
```

### Warning - May recreate your manual configurations deletions

As states, this module creates settings etc that do not exist. If you delete a permission, or remove a permission from a permission group, where your module defined that to be required, it will recreate that setting or relationship. 

_If the slugs already exist, it will not add, or modify the existing settings or values._

### Full Example Configuration

Here is a full example of using the ContentBoxAutoLoaders config, with all of the possible keys. 

```
function configure() {
		settings = {
			contentboxAutoLoaders = {
				"permission" = [
					{ "permission" = "Because" },
					{ 
						"permission" = "MyNewSetting", 
						"description" = "My New setting I have to have"
					},
					{ 
						"permission" = "MyNewSetting2", 
						"description" = "My New setting I have to have"
					},
					{ 
						"permission" = "MyNewSetting4", 
						"description" = "My New setting I have to have"
					},
					{ 
						"permission" = "MyNewSetting6", 
						"description" = "My New setting I have to have"
					}
				],
				"permissionGroup" = [
					{ 
						"name" = "MyNewGroup", 
						"description" = "My New Group I have to have"
					},
					{ 
						"name" = "MyNewGroup2", 
						"description" = "My New Group I have to have"
					}
				],
				"permissionGroupPermission" = [
					{ 
						"permissionGroupName" 	= "mynewgroup",
						"permissions"		= [
							{ "permission" = "mynewsetting" },
							{ "permission" = "mynewsetting2" },
							{ "permission" = "mynewsetting3" },
							{ "permission" = "mynewsetting4" },
							{ "permission" = "mynewsetting5" },
							{ "permission" = "mynewsetting6" }
						]
					},
				],
				"setting" = [
					{ 
						"name" = "RC_New1", 
						"value" = "yes"
					},
					{ 
						"name" = "RC_New2", 
						"value" = "no"
					},
					{ 
						"name" = "RC_New3", 
						"value" = "no"
					},
					{ 
						"name" = "RC_New4", 
						"value" = "no"
					}
				]
			}
		};
		
	}
```