module ActiveVersioning::Historical
  # Returns differences between the provided version and
  # the current version. Used when undoing a specific
  # version's changes
  # @params version: Version of the versioned model
  def diff(version: previous_version)
    self.class.versioned_columns.map { |attr| [attr, [version&.send(attr), send(attr)]] }.to_h
  end

  # Cannot undo something if there is only a single version
  # Returns a boolean value
  #
  # Usage: Model.find(1).can_be_undone?
  # => true
  def can_be_undone?
    versions.size > 1
  end

  # Reverts the instance of a versioned model to a previous
  # version. This will not modify the model in the database.
  #
  # @params version: Version of the versioned model
  # @params force: Boolean, indicates you want to create a new version
  # ### NOTE: Using force = true here will require you to manually save
  # for the changes to take affect. This is meant to be a non-change method.
  # @params user: User object, specifically the user performing
  # the edit or changes
  #
  # See revert_to! method for the method that will handle updating
  # the model in the database.
  def revert_to(version: previous_version, force: false, user: nil)
    return self if id != version[self.class.versioned_foreign_key]

    if force && user
      self.class.create_version(version, user) if !is_identical_version?(version, "revert")
    end

    self.class.versioned_columns.each do |attr|
      self[attr] = version[attr]
    end

    self
  end

  # Undoes a specific version in the model's history. This will
  # return what the model will look like after the changes are
  # undone. This will not modify the model in the database.
  #
  # @params version: Version of the versioned model
  # @params force: Boolean, indicates you want to create a new version
  # ### NOTE: Using force = true here will require you to manually save
  # for the changes to take affect. This is meant to be a non-change method.
  # @params user: User object, specifically the user performing
  # the edit or changes
  #
  # See undo! method for the method that will handle updating
  # the model in the database.
  def undo(version: previous_version, force: false, user: nil)
    return self if id != version[self.class.versioned_foreign_key]

    if force && user
      self.class.create_version(version, user) if !is_identical_version(version, "undo")
    end

    diff(version).each do |attr, old_value, new_value|
      self[attr] = old_value if old_value != new_value
    end

    self
  end

  # Reverts the instance of a versioned model to a previous
  # version. This will modify the model in the database.
  #
  # @params version: Version of the versioned model
  # @params user: User object, specifically the user performing
  # the edit or changes
  #
  # See revert_to method for the method that handles the logic
  # around determining the new version of the model after the
  # version's changes are reverted.
  def revert_to!(version: previous_version, user: nil)
    return if version.nil? || user.nil?

    revert_to(version, true, user)
    save!
  end

  # Undoes a specific version in the model's history. 
  # This will modify the model in the database.
  #
  # @params version: Version of the versioned model
  # @params user: User object, specifically the user performing
  # the edit or changes
  #
  # See undo method for the method that handles the logic
  # around determining the new version of the model after the
  # version's changes are undone.
  def undo!(version: previous_version, user: nil)
    return if version.nil? || user.nil?

    undo(version, true, user)
    save!
  end
end