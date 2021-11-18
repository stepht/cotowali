// Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
module symbols

fn join_name_for_ident(names ...string) string {
	return names.join('_')
}

pub fn (s &Scope) name_for_ident() string {
	name := if s.name.len > 0 { s.name } else { 'scope$s.id' }
	if p := s.parent() {
		if p.is_global() {
			return name
		}
		return join_name_for_ident(p.name_for_ident(), name)
	} else {
		return name
	}
}

pub fn (v Symbol) name_for_ident() string {
	mut name := if v.name.len > 0 { v.name } else { 'sym$v.id()' }
	if v is Var {
		if v.is_member() {
			name = v.receiver_type_symbol().name_for_ident() + '__$name'
		}
	}
	name = name.replace('[]', '__array__')
	if s := v.scope() {
		if s.is_global() {
			return name
		}
		return join_name_for_ident(s.name_for_ident(), name)
	} else {
		return name
	}
}

fn join_name_for_display(names ...string) string {
	return names.join('::')
}

pub fn (s &Scope) display_name() string {
	name := if s.name.len > 0 { s.name } else { 'anon_$s.id' }
	if p := s.parent() {
		if p.is_global() {
			return name
		}
		return join_name_for_display(p.name_for_ident(), name)
	} else {
		return name
	}
}

pub fn (v Symbol) display_name() string {
	mut name := if v.name.len > 0 { v.name } else { 'anon_$v.id()' }
	if v is Var {
		if v.is_member() {
			name = v.receiver_type_symbol().display_name() + '.$name'
		}
	}
	if s := v.scope() {
		if s.is_global() {
			return name
		}
		return join_name_for_display(s.display_name(), name)
	} else {
		return name
	}
}
