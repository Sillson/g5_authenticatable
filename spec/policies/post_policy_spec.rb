require 'spec_helper'

describe PostPolicy do
  subject(:policy) { described_class }

  let(:record) { FactoryGirl.create(:post) }

  permissions :index? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :new? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :create? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :edit? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :update? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions :destroy? do
    it_behaves_like 'a super_admin authorizer'
  end

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
