def pluralize(n, singular, plural=nil)
	if n == 1
		"#{n} #{singular}"
	elsif plural
		"#{n} #{plural}"
	else
		"#{n} #{singular}s"
	end
end

