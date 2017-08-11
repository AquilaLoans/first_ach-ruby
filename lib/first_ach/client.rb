# frozen_string_literal: true

module FirstACH
  # HTTP Client Interface
  class Client
    def self.execute(method, payload)
      url = "https://#{FirstACH.configuration.environment}.firstach.com/API/processAPIRequest.aspx"

      raw_response = RestClient::Request.execute(
        method:  method,
        url:     url,
        headers: default_headers,
        payload: payload
      )

      return nil if raw_response.body.empty?

      parse_object(Nokogiri::XML(raw_response.body).root)
    end

    # @!visibility private
    def self.parse_object(node)
      case node
      when Nokogiri::XML::Document, Nokogiri::XML::Element
        if node.children.count == 1 && node.child.class == Nokogiri::XML::Text
          parse_object(node.child)
        else
          OpenStruct.new(node.children.map { |child| [child.name.to_sym, parse_object(child)] }.to_h)
        end
      when Nokogiri::XML::Text
        node.text
      end
    end
    private_class_method :parse_object

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
