require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  describe 'GET #index' do
    before { get(:index) }

    describe 'template' do
      render_views

      context 'responds with success and renders templates' do
        it { expect(response).to be_successful }
        it { expect(response).to render_template(:index) }
      end
    end

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      context 'offers' do
        let!(:regular_offers) do
          [
            create(:offer, :enabled, premium: false, starts_at: 1.day.ago, ends_at: 1.day.since),
            create(:offer, :enabled, premium: false, starts_at: 1.day.ago, ends_at: nil),
          ]
        end
        let!(:premium_offer) { create(:offer, :enabled, premium: true, starts_at: 1.day.ago, ends_at: nil) }

        let(:expected) do
          [premium_offer] + regular_offers
        end

        before do
          # offers that should not appear
          create(:offer, status: :disabled)
          create(:offer, :enabled, starts_at: 1.day.since, ends_at: 1.day.ago)
          create(:offer, :enabled, starts_at: 2.day.since, ends_at: 1.day.ago)
        end

        it { expect(view_context.offers).to eq(expected) }
      end
    end

    context 'pagination' do
      let(:per_page) { 4 }

      context 'default page' do
        before do
          create_list(:offer, per_page + 1, :enabled)

          get(:index)
        end

        it { expect(controller.view_context.offers.count).to eq(per_page) }
      end


      context 'with page param' do
        before do
          create_list(:offer, per_page + 1, :enabled)

          get(:index, params: { page: 2 })
        end

        it { expect(controller.view_context.offers.count).to eq(1) }
      end
    end
  end

end
