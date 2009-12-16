file_fixed_version :version => '1.0'

file_fixed_lib do |name, options|
  { :lib => "#{name}_fixed" }
end

overriden :version => 'overriden_by_block'
