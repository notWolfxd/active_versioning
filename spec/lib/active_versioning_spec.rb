require 'spec_helper'
require 'factories/article'
require 'factories/article_version'

RSpec.describe ActiveVersioning do
  it 'creates an Article' do
    article = create(:article)

    expect(article.title).to eq('Some title')
    expect(article.body).to eq('Some body')
  end

  it 'creates 3 Article versions' do
    article_version = create(:article_version, :with_versions, version_count: 3)

    expect(article_version.size).to eq(4)
  end
end