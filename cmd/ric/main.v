module main

import os
import cli { Command }
import v.vmod
import cotowari { compile, format_error }
import cotowari.source { Source }
import cotowari.errors
import cmd.tools

fn new_source_to_run(args []string) ?Source {
	if args.len == 0 {
		return Source{
			path: 'stdin'
			code: os.get_raw_lines_joined()
		}
	} else {
		return source.read_file(args[0])
	}
}

fn execute_run(cmd Command) ? {
	if cmd.args.len > 1 {
		eprintln('too many source files')
		exit(1)
	}
	s := new_source_to_run(cmd.args) or {
		eprintln(err)
		exit(1)
	}
	cotowari.run(s) or {
		eprintln(err)
		exit(1)
	}
}

fn execute_compile(cmd Command) ? {
	if cmd.args.len == 0 {
		eprintln('no source files are passed')
		exit(1)
	} else if cmd.args.len > 1 {
		eprintln('too many source files')
		exit(1)
	}
	s := source.read_file(cmd.args[0]) ?
	out := compile(s) or {
		eprint(format_error(err, errors.PrettyFormatter{}))
		exit(1)
	}
	println(out)
}

fn main() {
	mod := vmod.decode(@VMOD_FILE) or { panic(err) }
	mut app := Command{
		name: 'ric'
		description: mod.description
		version: mod.version
		execute: execute_compile
		commands: [
			Command{
				name: 'run'
				description: 'run script'
				execute: execute_run
			},
			tools.command,
		]
	}
	app.setup()
	app.parse(os.args)
}
