# coding: utf-8
module CaseForm
  module Element
    autoload :Base,            'case_form/element/base'
                               
    autoload :Fieldset,        'case_form/element/fieldset'
                                          
    autoload :Input,           'case_form/element/input'
    autoload :StringInput,     'case_form/element/inputs/string_input'
    autoload :TextInput,       'case_form/element/inputs/text_input'
    autoload :HiddenInput,     'case_form/element/inputs/hidden_input'
    autoload :SearchInput,     'case_form/element/inputs/search_input'
    autoload :FileInput,       'case_form/element/inputs/file_input'
    autoload :DateTimeInput,   'case_form/element/inputs/datetime/date_time_input'
    autoload :DateInput,       'case_form/element/inputs/datetime/date_input'
    autoload :TimeInput,       'case_form/element/inputs/datetime/time_input'
    autoload :TimeZoneInput,   'case_form/element/inputs/datetime/time_zone_input'
    autoload :NumberInput,     'case_form/element/inputs/number_input'
    autoload :CollectionInput, 'case_form/element/inputs/collection_input'
    autoload :SelectInput,     'case_form/element/inputs/collection/select_input'
    autoload :CheckboxInput,   'case_form/element/inputs/collection/checkbox_input'
    autoload :RadioInput,      'case_form/element/inputs/collection/radio_input'
                                       
    autoload :Label,           'case_form/element/label'
    autoload :Hint,            'case_form/element/hint'
                                          
    autoload :Button,          'case_form/element/button'
                               
    autoload :Error,           'case_form/element/error'
    autoload :SimpleError,     'case_form/element/errors/simple_error'
    autoload :ComplexError,    'case_form/element/errors/complex_error'
    
    autoload :Link,            'case_form/element/link'
  end
end