// Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
module symbols

import cotowali.errors { unreachable }

pub struct TupleElement {
pub:
	typ  Type   [required]
	name string
}

pub struct TupleTypeInfo {
pub:
	elements []TupleElement
}

pub fn (ts TypeSymbol) tuple_info() ?TupleTypeInfo {
	resolved := ts.resolved()
	return if resolved.info is TupleTypeInfo { resolved.info } else { none }
}

fn (info TupleTypeInfo) typename(s &Scope) string {
	elem_to_str := fn (e TupleElement, s &Scope) string {
		typename := s.must_lookup_type(e.typ).name
		return if e.name.len == 0 { typename } else { '$e.name: $typename' }
	}
	return '(${info.elements.map(elem_to_str(it, s)).join(', ')})'
}

pub fn (mut s Scope) lookup_or_register_tuple_type(info TupleTypeInfo) &TypeSymbol {
	return s.lookup_or_register_type(name: info.typename(s), info: info)
}

pub fn (s Scope) lookup_tuple_type(info TupleTypeInfo) ?&TypeSymbol {
	return s.lookup_type(info.typename(s))
}

pub fn (s Scope) must_lookup_tuple_type(info TupleTypeInfo) &TypeSymbol {
	return s.lookup_tuple_type(info) or { panic(unreachable(err)) }
}
