module LabeledFormHelper
  # Copied from Rails 2.0's #label
  def label_for(object_name, method, options = {})
    tag = ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object))
    tag.to_label_tag(options.delete(:text), options)
  end

  # Creates a label tag.
  #   label_tag('post_title', 'Title')
  #     <label for="post_title">Title</label>
  def label_tag(name, text, options = {})
    content_tag('label', text, { 'for' => name }.merge(options.stringify_keys))
  end
end

module FormBuilderMethods
  def label_for(method, options = {})
    @template.label_for(@object_name, method, options.merge(:object => @object))
  end
end

module LabeledInstanceTag
  def self.included(other_mod)
    other_mod.module_eval do
      ims = instance_methods.map { |im| im.to_sym }
      if !ims.include?(:__to_label_tag_aliased_from_ul_forms__)
        if ims.include?(:to_label_tag)
          # Need to undef the method for the following reason:
          #
          #   class Foo
          #     def bar; 8; end
          #   end
          #   
          #   module Bar
          #     def bar; 9; end
          #   end
          #   
          #   Foo.send :include, Bar
          #   
          #   Foo.new.bar #=> 8
          #
          alias_method :__to_label_tag_aliased_from_ul_forms__, :to_label_tag
          remove_method :to_label_tag
        end
        include InstanceMethods
      end
    end
  end

  module InstanceMethods
    include ActionView::Helpers::AssetTagHelper

    # Copied from Rails 2.0
    def to_label_tag(text = nil, options = {})
      name_and_id = options.dup
      add_default_name_and_id(name_and_id)
      options["for"] = name_and_id["id"]

      content = (text.blank? ? nil : text.to_s) || method_name.titleize
      
      content += content_tag(:span, "*", nil) if options[:required]
      content += image_tag("icon_info.gif", :title => options[:tooltip], :class => "tooltip") if options[:tooltip]
      
      content_tag("label", content, options.except(:required, :tooltip, :tip, :instructions))
    end
  end
end

