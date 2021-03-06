require "rails_helper"

describe Customer do
  it { should belong_to :agency }
  it { should belong_to :product }
  it { should validate_presence_of :agency }
  it { should validate_presence_of :product }
end
