module FormHelper
  def labelled_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    form_for(record_or_name_or_array, *(args << options.merge(:builder => LabellingFormBuilder)), &proc)
  end
  
  class LabellingFormBuilder < ActionView::Helpers::FormBuilder
    %w( text_field text_area ).each do |type|
      class_eval <<-RUBY
        def #{type}(name)
          @template.content_tag :div, label(name) + @template.tag(:br) + super, :class => "field"
        end
      RUBY
    end
    
    def errors
      if @object.errors.any?
        @template.render "form/error", :object => @object
      end
    end
    
    def actions(&block)
      content = submit
      content << @template.capture(&block) if block
      @template.content_tag :div, content, :class => "actions"
    end
  end
end
