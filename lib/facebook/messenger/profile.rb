require 'httparty'

module Facebook
  module Messenger
    # This module handles changing your bot's Messenger Profile settings.
    # Facebook describes the Messenger Profile as a central store for your bot's properties.
    #
    # https://developers.facebook.com/docs/messenger-platform/messenger-profile
    module Profile
      include HTTParty

      base_uri 'https://graph.facebook.com/v2.6/me/messenger_profile'

      format :json

      module_function

      # Sets the given settings object properties in the Messenger Profile settings
      #
      # The following settings keys are available to be set:
      #
      #   persistent_menu, get_started, greeting, whitelisted_domains,
      #   account_linking_url, payment_settings, target_audience
      def set(settings, access_token:)
        response = post '', body: settings.to_json, query: {
          access_token: access_token
        }

        raise_errors(response)

        true
      end

      # Unsets an array of settings keys in the Messenger Profile settings
      #
      # The following settings keys are available to be unset:
      #
      #   persistent_menu, get_started, greeting, whitelisted_domains,
      #   account_linking_url, payment_settings, target_audience
      def unset(fields = [], access_token:)
        response = delete '', body: { fields: fields }.to_json, query: {
          access_token: access_token
        }

        raise_errors(response)

        true
      end

      def raise_errors(response)
        raise Error, response['error'] if response.key? 'error'
      end

      def default_options
        super.merge(
          headers: {
            'Content-Type' => 'application/json'
          }
        )
      end

      class Error < Facebook::Messenger::FacebookError; end
    end
  end
end
