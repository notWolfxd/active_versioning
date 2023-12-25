require_relative 'components/historical'
require_relative 'components/model_extensions'
require_relative 'components/model_versions'

module ActiveVersioning
  class ComparisonError < StandardError ; end
  class NilParameterError < StandardError ; end
  class MismatchError < StandardError ; end

  def self.included(base)
    base.extend(ModelExtensions)
  end

  include Historical
  include ModelVersions
end