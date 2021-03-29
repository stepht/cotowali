module compiler

import io
import strings
import cotowari.source { Source }
import cotowari.lexer
import cotowari.parser
import cotowari.gen
import cotowari.ast
import cotowari.errors

pub struct Compiler {
mut:
	source Source
}

pub struct CompileError {
	errors []errors.Error
	code   int
	msg    string
}

fn check_compile_error(file ast.File) ? {
	if file.errors.len > 0 {
		return IError(CompileError{
			errors: file.errors
			code: file.errors.len
			msg: 'compile error: $file.errors.len errors'
		})
	}
}

[inline]
pub fn new_compiler(source Source) Compiler {
	return Compiler{
		source: source
	}
}

pub fn (c &Compiler) compile() ?string {
	mut sb := strings.new_builder(100)
	c.compile_to(sb) ?
	return sb.str()
}

pub fn (c &Compiler) compile_to(w io.Writer) ? {
	mut p := parser.new(lexer.new(c.source))
	parsed_file := p.parse()
	check_compile_error(parsed_file) ?
	mut g := gen.new(w)
	g.gen(parsed_file)
}