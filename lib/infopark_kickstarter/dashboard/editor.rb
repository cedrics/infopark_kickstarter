module InfoparkKickstarter
  module Dashboard
    class Editor
      def self.all
        ::Infopark::Crm::Contact.all.select do |contact|
          contact.login.present? && contact.role_names.include?('superuser')
        end
      end
    end
  end
end