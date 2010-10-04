RSpec::Matchers.define :have_form_posting_to do |url_or_path|
 match do |response|
   have_tag("form[method=post][action=#{url_or_path}]").matches?(response)
 end
end

RSpec::Matchers.define :have_form_puting_to do |url_or_path|
 match do |response|
   have_tag("form[method=post][action=#{url_or_path}/#{id}]").matches?(response)
   have_tag("input[name=_method][type=hidden][value=put]").matches?(response)
 end
end

RSpec::Matchers.define :have_label_for do |attribute|
 match do |response|
   have_tag("label[for=#{attribute}]").matches?(response)
 end
end

RSpec::Matchers.define :with_label_for do |attribute|
 match do |response|
   with_tag("label[for=#{attribute}]").matches?(response)
 end
end

RSpec::Matchers.define :have_text_field_for do |attribute|
 match do |response|
   have_tag("input##{attribute}[type=text]").matches?(response)
 end
end

RSpec::Matchers.define :with_text_field_for do |attribute|
 match do |response|
   with_tag("input##{attribute}[type=text]").matches?(response)
 end
end

RSpec::Matchers.define :have_text_area_for do |attribute|
 match do |response|
   have_tag("textarea##{attribute}[type=text]").matches?(response)
 end
end

RSpec::Matchers.define :with_text_area_for do |attribute|
  match do |response|
    with_tag("textarea##{attribute}[type=text]").matches?(response)
  end
end

RSpec::Matchers.define :have_password_field_for do |attribute|
  match do |response|
    have_tag("input##{attribute}[type=password]").matches?(response)
  end
end

RSpec::Matchers.define :with_password_field_for do |attribute|
  match do |response|
    with_tag("input##{attribute}[type=password]").matches?(response)
  end
end

RSpec::Matchers.define :have_checkbox_for do |attribute|
  match do |response|
    have_tag("input##{attribute}[type=checkbox]").matches?(response)
  end
end

RSpec::Matchers.define :with_checkbox_for do |attribute|
  match do |response|
    with_tag("input##{attribute}[type=checkbox]").matches?(response)
  end
end

RSpec::Matchers.define :have_submit_button do |attribute|
  match do |response|
    have_tag("input[type=submit]").matches?(response)
  end
end

RSpec::Matchers.define :with_submit_button do |attribute|
  match do |response|
    with_tag("input[type=submit]").matches?(response)
  end
end

RSpec::Matchers.define :have_link_to do |url_or_path|
  match do |response|
    have_tag("a[href=#{url_or_path}]", text).matches?(response)
  end
end

RSpec::Matchers.define :with_link_to do |url_or_path|
  match do |response|
    with_tag("a[href=#{url_or_path}]", text).matches?(response)
  end
end