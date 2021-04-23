module parser

import cotowari.ast
import cotowari.symbols { new_placeholder_fn, new_placeholder_var }
import cotowari.source { Pos }

struct FnParamParsingInfo {
mut:
	name     string
	typename string
	pos      Pos
}

struct FnSignatureParsingInfo {
	name string
mut:
	params       []FnParamParsingInfo
	ret_typename string
}

fn (mut p Parser) parse_fn_signature_info() ?FnSignatureParsingInfo {
	p.consume_with_assert(.key_fn)
	mut info := FnSignatureParsingInfo{
		name: p.consume().text
	}

	p.consume_with_check(.l_paren) ?
	if p.@is(.ident) {
		for {
			name := p.consume_with_check(.ident) ?
			typ := p.consume_with_check(.ident) ?
			info.params << FnParamParsingInfo{
				name: name.text
				pos: name.pos
				typename: typ.text
			}
			if p.@is(.r_paren) {
				break
			} else {
				p.consume_with_check(.comma) ?
			}
		}
	}
	p.consume_with_check(.r_paren) ?
	if ret := p.consume_if_kind_is(.ident) {
		info.ret_typename = ret.text
	}

	return info
}

fn (mut p Parser) parse_fn_decl() ?ast.FnDecl {
	info := p.parse_fn_signature_info() ?
	mut node := ast.FnDecl{
		name: info.name
	}
	mut outer_scope := p.scope
	p.open_scope(node.name)
	defer {
		p.close_scope()
	}
	mut params := []ast.Var{len: info.params.len}
	for i, param in info.params {
		params[i] = ast.Var{
			pos: param.pos
			sym: p.scope.register_var(new_placeholder_var(param.name, param.typename)) or {
				return p.duplicated_error(param.name)
			}
		}
	}
	node.params = params
	outer_scope.register_var(new_placeholder_fn(info.name, info.params.map(it.typename),
		info.ret_typename)) or { return p.duplicated_error(info.name) }
	node.body = p.parse_block_without_new_scope() ?
	return node
}