require 'active_versioning'

FactoryBot.define do
  factory(:article) do
    include { ActiveVersioning }

    versioned_class { "ArticleVersion" }
    versioned_foreign_key { :article_id }
    versioned_columns {[ :title, :body ]}

    id
    author_id
    body { "Some body" }
    title { "Some title" }
  end
end