# frozen_string_literal: true

module FirstACH
  module Customer
    # Customer Profile
    class Profile
      include FirstACH::XML

      SCHEMA = [
        :customerName, :customerID, :address1, :city, :state, :zip, :phone, :email, :fax, :drvLic,
        :drvState, :custom1, :custom2
      ].freeze

      # Create Customer Profile
      # @param name                 [String - Alphanumeric 50]  Name of Customer
      # @param id                   [String - Alphanumeric 50]  Merchant-specified identifier of Customer
      # @param address              [String - Alphanumeric 100] Address of Customer
      # @param city                 [String - Alpha 50]         City of Customer
      # @param state                [String - Alpha 2]          Valid 2-character state abbreviation
      # @param zip                  [String - Numeric 5]        Zip code of Customer
      # @param phone                [String - Alphanumeric 12]  Phone number of Customer: xxx-xxx-xxxx
      # @param email                [String - Alphanumeric 50]  Email address of Customer
      # @param fax                  [String - Alphanumeric 12]  Fax number of Customer: xxx-xxx-xxxx
      # @param driver_licence_id    [String - Alphanumeric 50]  Driver's License ID number of Customer
      # @param driver_licence_state [String - Alpha 2]          Valid 2-character state abbreviation
      # @param custom_one           [String - Alphanumeric 100] Permitted if custom field has been previously enabled
      # @param custom_two           [String - Alphanumeric 100] Permitted if custom field has been previously enabled
      def self.create(name:, id: nil, address:, city:, state:, zip:, phone:, email: nil, fax: nil, driver_licence_id: nil, driver_licence_state: nil, custom_one: nil, custom_two: nil)
        parameters                = arguments(__method__, binding)
        parameters[:customerName] = parameters.delete(:name)
        parameters[:customerID]   = parameters.delete(:id)
        parameters[:address1]     = parameters.delete(:address)
        parameters[:drvLic]       = parameters.delete(:driverLicenceId)
        parameters[:drvState]     = parameters.delete(:driverLicenceState)
        parameters[:custom1]      = parameters.delete(:customOne)
        parameters[:custom2]      = parameters.delete(:customTwo)
        parameters                = SCHEMA.map { |key| [key, parameters[key]] }

        payload = build_document('createCustomerProfile') do |document|
          build_object(document, 'customerProfile', parameters)
        end

        FirstACH::Client.execute(:post, payload)
      end

      # UpdateCustomerProfile
      # DeleteCustomerProfile
    end
  end
end
