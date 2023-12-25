require_relative 'components/historical'
require_relative 'components/model_extensions'
require_relative 'components/model_versions'

module ActiveVersioning
  class ComparisonError < StandardError ; end

  def self.included(base)
    base.extend(ModelExtensions)
  end

  extend Historical
  extend ModelVersions
end