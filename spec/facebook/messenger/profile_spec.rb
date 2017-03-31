require 'spec_helper'

describe Facebook::Messenger::Profile do
  let(:access_token) { 'access token' }

  let(:profile_settings_url) do
    Facebook::Messenger::Profile.base_uri
  end

  before do
    ENV['ACCESS_TOKEN'] = access_token
  end

  describe '.set' do
    context 'with a successful response' do
      before do
        stub_request(:post, profile_settings_url)
          .with(
            query: {
              access_token: access_token
            },
            headers: {
              'Content-Type' => 'application/json'
            },
            body: JSON.dump(
              get_started: { payload: 'GET_STARTED' },
              greeting: [
                { locale: 'default', text: 'Hello!' },
                { locale: 'fr_FR', text: 'Bonjour!' }
              ]
            )
          )
          .to_return(
            body: JSON.dump(
              result: true
            ),
            status: 200,
            headers: default_graph_api_response_headers
          )
      end

      let :settings do
        {
          get_started: { payload: 'GET_STARTED' },
          greeting: [
            { locale: 'default', text: 'Hello!' },
            { locale: 'fr_FR', text: 'Bonjour!' }
          ]
        }
      end

      it 'returns true' do
        expect(subject.set(settings, access_token: access_token)).to be(true)
      end
    end

    context 'with an unsuccessful response' do
      let(:error_message) { 'Invalid OAuth access token.' }

      before do
        stub_request(:post, profile_settings_url)
          .with(query: { access_token: access_token })
          .to_return(
            body: JSON.dump(
              error: {
                message: error_message,
                type: 'OAuthException',
                code: 190,
                fbtrace_id: 'Hlssg2aiVlN'
              }
            ),
            status: 200,
            headers: default_graph_api_response_headers
          )
      end

      it 'raises an error' do
        expect do
          options = {
            get_started: { payload: 'GET_STARTED' },
            greeting: [
              { locale: 'default', text: 'Hello!' },
              { locale: 'fr_FR', text: 'Bonjour!' }
            ]
          }

          subject.set(options, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Profile::Error, error_message
        )
      end
    end
  end

  describe '.unset' do
    context 'with a successful response' do
      before do
        stub_request(:delete, profile_settings_url)
          .with(
            query: {
              access_token: access_token
            },
            headers: {
              'Content-Type' => 'application/json'
            },
            body: JSON.dump(fields: ['greeting', 'get_started'])
          )
          .to_return(
            body: JSON.dump(
              result: 'true'
            ),
            status: 200,
            headers: default_graph_api_response_headers
          )
      end

      let(:fields) { ['greeting', 'get_started'] }

      it 'returns true' do
        expect(subject.unset(fields, access_token: access_token)).to be(true)
      end
    end

    context 'with an unsuccessful response' do
      let(:error_message) { 'Invalid OAuth access token.' }

      before do
        stub_request(:delete, profile_settings_url)
          .with(query: { access_token: access_token })
          .to_return(
            body: JSON.dump(
              'error' => {
                'message' => error_message,
                'type' => 'OAuthException',
                'code' => 190,
                'fbtrace_id' => 'Hlssg2aiVlN'
              }
            ),
            status: 200,
            headers: default_graph_api_response_headers
          )
      end

      it 'raises an error' do
        expect do
          fields = ['greeting', 'get_started']
          subject.unset(fields, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Profile::Error, error_message
        )
      end
    end
  end
end
