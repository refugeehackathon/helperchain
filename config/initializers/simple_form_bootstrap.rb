# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls form-group margin-bottom-20' do |ba|
      ba.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      ba.use :input, class: 'form-control'
    end
  end

  config.wrappers :no_label, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'controls form-group margin-bottom-20' do |input|
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
      input.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      input.wrapper tag: 'div', class: "input-group margin-bottom-20" do |append|
        append.use :input, class: 'form-control'
      end
    end
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end
