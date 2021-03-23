module scope

import vash.types { unknown_type }

fn test_scope() ? {
	mut s := new_global_scope()
	if _ := s.parent() {
		assert false
	}
	mut child := s.create_child()
	assert (child.parent() ?).id == s.id
	assert s.children == [child]

	v1 := ScopeObject(new_var('v1'))

	if registered := s.register(v1) {
		assert v1 == registered
		assert v1.id != 0
	} else {
		assert false
	}
	if _ := s.register(v1) {
		assert false
	}

	if found := s.lookup(v1.name) {
		assert found == v1
	} else {
		assert false
	}
	if _ := child.lookup('nothing') {
		assert false
	}
}

fn test_nested() ? {
	mut parent := new_global_scope()
	mut child := parent.create_child()

	name := 'v'
	parent_v := ScopeObject(new_var(name))
	child_v := ScopeObject(new_var(name))
	assert parent_v.name == child_v.name
	assert parent_v != child_v

	parent.register(parent_v) ?
	if found := parent.lookup(name) {
		assert found == parent_v
		assert found != child_v
	} else {
		assert false
	}
	if found := child.lookup(name) {
		assert found == parent_v
		assert found != child_v
	} else {
		assert false
	}

	child.register(child_v) ?
	if found := parent.lookup(name) {
		assert found == parent_v
		assert found != child_v
	} else {
		assert false
	}
	if found := child.lookup(name) {
		assert found != parent_v
		assert found == child_v
	} else {
		assert false
	}

	if _ := child.lookup('nothing') {
		assert false
	}
}

fn test_var() {
	v := new_var('v')
	assert v.name == 'v'
	assert v.typ == unknown_type
}
