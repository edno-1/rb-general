# leap years part 1

# def leap_year?(year)
#   if year % 4 == 0
#     if year % 100 == 0
#       if year % 400 == 0
#         true
#       else
#         false
#       end
#     else
#       true
#     end
#   else
#     false
#   end
# end

def leap_year?(year)
  if year % 400 == 0
    true
  elsif year % 100 == 0
    false
  else
    year % 4 == 0
  end
end

puts [
leap_year?(2016) == true,
leap_year?(2015) == false,
leap_year?(2100) == false,
leap_year?(2400) == true,
leap_year?(240000) == true,
leap_year?(240001) == false,
leap_year?(2000) == true,
leap_year?(1900) == false,
leap_year?(1752) == true,
leap_year?(1700) == false,
leap_year?(1) == false,
leap_year?(100) == false,
leap_year?(400) == true,
]
