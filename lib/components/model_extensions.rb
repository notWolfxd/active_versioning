module ActiveVersioning::ModelExtensions
  # The class that holds a specific model's versions
  #
  # @params class_name: String, a model name
  # allows a method in your models 'versioned_class "ArticleVersions"'
  def versioned_class(class_name = nil)
    return @versioned_class unless class_name

    @versioned_class = class_name.constantize
  end

  # The foreign key on the model's versions table
  # that relates to the specific model
  #
  # @params foreign_key: String, a foreign key
  # allows a method in your models 'versioned_foreign_key :article_id'
  def versioned_foreign_key(foreign_key = nil)
    return @versioned_foreign_key unless foreign_key

    @versioned_foreign_key = foreign_key.to_sym
  end

  # The columns that are subject to versioning
  # on your model.
  #
  # @params columns: Array, versionable columns 
  # on the model. Columns must also exist on the
  # model's versioning table. allows a method in
  # your models 'versioned_columns :body, :title, :author_id'
  def versioned_columns(columns = nil)
    return @versioned_columns unless columns

    @versioned_columns = columns
  end
end