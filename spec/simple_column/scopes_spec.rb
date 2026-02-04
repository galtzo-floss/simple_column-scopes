# frozen_string_literal: true

require "spec_helper"
require "anonymous_active_record"

RSpec.describe SimpleColumn::Scopes do
  it "has a version number" do
    expect(SimpleColumn::Scopes::VERSION).not_to be_nil
  end

  describe "initialization" do
    it "accepts scope names starting with for_" do
      expect { described_class.new(:for_user_id) }.not_to raise_error
    end

    it "raises ArgumentError for scope names not starting with for_" do
      expect { described_class.new(:user_id) }.to raise_error(ArgumentError, /SimpleColumn::Scopes need to be named like for_/)
    end

    it "raises ArgumentError for empty scope names" do
      expect { described_class.new(:"") }.to raise_error(ArgumentError, /SimpleColumn::Scopes need to be named like for_/)
    end

    it "handles multiple scope names" do
      expect { described_class.new(:for_user_id, :for_post_id) }.not_to raise_error
    end
  end

  describe "integration with ActiveRecord", :aggregate_failures do
    let(:scopes) { described_class }
    let(:model) do
      AnonymousActiveRecord.generate(columns: %w[name category_id active]) do
        # rubocop:disable RSpec/DescribedClass
        include SimpleColumn::Scopes.new(:for_name, :for_category_id, :for_active)
        # rubocop:enable RSpec/DescribedClass
      end
    end

    it "defines scopes on the model" do
      expect(model).to respond_to(:for_name)
      expect(model).to respond_to(:for_category_id)
      expect(model).to respond_to(:for_active)
    end

    it "filters records correctly" do
      model.create!(name: "First", category_id: 1, active: true)
      model.create!(name: "Second", category_id: 1, active: false)
      model.create!(name: "Third", category_id: 2, active: true)

      expect(model.for_name("First").pluck(:name)).to contain_exactly("First")
      expect(model.for_category_id(1).pluck(:name)).to contain_exactly("First", "Second")
      expect(model.for_active(true).pluck(:name)).to contain_exactly("First", "Third")
      expect(model.for_active(false).pluck(:name)).to contain_exactly("Second")
    end

    it "can be chained" do
      model.create!(name: "First", category_id: 1, active: true)
      model.create!(name: "Second", category_id: 1, active: false)

      expect(model.for_category_id(1).for_active(true).pluck(:name)).to contain_exactly("First")
    end
  end
end
