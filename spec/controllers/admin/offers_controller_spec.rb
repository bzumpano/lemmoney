require 'rails_helper'

RSpec.describe Admin::OffersController, type: :controller do
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
        let!(:offers) { create_list(:offer, 2) }

        it { expect(view_context.offers).to match_array(offers) }
      end
    end

    context 'pagination' do
      let(:per_page) { 3 }

      context 'default page' do
        before do
          create_list(:offer, per_page + 1)

          get(:index)
        end

        it { expect(controller.view_context.offers.count).to eq(per_page) }
      end


      context 'with page param' do
        before do
          create_list(:offer, per_page + 1)

          get(:index, params: { page: 2 })
        end

        it { expect(controller.view_context.offers.count).to eq(1) }
      end
    end
  end

  describe 'GET #new' do
    before { get(:new) }

    describe 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:new) }
    end

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      context 'offer' do
        it { expect(view_context.offer).to be_new_record }
      end
    end
  end

  describe 'POST #create' do
    let(:permitted_params) do
      %i[
        advertiser_name
        url
        description
        starts_at
        ends_at
        premium
      ]
    end

    let(:valid_params) do
      { offer: attributes_for(:offer) }
    end


    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      before { post(:create, params: valid_params) }

      context 'offer' do
        it { expect(view_context.offer).to be_persisted }
      end
    end

    describe 'permitted_params' do
      it { is_expected.to permit(*permitted_params).for(:create, params: valid_params).on(:offer) }
    end

    describe 'valid' do
      it 'saves' do
        expect do
          post(:create, params: valid_params)
        end.to change(Offer, :count).by(1)
      end

      context 'redirect to index' do
        let(:expected_flash) { I18n.t('admin.offers.create.done') }

        before { post(:create, params: valid_params) }

        it { expect(response).to redirect_to(admin_offers_path) }
        it { expect(controller).to set_flash.to(expected_flash) }
      end
    end

    context 'invalid' do
      before { allow_any_instance_of(Offer).to receive(:valid?).and_return(false) }

      it 'does not save' do
        expect do
          post(:create, params: valid_params)
        end.to change(Offer, :count).by(0)
      end

      context 'render new with errors' do
        let(:expected_flash) { I18n.t('admin.offers.create.error') }

        before { post(:create, params: valid_params) }

        it { expect(response).to render_template(:new) }
        it { expect(controller).to set_flash.now.to(expected_flash) }
      end
    end
  end

  describe 'GET #edit' do
    let(:offer) { create(:offer) }

    before { get(:edit, params: { id: offer }) }

    context 'template' do
      render_views

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:edit) }
    end

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      context 'offer' do
        it { expect(view_context.offer).to eq(offer) }
      end
    end
  end

  describe 'PATCH #update' do
    let(:offer) { create(:offer) }

    let(:permitted_params) do
      %i[
        advertiser_name
        url
        description
        starts_at
        ends_at
        premium
      ]
    end

    let(:valid_params) do
      {
        id: offer,
        offer: { advertiser_name: new_advertiser_name }
      }
    end

    let(:new_advertiser_name) { 'New name' }

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      before { patch(:update, params: valid_params) }

      context 'offer' do
        it { expect(view_context.offer).to eq(offer) }
      end
    end

    it 'permitted_params' do
      is_expected.to permit(*permitted_params).for(:update, params: valid_params).on(:offer)
    end

    context 'valid' do
      context 'saves' do
        before { patch(:update, params: valid_params) }

        it { expect(offer.reload.advertiser_name).to eq(new_advertiser_name) }
      end

      context 'redirect to index' do
        let(:expected_flash) { I18n.t('admin.offers.update.done') }

        before { patch(:update, params: valid_params) }

        it { expect(response).to redirect_to(admin_offers_path) }
        it { expect(controller).to set_flash.to(expected_flash) }
      end
    end

    context 'invalid' do
      render_views

      context 'does not save' do
        # invalid because is not unique name
        let(:new_advertiser_name) { create(:offer).advertiser_name }

        before { patch(:update, params: valid_params) }

        it { expect(response).to render_template(:edit) }
        it { expect(offer.reload.advertiser_name).not_to eq(new_advertiser_name) }
        it { expect(controller).to set_flash.now.to(I18n.t("admin.offers.update.error")) }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:offer) { create(:offer) }

    describe 'helper methods' do
      let(:view_context) { controller.view_context }

      before { delete(:destroy, params: { id: offer }) }

      context 'offer' do
        it { expect(view_context.offer).to eq(offer) }
      end
    end

    context 'valid' do
      it 'destroys' do
        offer

        expect do
          delete(:destroy, params: { id: offer })

          expect(response).to redirect_to(admin_offers_path)
        end.to change(Offer, :count).by(-1)
      end

      context 'redirect to index' do
        before { delete(:destroy, params: { id: offer }) }

        it { expect(response).to redirect_to(admin_offers_path) }
      end

      context 'set flash' do
        let(:expected_flash) { I18n.t('admin.offers.destroy.done') }

        before { delete(:destroy, params: { id: offer }) }

        it { expect(controller).to set_flash.to(expected_flash) }
      end
    end

    context 'invalid' do
      before { allow_any_instance_of(Offer).to receive(:destroy).and_return(false) }

      it 'does not destroys' do
        offer

        expect do
          delete(:destroy, params: { id: offer })

          expect(response).to redirect_to(admin_offers_path)
        end.to change(Offer, :count).by(0)
      end

      context 'redirect to index' do
        before { delete(:destroy, params: { id: offer }) }

        it { expect(response).to redirect_to(admin_offers_path) }
      end

      context 'set flash' do
        let(:expected_flash) { I18n.t('admin.offers.destroy.error') }

        before { delete(:destroy, params: { id: offer }) }

        it { expect(controller).to set_flash.to(expected_flash) }
      end
    end
  end
end
