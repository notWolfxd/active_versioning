require 'active_versioning'

FactoryBot.define do
  factory(:article_version) do
    include { ActiveVersioning }
    
    transient do
      version_count { 1 }
    end

    sequence(:article_id)
    sequence(:user_id)

    sequence(:body) { |n| "Some body #{n}" }
    sequence(:title) { |n| "Some title #{n}" }

    trait :with_versions do
      after(:create) do |article_version, evaluator|
        create_list(:article_version, evaluator.version_count, article_id: article_version.article_id, user_id: article_version.user_id)
      end
    end
  end
end