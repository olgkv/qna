require 'rails_helper'

shared_examples_for 'linkable' do
  describe 'relationships' do
    it { should have_many(:links).dependent(:destroy) }
  end

  it { should accept_nested_attributes_for :links }
end
