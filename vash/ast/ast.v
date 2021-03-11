module ast

import vash.pos { Pos }
import vash.token { Token }

pub struct File {
pub:
	path  string
	stmts []Stmt
}

type Stmt = FnDecl | Pipeline

pub struct FnDecl {
pub:
	pos  Pos
	name string
}

pub struct Pipeline {
pub:
	pos      Pos
	commands []Command
}

pub struct Command {
pub:
	pos       Pos
	expr      Expr
	redirects []Redirect
}

pub struct Redirect {
pub:
	pos Pos
}

pub type Expr = CallExpr | IntLiteral | ErrorNode

pub struct CallExpr {
pub:
	pos  Pos
	name string
	args []Expr
}

pub struct IntLiteral {
pub:
	pos Pos
	tok Token
}

pub struct ErrorNode {
pub:
	pos Pos
	message string
}
