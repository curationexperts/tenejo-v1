# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Showing background services warnings on import page', :perform_jobs, :clean, type: :system, js: true do
  let(:admin_user) { FactoryBot.create(:admin) }
  let(:clamd_warning) { 'WARNING: antivirus is not configured correctly, please contact your system administrator' }
  before do
    login_as admin_user
    visit '/csv_imports/new'
  end
  context "with clamd stopped" do

    it "shows a warning on the page if clamd is down" do
      allow_any_instance_of(Zizia::CsvImportsController).to receive(:list_clamd_service).and_return("testing")

      expect(page).to have_content 'Batch Import'
      expect(page).to have_content clamd_warning

      # ps ax | grep [c]lamd
    end
  end

  context "with clamd running" do
    it "does not show a warning about clamd" do
      allow_any_instance_of(Zizia::CsvImportsController).to receive(:list_clamd_service).and_return("472 ?        Ssl    0:00 /usr/sbin/clamd -c /etc/clamav/clamd.conf --pid=/run/clamav/clamd.pid")

      expect(page).not_to have_content clamd_warning
    end
  end

end
