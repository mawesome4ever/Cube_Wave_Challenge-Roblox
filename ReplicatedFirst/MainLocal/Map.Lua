
--Ported p5.js Map function

--returns: Int
--desc: Re-maps a number from one range to another.
return function(n, start1, stop1, start2, stop2, withinBounds)
	
	local newval = (n - start1) / (stop1 - start1) * (stop2 - start2) + start2;
	if not withinBounds then
		return newval;
	end
	if start2 < stop2 then
		return math.clamp(newval, start2, stop2);
	else
		return math.clamp(newval, stop2, start2);
	end
end
