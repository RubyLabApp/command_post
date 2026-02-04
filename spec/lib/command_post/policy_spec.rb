require "rails_helper"

RSpec.describe CommandPost::Policy do
  describe "with allow rules" do
    let(:policy) do
      described_class.new do
        allow :index, :show
        allow :create, :update, if: ->(user) { user == :admin }
        allow :destroy, if: ->(user) { user == :super_admin }
      end
    end

    it "allows unrestricted actions" do
      expect(policy.allowed?(:index, :user)).to be(true)
      expect(policy.allowed?(:show, :user)).to be(true)
    end

    it "checks conditional allows" do
      expect(policy.allowed?(:create, :admin)).to be(true)
      expect(policy.allowed?(:create, :user)).to be(false)
    end

    it "restricts destroy" do
      expect(policy.allowed?(:destroy, :super_admin)).to be(true)
      expect(policy.allowed?(:destroy, :admin)).to be(false)
    end
  end

  describe "with deny rules" do
    let(:policy) do
      described_class.new do
        allow :index, :show, :create, :update, :destroy
        deny :destroy, if: ->(record) { record == :protected }
      end
    end

    it "denies when condition matches" do
      expect(policy.denied?(:destroy, nil, :protected)).to be(true)
    end

    it "allows when condition does not match" do
      expect(policy.denied?(:destroy, nil, :normal)).to be(false)
    end
  end

  describe "without policy" do
    let(:policy) { described_class.new }

    it "allows everything by default" do
      expect(policy.allowed?(:destroy, :anyone)).to be(true)
    end
  end
end
