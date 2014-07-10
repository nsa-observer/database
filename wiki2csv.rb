#!/usr/bin/env ruby
# author : Aeris
# licence : GPLv3


headers = %w(Alias Tags Short\ Description Category Family Related\ items Related\ items\ (parents) Related\ items\ (children) Compartments Status Agency Links)

result = []
current = nil

File.open('database.wiki').each_line do |line|
	case line
	when /=== (.*) ===/
		result << current unless current.nil?
		current = { name: $~[1] }
	when /\* \[(.*)\]/ then current['Links'] += " " + $~[1]
	when /([^:]+):(.*)/
		name = $~[1]
		case name
		when 'Links' then current[name] = ''
		else current[name] = $~[2]
		end
	end
end

def strip(value)
	value.nil? ? '' : value.strip
end

print 'Name;', headers.join(';'), "\n"
result.each do |r|
	print strip(r[:name]), ';'
	print(headers.collect { |h| strip r[h] } .join(';'), "\n")
end