class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::JavaScriptHelper
  
  if !defined?(FORM_FIELDS)
    FORM_FIELDS = %w[date_select datetime_select time_select] + ActionView::Helpers::FormHelper.instance_methods - %w[label_for hidden_field radio_button form_for fields_for]
    
    FORM_FIELDS.each do |selector|
      src = <<-SRC
        def dl_#{selector}(method, options = {})
          css = initialize_css_classes(options)
          if errors_on_field?(object, method)
            css << ["error"]
  
            @template.content_tag(:dt, label_for(method, excluded_options(options)) + span_errors_for(object, method)) +
            @template.content_tag(:dd, #{selector}(method, excluded_options(options)), :class => css.join(" "))
          else
            @template.content_tag(:dt, label_for(method, excluded_options(options)), :class => options[:class]) +
            @template.content_tag(:dd, #{selector}(method, excluded_options(options).except(:text)), :class => css.join(" "))
          end
        end
      SRC
      class_eval src, __FILE__, __LINE__
    end
    
    # Similar to the dl_x form helpers but uses SPAN instead of DL/DT/DD
    FORM_FIELDS.each do |selector|
      src = <<-SRC
        def labeled_#{selector}(method, options = {})
          output = span_errors_for(object, method) if errors_on_field?(object, method)
          output += label_for(method, excluded_options(options))
          output += #{selector}(method, options.except(:required))
        end
      SRC
      class_eval src, __FILE__, __LINE__
    end
    
    FORM_FIELDS.each do |selector|
      src = <<-SRC
        def ul_#{selector}(method, options = {})
          output = ""
          css = initialize_css_classes(options)
          
          if errors_on_field?(object, method)
            output += ul_span_errors_for(object, method)
            css << ["error"]
          end
          
          output += label_for(method, excluded_options(options))
          output += #{selector}(method, options.except(:required))
          output += instructions(options)
          @template.content_tag(:li, output, :class => css.join(" "))
        end
      SRC
      class_eval src, __FILE__, __LINE__
    end
  end
  
  def instructions(options)
    options[:instructions] ? content_tag(:p, options[:instructions], :class => "instructions") : ""
  end

  def initialize_css_classes(options)
    css = [options[:class]].flatten
    css << ["required"] if options[:required]
    css
  end

  def errors_on_field?(object, method)
    object.respond_to?(:errors) && object.errors.respond_to?(:on) && object.errors.on(method)
  end

  def span_errors_for(object, method)
    errors = []
    Array(object.errors.on(method)).each do |error|
      errors << @template.content_tag(:span, error, :class => "msg")
    end
    content_tag(:p, errors.join, :class => "error")
  end

  def ul_span_errors_for(object, method)
    errors = []
    Array(object.errors.on(method)).each do |error|
      errors << @template.content_tag(:span, error, :class => "msg")
    end
    content_tag(:p, "#{method.to_s.titleize} #{errors.join(', ')}", :class => "error")
  end
  
  def ul_select(method, selections, options = {}, html_options = {})
    output = ""
    css = initialize_css_classes(options)
    
    if errors_on_field?(object, method)
      output += ul_span_errors_for(object, method)
      css << ["error"]
    end
    
    output += label_for(method, excluded_options(options.except(:text)))
    output += select(method, selections, options, html_options)
    output += instructions(options)
    @template.content_tag(:li, output, :class => css.join(" "))
  end

  def ul_file_uploader(name, options = {})
    dd_content = if (object == object.send(name) && object.respond_to?(:has_uploaded_data?) && object.has_uploaded_data?) || (object != object.send(name) && object.send(name) && object.send(name).id)
      image_link = options[:url] ? options[:url] : @template.send(:static_image_path, object.send(name).id)
      size = options[:size] ? options[:size] : 20
      
      div_content =   @template.content_tag(:span, image_tag(image_link), :class => "image_mask") + "<span class='file_meta'>"
      div_content +=  "File size is: " + @template.send(:h, @template.number_to_human_size(object.send(name).size)).to_s + "</span> "
      div_content += @template.link_to_function " Delete or Change Movie ", <<-JS
        $('div#old_#{name}').hide();
        fileField = $('<input>').attr("type","file").attr("id","#{@object_name}_#{name}_uploaded_data").attr("name","#{@object_name}[#{name}_uploaded_data]").attr("size","#{size}").attr('onchange', "if(new RegExp(/^(\s)*?$/).test($('input:file##{@object_name}_#{name}_uploaded_data').val()) == false) $('input:file##{@object_name}_#{name}_uploaded_data').siblings('input:hidden').remove()");
        hiddenField = $('<input>').attr("type","hidden").attr("id","#{@object_name}_#{name}_uploaded_data").attr("name","#{@object_name}[#{name}_uploaded_data]").attr("value","");
        $('##{name}_uploader').append(fileField).append(hiddenField);
      JS
      @template.content_tag(:div, div_content, :id => "old_#{name}")
    else  
      file_field("#{name}_uploaded_data", options.except(:url, :text, :required))
    end

    output = ""
    output += label_for(name, excluded_options(options).except(:url))
    output += dd_content
    output += instructions(options)
    
    @template.content_tag(:li, output, :id => "#{name}_uploader")
  end

  def ul_file_field(method, options = {})
    output = ""
    css = initialize_css_classes(options)

    if errors_on_field?(object, method)
      output += ul_span_errors_for(object, method)
      css << ["error"]
    end

    output += label_for(method, excluded_options(options))
    output += file_field(method, excluded_options(options))
    output += instructions(options)
    @template.content_tag(:li, output, :id => 'file_field', :class => css.join(" "))
  end

  def excluded_options(options = {})
    options.except(:include_blank, :height, :width, :rows, :cols, :size, :end_year, :start_year, :order, :onchange, :twelve_hour)
  end

  def dl_widgeditor(method, options = {})
    widg_options = options.except(:required, :text, :height, :width).dup.merge(:class => "widgEditor")
    style = []
    style << "height: #{options[:height]};" if options[:height]
    style << "width: #{options[:width]};" if options[:width]
    widg_options[:style] = style.join(" ") unless style.blank?
    
    dd_content = @template.text_area(@object_name, method, widg_options)

    @template.content_tag(:dt, label_for(method, excluded_options(options))) + 
    @template.content_tag(:dd, dd_content)
  end
  
  # Removes the hidden input field from the rendered output
  def dl_check_box(method, options = {})
    check_box_tag_only = self.send(:check_box, method, options.except(:required))

    if errors_on_field?(object, method)
      errors = ""
      Array(object.errors.on(method)).each do |error|
        errors += @template.content_tag(:dt, error, :class => "msg")
      end
      @template.content_tag(:dt, label_for(method, excluded_options(options)) + errors, :class => "error") +
      @template.content_tag(:dd, check_box_tag_only, :class => "error")
    else
      @template.content_tag(:dt, label_for(method, excluded_options(options))) +
      @template.content_tag(:dd, check_box_tag_only)
    end
  end  
  
  def dl_file_uploader(name, options = {})
    dd_content = if (object == object.send(name) && object.respond_to?(:has_uploaded_data?) && object.has_uploaded_data?) || (object != object.send(name) && object.send(name) && object.send(name).id)
      image_link = options[:url] ? options[:url] : @template.send(:static_image_path, object.send(name).id)
      size = options[:size] ? options[:size] : 20
      div_content =   @template.content_tag(:span, image_tag(image_link), :class => "image_mask") + "<span class='file_meta'>"
      div_content +=  "File size is: " + @template.send(:h, @template.number_to_human_size(object.send(name).size)).to_s + "</span> "
      div_content += @template.link_to_function " Delete or Change Movie ", <<-JS
        $('div#old_#{name}').hide();
        fileField = $('<input>').attr("type","file").attr("id","#{@object_name}_#{name}_uploaded_data").attr("name","#{@object_name}[#{name}_uploaded_data]").attr("size","#{size}").attr('onchange', "if(new RegExp(/^(\s)*?$/).test($('input:file##{@object_name}_#{name}_uploaded_data').val()) == false) $('input:file##{@object_name}_#{name}_uploaded_data').siblings('input:hidden').remove()");
        hiddenField = $('<input>').attr("type","hidden").attr("id","#{@object_name}_#{name}_uploaded_data").attr("name","#{@object_name}[#{name}_uploaded_data]").attr("value","");
        $('##{name}_uploader').append(fileField).append(hiddenField);
      JS
      @template.content_tag('div', div_content, :id => "old_#{name}")
    else  
      file_field("#{name}_uploaded_data", options.except(:url, :text, :required))
    end
    
    @template.content_tag(:dt, label_for(name, excluded_options(options).except(:url))) + 
    @template.content_tag(:dd, dd_content, :id => "#{name}_uploader")
  end
  
  def dl_file_field(method, options = {})
    if errors_on_field?(object, method)
      errors = ""
      Array(object.errors.on(method)).each do |error|
        errors += @template.content_tag(:dt, error, :class => "msg")
      end
      @template.content_tag(:dt, label_for(method, excluded_options(options)) + errors, :class => "error") +
      @template.content_tag(:dd, file_field(method, excluded_options(options)), :id => 'file_field', :class => "error")
    else
      @template.content_tag(:dt, label_for(method, excluded_options(options))) +
      @template.content_tag(:dd, file_field(method, excluded_options(options)), :id => 'file_field')
    end
  end
  
  def dl_submit(*params)
    @template.content_tag(:dt, ' ') +
    @template.content_tag(:dd, submit(*params), :class => "buttons")
  end
  
  def dl_fckeditor(method, options = {})
    dd_content = <<-HTML
      <script type="text/javascript">
        <!--
        oFCKeditor = new FCKeditor('#{@object_name}[#{method}]');

        oFCKeditor.Config['ToolbarStartExpanded'] = true;
        oFCKeditor.ToolbarSet = 'Basic';
        oFCKeditor.Value = '#{escape_javascript(@object.send(method))}';
        oFCKeditor.Create();
        //-->
      </script>
    HTML
    
    css = initialize_css_classes(options)
    if errors_on_field?(object, method)
      css << ["error"]

      @template.content_tag(:dt, label_for(method, excluded_options(options).except(:toolbarSet)) + span_errors_for(object, method)) + 
      @template.content_tag(:dd, dd_content, :class => css.join(' '))
    else
      @template.content_tag(:dt, label_for(method, excluded_options(options).except(:toolbarSet))) + 
      @template.content_tag(:dd, dd_content, :class => css.join(' '))
    end
  end
  
  def dl_create_or_update_button(create_cancel_url = nil, update_cancel_url = nil, create_text = nil, update_text = nil)
    @template.content_tag(:dt, ' ') +
    @template.content_tag(:dd, create_or_update_buttons(create_cancel_url, update_cancel_url, create_text, update_text), :class => "buttons")
  end

  def create_or_update_buttons(create_cancel_url, update_cancel_url, create_text, update_text)
    dd_content = submit(object.new_record? ? (create_text || "Create") : (update_text || "Update"))
    dd_content += " or "
    
    cancel_url = object.new_record? ? create_cancel_url : update_cancel_url
    cancel_url ||= @template.polymorphic_url(object)
    
    dd_content += @template.link_to("Cancel", cancel_url)
  end

  private :create_or_update_buttons

  def ul_create_or_update_button(create_cancel_url = nil, update_cancel_url = nil, create_text = nil, update_text = nil)
    @template.content_tag(:li, create_or_update_buttons(create_cancel_url, update_cancel_url, create_text, update_text))
  end
  
  def dl_select(method, selections, options = {}, html_options = {})
    if errors_on_field?(object, method)
      errors = ""
      Array(object.errors.on(method)).each do |error|
        errors += @template.content_tag(:dt, error, :class => "error msg")
      end
      @template.content_tag(:dt, label_for(method, excluded_options(options)) + errors, :class => "error") +
      @template.content_tag(:dd, select(method, selections, options, html_options), :class => "error")
    else
      @template.content_tag(:dt, label_for(method, excluded_options(options))) +
      @template.content_tag(:dd, select(method, selections, options, html_options))
    end
  end

  def dl_country_select(method, priority_countries = nil, options = {}, html_options = {})
    @template.content_tag(:dt, label_for(method, excluded_options(options))) +
    @template.content_tag(:dd, country_select(method, priority_countries, options, html_options))
  end

  def dl_fields_for(object_name, *args, &proc)
    @template.labeled_fields_for(object_name, *args, &proc)
  end
end

ActionView::Base.send :include, LabeledFormHelper
ActionView::Helpers::InstanceTag.send :include, LabeledInstanceTag
ActionView::Helpers::FormBuilder.send :include, FormBuilderMethods

ActionView::Helpers::TagHelper.class_eval do
  if !instance_methods.include?("old_tag_from_list_form_helpers")
    def css_options_for_tag(name, options = { })
      name    = name.to_sym
      options = options.symbolize_keys

      unless options.has_key?(:class)
        if name.equal? :textarea
          options[:class] = "text"
        elsif name.equal?(:input) && options[:type] && options[:type] != "hidden"
          type = options[:type]
          css_class = type.dup

          if type == "submit" || type == "reset"
            css_class << " bn"
          elsif type == "password"
            css_class << " text"
          end

          options[:class] = css_class
        end
      end

      options
    end

    alias_method :old_tag_from_list_form_helpers, :tag

    def tag(name, options = nil, open = false, escape = true)
      options = { } unless options
      old_tag_from_list_form_helpers(name, css_options_for_tag(name, options), open, escape)
    end

  private

    alias_method :old_content_tag_string, :content_tag_string

    def content_tag_string(name, content, options, escape = true)
      options = { } unless options
      old_content_tag_string(name, content, css_options_for_tag(name, options), escape)
    end
  end
end

# module ActionView
#   module Helpers
#     class InstanceTag
#       alias_method :tag_without_error_wrapping, :tag
#     end
#   end
# end
