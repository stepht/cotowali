// Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
module messages

pub enum SymbolKind {
	typ
	variable
	function
	namespace
}

pub fn (k SymbolKind) str() string {
	return match k {
		.typ { 'type' }
		.variable { 'variable' }
		.function { 'function' }
		.namespace { 'namespace' }
	}
}

[inline]
pub fn unreachable<T>(err T) string {
	return 'unreachable - This is a compiler bug (err: $err).'
}

[inline]
pub fn duplicated(name string) string {
	return '`$name` is already defined'
}

[inline]
pub fn undefined(kind SymbolKind, name string) string {
	return '$kind `$name` is not defined'
}