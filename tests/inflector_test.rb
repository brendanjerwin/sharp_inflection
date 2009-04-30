require 'abstract_unit'
require 'inflector_test_cases'
require File.dirname(__FILE__) + \
  '../sharp_inflection/bin/Debug/SharpInflection.dll'

module Ace
  module Base
    class Case
    end
  end
end

class InflectorTest < Test::Unit::TestCase
  include InflectorTestCases

  def test_pluralize_plurals
    assert_equal "plurals", SharpInflection::Inflector.pluralize("plurals")
    assert_equal "Plurals", SharpInflection::Inflector.pluralize("Plurals")
  end

  def test_pluralize_empty_string
    assert_equal "", SharpInflection::Inflector.pluralize("")
  end

  SingularToPlural.each do |singular, plural|
    define_method "test_pluralize_#{singular}" do
      assert_equal(plural, SharpInflection::Inflector.pluralize(singular))
      assert_equal(plural.capitalize, SharpInflection::Inflector.pluralize(singular.capitalize))
    end
  end

  SingularToPlural.each do |singular, plural|
    define_method "test_singularize_#{plural}" do
      assert_equal(singular, SharpInflection::Inflector.singularize(plural))
      assert_equal(singular.capitalize, SharpInflection::Inflector.singularize(plural.capitalize))
    end
  end

  def test_overwrite_previous_inflectors
    assert_equal("series", SharpInflection::Inflector.singularize("series"))
    SharpInflection::Inflector.inflections.singular "series", "serie"
    assert_equal("serie", SharpInflection::Inflector.singularize("series"))
    SharpInflection::Inflector.inflections.uncountable "series" # Return to normal
  end

  MixtureToTitleCase.each do |before, titleized|
    define_method "test_titleize_#{before}" do
      assert_equal(titleized, SharpInflection::Inflector.titleize(before))
    end
  end

  def test_camelize
    CamelToUnderscore.each do |camel, underscore|
      assert_equal(camel, SharpInflection::Inflector.camelize(underscore))
    end
  end

  def test_camelize_with_lower_downcases_the_first_letter
    assert_equal('capital', SharpInflection::Inflector.camelize('Capital', false))
  end

  def test_underscore
    CamelToUnderscore.each do |camel, underscore|
      assert_equal(underscore, SharpInflection::Inflector.underscore(camel))
    end
    CamelToUnderscoreWithoutReverse.each do |camel, underscore|
      assert_equal(underscore, SharpInflection::Inflector.underscore(camel))
    end
  end

  def test_camelize_with_module
    CamelWithModuleToUnderscoreWithSlash.each do |camel, underscore|
      assert_equal(camel, SharpInflection::Inflector.camelize(underscore))
    end
  end

  def test_underscore_with_slashes
    CamelWithModuleToUnderscoreWithSlash.each do |camel, underscore|
      assert_equal(underscore, SharpInflection::Inflector.underscore(camel))
    end
  end

  def test_demodulize
    assert_equal "Account", SharpInflection::Inflector.demodulize("MyApplication::Billing::Account")
  end

  def test_foreign_key
    ClassNameToForeignKeyWithUnderscore.each do |klass, foreign_key|
      assert_equal(foreign_key, SharpInflection::Inflector.foreign_key(klass))
    end

    ClassNameToForeignKeyWithoutUnderscore.each do |klass, foreign_key|
      assert_equal(foreign_key, SharpInflection::Inflector.foreign_key(klass, false))
    end
  end

  def test_tableize
    ClassNameToTableName.each do |class_name, table_name|
      assert_equal(table_name, SharpInflection::Inflector.tableize(class_name))
    end
  end

  def test_parameterize
    StringToParameterized.each do |some_string, parameterized_string|
      assert_equal(parameterized_string, SharpInflection::Inflector.parameterize(some_string))
    end
  end

  def test_parameterize_and_normalize
    StringToParameterizedAndNormalized.each do |some_string, parameterized_string|
      assert_equal(parameterized_string, SharpInflection::Inflector.parameterize(some_string))
    end
  end

  def test_parameterize_with_custom_separator
    StringToParameterized.each do |some_string, parameterized_string|
      assert_equal(parameterized_string.gsub('-', '_'), SharpInflection::Inflector.parameterize(some_string, '_'))
    end
  end

  def test_parameterize_with_multi_character_separator
    StringToParameterized.each do |some_string, parameterized_string|
      assert_equal(parameterized_string.gsub('-', '__sep__'), SharpInflection::Inflector.parameterize(some_string, '__sep__'))
    end
  end

  def test_classify
    ClassNameToTableName.each do |class_name, table_name|
      assert_equal(class_name, SharpInflection::Inflector.classify(table_name))
      assert_equal(class_name, SharpInflection::Inflector.classify("table_prefix." + table_name))
    end
  end

  def test_classify_with_symbol
    assert_nothing_raised do
      assert_equal 'FooBar', SharpInflection::Inflector.classify(:foo_bars)
    end
  end

  def test_classify_with_leading_schema_name
    assert_equal 'FooBar', SharpInflection::Inflector.classify('schema.foo_bar')
  end

  def test_humanize
    UnderscoreToHuman.each do |underscore, human|
      assert_equal(human, SharpInflection::Inflector.humanize(underscore))
    end
  end

  def test_humanize_by_rule
    SharpInflection::Inflector.inflections do |inflect|
      inflect.human(/_cnt$/i, '\1_count')
      inflect.human(/^prefx_/i, '\1')
    end
    assert_equal("Jargon count", SharpInflection::Inflector.humanize("jargon_cnt"))
    assert_equal("Request", SharpInflection::Inflector.humanize("prefx_request"))
  end

  def test_humanize_by_string
    SharpInflection::Inflector.inflections do |inflect|
      inflect.human("col_rpted_bugs", "Reported bugs")
    end
    assert_equal("Reported bugs", SharpInflection::Inflector.humanize("col_rpted_bugs"))
    assert_equal("Col rpted bugs", SharpInflection::Inflector.humanize("COL_rpted_bugs"))
  end

  def test_constantize
    assert_nothing_raised { assert_equal Ace::Base::Case, SharpInflection::Inflector.constantize("Ace::Base::Case") }
    assert_nothing_raised { assert_equal Ace::Base::Case, SharpInflection::Inflector.constantize("::Ace::Base::Case") }
    assert_nothing_raised { assert_equal InflectorTest, SharpInflection::Inflector.constantize("InflectorTest") }
    assert_nothing_raised { assert_equal InflectorTest, SharpInflection::Inflector.constantize("::InflectorTest") }
    assert_raise(NameError) { SharpInflection::Inflector.constantize("UnknownClass") }
    assert_raise(NameError) { SharpInflection::Inflector.constantize("An invalid string") }
    assert_raise(NameError) { SharpInflection::Inflector.constantize("InvalidClass\n") }
  end

  def test_constantize_does_lexical_lookup
    assert_raise(NameError) { SharpInflection::Inflector.constantize("Ace::Base::InflectorTest") }
  end

  def test_ordinal
    OrdinalNumbers.each do |number, ordinalized|
      assert_equal(ordinalized, SharpInflection::Inflector.ordinalize(number))
    end
  end

  def test_dasherize
    UnderscoresToDashes.each do |underscored, dasherized|
      assert_equal(dasherized, SharpInflection::Inflector.dasherize(underscored))
    end
  end

  def test_underscore_as_reverse_of_dasherize
    UnderscoresToDashes.each do |underscored, dasherized|
      assert_equal(underscored, SharpInflection::Inflector.underscore(SharpInflection::Inflector.dasherize(underscored)))
    end
  end

  def test_underscore_to_lower_camel
    UnderscoreToLowerCamel.each do |underscored, lower_camel|
      assert_equal(lower_camel, SharpInflection::Inflector.camelize(underscored, false))
    end
  end

  %w{plurals singulars uncountables humans}.each do |inflection_type|
    class_eval "
      def test_clear_#{inflection_type}
        cached_values = SharpInflection::Inflector.inflections.#{inflection_type}
        SharpInflection::Inflector.inflections.clear :#{inflection_type}
        assert SharpInflection::Inflector.inflections.#{inflection_type}.empty?, \"#{inflection_type} inflections should be empty after clear :#{inflection_type}\"
        SharpInflection::Inflector.inflections.instance_variable_set :@#{inflection_type}, cached_values
      end
    "
  end

  def test_clear_all
    cached_values = SharpInflection::Inflector.inflections.plurals, SharpInflection::Inflector.inflections.singulars, SharpInflection::Inflector.inflections.uncountables, SharpInflection::Inflector.inflections.humans
    SharpInflection::Inflector.inflections.clear :all
    assert SharpInflection::Inflector.inflections.plurals.empty?
    assert SharpInflection::Inflector.inflections.singulars.empty?
    assert SharpInflection::Inflector.inflections.uncountables.empty?
    assert SharpInflection::Inflector.inflections.humans.empty?
    SharpInflection::Inflector.inflections.instance_variable_set :@plurals, cached_values[0]
    SharpInflection::Inflector.inflections.instance_variable_set :@singulars, cached_values[1]
    SharpInflection::Inflector.inflections.instance_variable_set :@uncountables, cached_values[2]
    SharpInflection::Inflector.inflections.instance_variable_set :@humans, cached_values[3]
  end

  def test_clear_with_default
    cached_values = SharpInflection::Inflector.inflections.plurals, SharpInflection::Inflector.inflections.singulars, SharpInflection::Inflector.inflections.uncountables, SharpInflection::Inflector.inflections.humans
    SharpInflection::Inflector.inflections.clear
    assert SharpInflection::Inflector.inflections.plurals.empty?
    assert SharpInflection::Inflector.inflections.singulars.empty?
    assert SharpInflection::Inflector.inflections.uncountables.empty?
    assert SharpInflection::Inflector.inflections.humans.empty?
    SharpInflection::Inflector.inflections.instance_variable_set :@plurals, cached_values[0]
    SharpInflection::Inflector.inflections.instance_variable_set :@singulars, cached_values[1]
    SharpInflection::Inflector.inflections.instance_variable_set :@uncountables, cached_values[2]
    SharpInflection::Inflector.inflections.instance_variable_set :@humans, cached_values[3]
  end

  Irregularities.each do |irregularity|
    singular, plural = *irregularity
    SharpInflection::Inflector.inflections do |inflect|
      define_method("test_irregularity_between_#{singular}_and_#{plural}") do
        inflect.irregular(singular, plural)
        assert_equal singular, SharpInflection::Inflector.singularize(plural)
        assert_equal plural, SharpInflection::Inflector.pluralize(singular)
      end
    end
  end

  [ :all, [] ].each do |scope|
    SharpInflection::Inflector.inflections do |inflect|
      define_method("test_clear_inflections_with_#{scope.kind_of?(Array) ? "no_arguments" : scope}") do
        # save all the inflections
        singulars, plurals, uncountables = inflect.singulars, inflect.plurals, inflect.uncountables

        # clear all the inflections
        inflect.clear(*scope)

        assert_equal [], inflect.singulars
        assert_equal [], inflect.plurals
        assert_equal [], inflect.uncountables

        # restore all the inflections
        singulars.reverse.each { |singular| inflect.singular(*singular) }
        plurals.reverse.each   { |plural|   inflect.plural(*plural) }
        inflect.uncountable(uncountables)

        assert_equal singulars, inflect.singulars
        assert_equal plurals, inflect.plurals
        assert_equal uncountables, inflect.uncountables
      end
    end
  end

  { :singulars => :singular, :plurals => :plural, :uncountables => :uncountable, :humans => :human }.each do |scope, method|
    SharpInflection::Inflector.inflections do |inflect|
      define_method("test_clear_inflections_with_#{scope}") do
        # save the inflections
        values = inflect.send(scope)

        # clear the inflections
        inflect.clear(scope)

        assert_equal [], inflect.send(scope)

        # restore the inflections
        if scope == :uncountables
          inflect.send(method, values)
        else
          values.reverse.each { |value| inflect.send(method, *value) }
        end

        assert_equal values, inflect.send(scope)
      end
    end
  end
end
