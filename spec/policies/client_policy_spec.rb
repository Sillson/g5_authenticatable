require 'spec_helper'

describe G5Updatable::ClientPolicy do
  subject(:policy) { described_class }

  let(:user) { FactoryGirl.create(:g5_authenticatable_user) }
  let(:user2) { FactoryGirl.create(:g5_authenticatable_user) }

  before do
    user.roles = []
    user.save!
    user2.add_role(:viewer, client_1)
  end

  let!(:client_1) { FactoryGirl.create(:g5_updatable_client) }
  let!(:client_2) { FactoryGirl.create(:g5_updatable_client) }
  let!(:client_3) { FactoryGirl.create(:g5_updatable_client) }

  describe '.resolve' do

    subject { G5Updatable::ClientPolicy::Scope.new(user, G5Updatable::Client).resolve }

    context 'with global role' do
      before { user.add_role :admin }
      it 'returns all clients' do
        expect(subject.length).to eq(3)
        expect(subject).to include(client_1)
        expect(subject).to include(client_2)
        expect(subject).to include(client_3)
      end
    end

    context 'with client role' do
      before { user.add_role(:admin, client_1) }
      it 'returns a single client' do
        expect(subject.length).to eq(1)
        expect(subject).to include(client_1)
      end
    end

    context 'with many client roles'  do
      before do
        user.add_role(:admin, client_1)
        user.add_role(:admin, client_2)
        user.add_role(:admin, client_3)
      end
      it 'returns all assigned clients' do
        expect(subject.length).to eq(3)
        expect(subject).to include(client_1)
        expect(subject).to include(client_2)
        expect(subject).to include(client_3)
      end
    end

    context 'with no role' do
      it 'returns no clients' do
        expect(subject.length).to eq(0)
      end
    end
  end

  describe '.clients_from_client_and_location_roles', focus: true do
    subject { G5Updatable::ClientPolicy::Scope.new(user, G5Updatable::Client).clients_from_client_and_location_roles }

    let!(:location_1) { FactoryGirl.create(:g5_updatable_location, client: client_1) }
    let!(:location_2) { FactoryGirl.create(:g5_updatable_location, client: client_1) }

    let!(:location_3) { FactoryGirl.create(:g5_updatable_location, client: client_2) }
    let!(:location_4) { FactoryGirl.create(:g5_updatable_location, client: client_2) }

    context 'with global role' do
      before { user.add_role :admin }
      it 'returns all clients' do
        expect(subject.length).to eq(3)
        expect(subject).to include(client_1)
        expect(subject).to include(client_2)
        expect(subject).to include(client_3)
      end
    end

    context 'with role for location and for client that location belongs to' do
      before do
        user.add_role :admin, location_1
        user.add_role :admin, client_1
      end
      it 'returns 1 client' do
        expect(subject.length).to eq(1)
        expect(subject).to include(client_1)
      end
    end

    context 'with role for location and client that location does not belong to' do
      before do
        user.add_role :admin, location_1
        user.add_role :admin, client_2
      end
      it 'returns 1 client' do
        expect(subject.length).to eq(2)
        expect(subject).to include(client_1)
        expect(subject).to include(client_2)
      end
    end

    context 'with a client role' do
      before do
        user.add_role :admin, client_2
      end
      it 'returns 1 client' do
        expect(subject.length).to eq(1)
        expect(subject).to include(client_2)
      end
    end

    context 'with a location role' do
      before do
        user.add_role :admin, location_1
      end
      it 'returns 1 client' do
        expect(subject.length).to eq(1)
        expect(subject).to include(client_1)
      end
    end
  end
end
