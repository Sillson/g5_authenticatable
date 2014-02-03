require 'spec_helper'

describe G5Authenticatable::User do
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:provider) }
  it { should allow_mass_assignment_of(:uid) }
end
