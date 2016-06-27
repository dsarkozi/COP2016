def remove_module(mod)
	mod.instance_methods(false).each do |meth|
		mod.send(:remove_method, meth)
	end
	mod.instance_variables.each do |var|
	  mod.send(:remove_instance_variable, var)
  end
  mod.constants(false).each do |const|
    mod.send(:remove_const, const)
  end
end

def prepend_module(mod)
	mod_name = mod.to_s
	# (Classname)(Depth)(Singleton mark)
	mod_name.match(/(^[a-z]+)([0-9]+)(S?)/i) do |m|
		klass_name = m[1]
		depth = m[2].to_i
		is_singleton = m[3]
		
		klass_def = Object.const_get(klass_name)
		klass = is_singleton.empty? ? klass_def : klass_def.singleton_class
		(1..depth).each do |level|
			unless klass.included_modules.include?(mod)
				klass.class_eval "prepend " + klass_name + level.to_s + is_singleton
			end
		end
		# refresh class variables
		#klass_def.send(:initialize) unless is_singleton.empty?
	end
end

def update_feature(feature, is_active)
	mods = []
	trace = TracePoint.new(:class) do |tp|
		mods << tp.self
	end

	# Resolve path
  path = File.expand_path("../Application/variations/#{feature}.rb", __FILE__)
	# Resolve classes
	# klasses = [Foo]
	# Resolve modules
	trace.enable
	
	load path
	trace.disable
	mods.each do |mod|
		if is_active
			prepend_module(mod)
		else
			remove_module(mod)
		end
	end
end

def update_state(current, previous)
	activating = current - previous
	deactivating = previous - current
	return activating, deactivating, current
end
