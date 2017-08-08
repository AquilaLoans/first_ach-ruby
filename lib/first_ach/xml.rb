# frozen_string_literal: true

module FirstACH
  module XML
    extend ActiveSupport::Concern

    class_methods do
      def build_document(endpoint)
        Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |document|
          build_namespace(document, endpoint) do
            build_authentication(document)
            yield document
          end
        end.to_xml
      end

      def build_namespace(document, endpoint)
        document.public_send(
          endpoint,
          'xmlns'              => 'https://www.firstach.com',
          'xmlns:xsi'          => 'http://www.w3.org/2001/XMLSchema-instance',
          'xsi:schemaLocation' => "https://#{FirstACH.configuration.environment}.firstach.com ../XSD/API_#{endpoint.upcase_first}.xsd"
        ) { yield document }
      end

      def build_authentication(document)
        document.requestorAuthentication do
          document.loginID        ::FirstACH.configuration.login_id
          document.transactionKey ::FirstACH.configuration.transaction_key
        end
      end

      def build_object(document, name, object)
        return if object.nil?

        name = "#{name}_" if [:type, :class, :id].include?(name.to_sym)

        case object
        when String, Integer, Integer, Numeric, Float, Symbol, Range
          document.public_send(name, object)
        when Hash
          document.public_send(name) do
            object.each { |key, value| build_object(document, key, value) }
          end
        else # Array
          raise 'NotImplemented'
        end
      end

      def arguments(method_context, invocation_context)
        arguments_hash = {}

        method(method_context).parameters.map(&:last).each do |key|
          value = invocation_context.local_variable_get(key)
          arguments_hash[key.to_s.camelize(:lower).to_sym] = value unless value.nil?
        end

        arguments_hash
      end
    end
  end
end
