# frozen_string_literal: true
require 'rails_helper'

RSpec.describe StartCsvImportJob, type: :job do
  describe '#perform' do
    let(:user) { FactoryBot.create(:user) }

    context 'with a valid CsvImport record' do
      let(:csv_import) do
        import = CsvImport.new(user: user)
        File.open(csv_file) { |f| import.manifest = f }
        import.save!
        import
      end

      let(:csv_file) { File.join(fixture_path, 'csv_import', 'import_manifest.csv') }

      it 'starts the importer' do
        expect_any_instance_of(ModularImporter).to receive(:import)
        described_class.perform_now(csv_import.id)
      end
    end
  end
end