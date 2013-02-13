module Cms
  module Attributes
    module RedirectAfterSubmitLink
      def redirect_after_submit_link_attribute
        :redirect_after_submit_link
      end

      def default_redirect_after_submit_link
        RailsConnector::LinkList.new(nil)
      ensure
        Cms::Errors::MissingAttribute.notify(self, __FILE__)
      end

      def redirect_after_submit_link
        self[redirect_after_submit_link_attribute] || default_redirect_after_submit_link
      end

      def redirect_after_submit_link?
        redirect_after_submit_link.present?
      end

      def redirect_after_submit
        redirect_after_submit_link.destination_objects.first
      end
    end
  end
end