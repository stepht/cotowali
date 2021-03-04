module lexer

import vash.source
import vash.token { Token }
import vash.pos

pub fn (mut lex Lexer) next() ?Token {
	return if !lex.closed { lex.read() } else { none }
}

fn (mut lex Lexer) prepare_to_read() {
	lex.skip_whitespaces()
	lex.pos = pos.new(
		i: lex.idx()
		col: lex.pos.last_col
		line: lex.pos.last_line
	)
}

pub fn (mut lex Lexer) read() Token {
	lex.prepare_to_read()
	if lex.is_eof() {
		lex.close()
		return Token{.eof, '', lex.pos}
	}

	match lex.letter()[0] {
		`(` { return lex.new_token_with_consume(.l_par) }
		`)` { return lex.new_token_with_consume(.r_par) }
		`\r`, `\n` { return lex.read_newline() }
		else {}
	}

	for !(lex.is_eof() || lex.letter().is_whitespace() || lex.letter() == '\n') {
		lex.consume()
	}
	return lex.new_token(.unknown)
}

fn (mut lex Lexer) read_newline() Token {
	if lex.letter()[0] == `\r` && lex.next_letter() == '\n'{
		lex.consume()
	}
	return lex.new_token_with_consume(.eol)
}
