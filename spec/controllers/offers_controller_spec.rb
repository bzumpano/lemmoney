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
        let!(:regular_offer) { create(:offer, :enabled, premium: false) }
        let!(:premium_offer) { create(:offer, :enabled, premium: true) }

        before { create(:offer, status: :disabled) }

        it { expect(view_context.offers).to eq([premium_offer, regular_offer]) }
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
