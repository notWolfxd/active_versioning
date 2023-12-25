require_relative 'components/historical'
require_relative 'components/model_extensions'
require_relative 'components/model_versions'

module ActiveVersioning
  class ComparisonError < StandardError ; end

  def self.included(base)
    base.extend(ActiveVersioning::ModelExtensions)
  end

  extend ActiveVersioning::Historical
  extend ActiveVersioning::ModelVersions
end