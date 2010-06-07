
#
# RFC822 Email Address Regex
# --------------------------
# 
# Originally written by Cal Henderson
# c.f. http://iamcal.com/publish/articles/php/parsing_email/
#
# Translated to Ruby by Tim Fletcher, with changes suggested by Dan Kubb.
#
# Licensed under a Creative Commons Attribution-ShareAlike 2.5 License
# http://creativecommons.org/licenses/by-sa/2.5/
# 

module Format
  EMAIL = /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  USERNAME = /\A\w+\Z/i
  WEB = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?[\/\?].*)?$/ix
end
