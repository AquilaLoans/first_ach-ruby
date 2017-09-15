# frozen_string_literal: true

module FirstACH
  # HTTP Client Interface
  class Client
    SUCCESS_CODE = '0000'

    def self.execute(method, payload)
      url = "https://#{FirstACH.configuration.environment}.firstach.com/API/processAPIRequest.aspx"

      raw_response = RestClient::Request.execute(
        method:  method,
        url:     url,
        headers: default_headers,
        payload: payload,
        timeout: ::FirstACH.configuration.timeout
      )

      return nil if raw_response.body.empty?

      response = parse_object(Nokogiri::XML(raw_response.body).root)

      if response.messages.code == SUCCESS_CODE
        response[response.to_h.tap { |hash| hash.delete(:messages) }.keys.last]
      else
        response.messages.message =  "#{response.messages.message} PAYLOAD: #{payload} RAW RESPONSE: #{raw_response.body}"

        raise FirstACH::Error, response.messages
      end
    end

    # @!visibility private
    def self.parse_object(node)
      case node
      when Nokogiri::XML::Document, Nokogiri::XML::Element
        if node.children.count == 1 && node.child.class == Nokogiri::XML::Text
          parse_object(node.child)
        else
          OpenStruct.new(node.children.map { |child| [parse_name(child.name), parse_object(child)] }.to_h)
        end
      when Nokogiri::XML::Text
        node.text
      end
    end
    private_class_method :parse_object

    # @!visibility private
    def self.parse_name(name)
      name.underscore.gsub('response_', '').to_sym
    end
    private_class_method :parse_name

    # @!visibility private
    def self.default_headers
      {
        'Accept'       => 'application/xml',
        'Content-Type' => 'application/xml'
      }
    end
    private_class_method :default_headers
  end
end
