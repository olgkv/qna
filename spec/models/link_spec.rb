require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'relationships' do
    it { should belong_to :question }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
  end
end
