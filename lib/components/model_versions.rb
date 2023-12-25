module ActiveVersioning::ModelVersions
  # Retrieve all of the versions for a model
  #
  # Usage: Model.find(1).versions
  def versions
    self.class.versioned_class.where("#{self.class.versioned_foreign_key} = ? AND version IS NOT NULL", id).order(version: :desc) || []
  end

  # Retrieve the current version of a model
  # Returns an integer value
  #
  # Usage: Model.find(1).version
  # => 3
  def version
    versions.size > 0 ? versions.pluck(:version).first : nil
  end

  alias_method :current_version_value, :version

  # Get the integer for the next version
  # Returns an integer value
  #
  # Usage: Model.find(1).next_version_value
  # => 4
  def next_version_value
    version ? version + 1 : 1
  end

  # Get the integer for the previous version
  # Returns an integer value
  #
  # Usage: Model.find(1).previous_version_value
  # => 3
  def previous_version_value
    version && version > 1 ? version - 1 : nil
  end

  # Get a count of the versions on a model
  # Returns an integer value
  #
  # Usage: Model.find(1).version_count
  # => 10 
  def version_count
    versions.size
  end

  # Determines if the model is the first version
  # and has not been edited yet
  # Returns a boolean value
  #
  # Usage: Model.find(1).first_version?
  # => false
  def first_version?
    !previous_version
  end

  # Determines if the model has been revised
  # Returns a boolean value
  #
  # Usage: Model.find(1).revised?
  def revised?
    updated_at > created_at
  end

  # Get the previous version of the model
  # Returns a ModelVersion instance
  #
  # Usage: Model.find(1).previous_version
  # => <# ArticleVersion id: 739, ...>
  def previous_version
    versions.size > 1 ? versions.offset(1).first : nil
  end

  alias_method :last_version, :previous_version

  # Get the first version of the model
  # Returns a ModelVersion instance
  #
  # Usage: Model.find(1).first_version
  # => <# ArticleVersion id: 739, ...>
  def first_version
    versions.size > 0 ? versions.last : nil
  end

  alias_method :earliest_version, :first_version

  # Get the current version of the model
  # Returns a ModelVersion instance
  #
  # Usage: Model.find(1).current_version
  # => <# ArticleVersion id: 739, ...>
  def current_version
    versions.size > 0 ? versions.first : nil
  end

  alias_method :latest_version, :current_version

  # Determine if a version is identical to the current version
  # Helps prevent creating empty versions, with no changes
  #
  # @params version: Version of the versioned model
  # @params invoker: String, accepts "revert" or "undo",
  # relates to the context for comparing versions
  # since undoing a version has different logic than
  # simply reverting to an older version
  def is_identical_version?(version: previous_version, invoker: nil)
    old_version = self
    if invoker == "revert"
      new_version = self.class.versioned_columns.each do |attr|
        self[attr] = version[attr]
      end
    elsif invoker == "undo"
      new_version = diff(version).each do |attr, old_value, new_value|
        self[attr] = old_value if old_value != new_value
      end
    else
      return raise ActiveVersioning::ComparisonError, 'valid comparions are either "revert" or "undo"'
    end

    old_version == new_version
  end

  # Reverts the model to the version before a specific version
  def before(version: current_version)
    first_version? || version.id == first_version.id ? self : (revert_to(versions.where("version < ?", version.version).order(version: :desc).first) rescue self)
  end

  def after(version: previous_version)
    first_version? || version.id == current_version.id ? self : (revert_to(versions.where("version > ?", version.version).order(version: :desc).first) rescue self)
  end
end