require 'rails_helper'

RSpec.describe Offer, type: :model do
  subject(:offer) { build(:offer) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    context 'columns' do
      it { is_expected.to have_db_column(:advertiser_name).of_type(:string) }
      it { is_expected.to have_db_column(:url).of_type(:string) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:starts_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:ends_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:premium).of_type(:boolean) }
      it { is_expected.to have_db_column(:status).of_type(:integer).with_options(default: :disabled) }
    end
  end

  describe 'validations' do
    describe 'presence' do
      it { is_expected.to validate_presence_of(:advertiser_name) }
      it { is_expected.to validate_presence_of(:url) }
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:starts_at) }
    end

    describe 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:advertiser_name) }
    end

    describe 'length' do
      it { is_expected.to validate_length_of(:description).is_at_most(500) }
    end

    describe 'url' do
      it { is_expected.to validate_url_of(:url) }
    end
  end

  describe 'enums' do
    describe 'status' do
      let(:expected) do
        { disabled: 0, enabled: 1 }
      end

      it { is_expected.to define_enum_for(:status).with_values(expected) }
    end
  end
end
