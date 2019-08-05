{application, 'cache_server', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['cache_server','cache_server_handler']},
	{registered, []},
	{applications, [kernel,stdlib]},
	{env, []}
]}.